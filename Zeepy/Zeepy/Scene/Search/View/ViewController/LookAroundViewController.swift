//
//  LookAroundViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class LookAroundViewController: BaseViewController {
  private let headerView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.addUnderBar()
    return v
  }()
  private let currentLocation = UILabel().then{
    $0.adjustsFontSizeToFitWidth = true
    $0.font = .nanumRoundExtraBold(fontSize: 20)
    $0.text = "한강로동 2가"
    $0.textColor = .blackText
  }
  private let locationDropDown = UIButton().then{
    $0.setImage(UIImage(named: "btnArrowDown"), for: .normal)
  }
  
  private let filterButton = UIButton().then{
    $0.setImageByName("iconFilter")
  }
  private let mapButton = UIButton().then{
    $0.setImageByName("iconMap")
  }
  private var tableViewHeader: UICollectionView!
  private let tableView = UITableView()
  private let loadViewTrigger = BehaviorSubject<Int>(value: 0)
  private let conditionFilter = BehaviorSubject<BuildingRequest?>(value: nil)
  private let viewModel: LookAroundViewModel = LookAroundViewModel()
  private var currentPage = 0
  let filterTrigger = PublishSubject<ValidateType?>()
  private let refreshController = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    setupCollectionView()
    setupTableView()
    layout()
    refreshCell()
    bind()
    bindAction()
  }
  private func refreshCell() {
    refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    tableView.refreshControl = refreshController
  }
  @objc
  private func refreshData() {
    loadViewTrigger.onNext(0)
    refreshController.endRefreshing()
  }
  @objc
  private func didReceiveNotification(_ notification: Notification) {
    if self.currentLocation.text != UserManager.shared.currentAddress?.primaryAddress {
      self.currentLocation.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 없음"
      loadViewTrigger.onNext(0)
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name("address"), object: nil)
    if self.currentLocation.text != UserManager.shared.currentAddress?.primaryAddress {
      loadViewTrigger.onNext(0)
    }
    self.currentLocation.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 없음"
    
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self,name: Notification.Name("address"), object: nil)
    //self.navigationController?.isNavigationBarHidden = false
    
    
  }
}
extension LookAroundViewController {
  private func bind() {
    let buildingSelection = Observable.zip(tableView.rx.itemSelected,
                                           tableView.rx.modelSelected(BuildingModel.self).asObservable())
    
    let filterSelectUsecase = Observable.zip(tableViewHeader.rx.itemSelected,
                                             tableViewHeader.rx.modelSelected(FilterModel.self).asObservable())
    
    let inputs = LookAroundViewModel.Input(loadTrigger: loadViewTrigger,
                                           filterAction: filterButton.rx.tap.asObservable(),
                                           ownerFilterAction: filterTrigger,
                                           mapSelectAction: mapButton.rx.tap.asObservable(),
                                           conditionFilter: conditionFilter,
                                           buildingSelect: buildingSelection,
                                           filterSelect: filterSelectUsecase)
    let outputs = viewModel.transForm(inputs: inputs)
    
    outputs.buildingUsecase
      .filter{!$0.isEmpty}
      .bind(to: tableView.rx.items(cellIdentifier: LookAroundTableViewCell.identifier,
                                   cellType: LookAroundTableViewCell.self)) { [weak self] row, data, cell in
        cell.bind(model: data)
        print(row)
        if row > 18 * ((self?.currentPage ?? 0) + 1) {
          
          self?.loadViewTrigger.onNext((self?.currentPage ?? 0) + 1)
        }
      }.disposed(by: disposeBag)
    outputs.buildingUsecase
      .filter{$0.isEmpty}
      .map{_ in return ["empty"]}
      .bind(to: tableView.rx.items(cellIdentifier: LookAroundTableViewCell.identifier,
                                   cellType: LookAroundTableViewCell.self)) { [weak self] row, data, cell in
        cell.bind()
      }.disposed(by: disposeBag)
    loadViewTrigger.bind{[weak self] page in
      self?.currentPage = page
      print(page)
    }.disposed(by: disposeBag)
    outputs.buildingDetailParam
      .bind{ [weak self] model in
        if let vc = LookAroundDetailViewController(nibName: nil, bundle: nil, model: model.buildingId) {
          vc.hidesBottomBarWhenPushed = true
          self?.navigationController?.pushViewController(vc, animated: true)
        }
      }.disposed(by: disposeBag)
    
    outputs.filterUsecase
      .bind(to: tableViewHeader.rx.items(cellIdentifier: tableViewHeaderCollectionViewCell.identifier,
                                         cellType: tableViewHeaderCollectionViewCell.self)) {row, data, cell in
        cell.bindCell(data, first: row == 0 && data.title == "전체")
      }.disposed(by: disposeBag)
    
    filterButton.rx.tap.bind{[weak self] in
      if self?.filterButton.isSelected == true {
        self?.conditionFilter.onNext(nil)
      }
      else {
        let vc = ConditionViewController(nibName: nil, bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        vc.resultClosure = {[weak self] requestModel in
          self?.conditionFilter.onNext(requestModel)
          self?.filterButton.isSelected = true
        }
        self?.navigationController?.pushViewController(vc, animated : true)
      }
    }.disposed(by: disposeBag)
    mapButton.rx.tap.bind{[weak self] in
      let vc = MapViewController(nibName: nil, bundle: nil)
      vc.hidesBottomBarWhenPushed = true
      self?.navigationController?.pushViewController(vc, animated : true)
    }.disposed(by: disposeBag)
    locationDropDown.rx.tap.bind{[weak self] in
      let view = SettingView()
      HalfAppearView.shared.appearHalfView(subView: view)
      
      view.setUpTableView([("전체",{self?.filterTrigger.onNext(nil)}),
                           ("칼 같은 우리 사이, 비즈니스형",{self?.filterTrigger.onNext(.business)}),
                           ("따뜻해 녹아내리는 중! 친절형",{self?.filterTrigger.onNext(.kind)}),
                           ("자유롭게만 살아다오, 방목형",{self?.filterTrigger.onNext(.free)}),
                           ("겉은 바삭 속은 촉촉! 츤데레형",{self?.filterTrigger.onNext(.cute)}),
                           ("할말은 많지만 하지 않을래요 :(",{self?.filterTrigger.onNext(.bad)}),
                           
      ])
    }.disposed(by: disposeBag)
    
  }
  private func bindAction() {
    
  }
}
extension LookAroundViewController {
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: 63, height: 28)
    layout.minimumLineSpacing = 4
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    self.tableViewHeader = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.tableViewHeader.register(tableViewHeaderCollectionViewCell.self,
                                  forCellWithReuseIdentifier: tableViewHeaderCollectionViewCell.identifier)
    self.tableViewHeader.backgroundColor = .white
    self.tableViewHeader.showsVerticalScrollIndicator = false
    self.tableViewHeader.showsHorizontalScrollIndicator = false
  }
  private func setupTableView() {
    self.tableView.backgroundColor = .white
    self.tableView.separatorStyle = .none
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 108
    self.tableView.register(LookAroundTableViewCell.self,
                            forCellReuseIdentifier: LookAroundTableViewCell.identifier)
  }
  private func layout() {
    self.view.adds([headerView,tableViewHeader,tableView])
    
    headerView.snp.makeConstraints{
      $0.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    tableViewHeader.snp.makeConstraints{
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(0)
    }
    tableViewHeader.isHidden = true
    tableView.snp.makeConstraints{
      $0.top.equalTo(tableViewHeader.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    headerView.adds([currentLocation,
                     locationDropDown,
                     filterButton,
                     mapButton])
    currentLocation.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    locationDropDown.snp.makeConstraints{
      $0.height.width.equalTo(24)
      $0.leading.equalTo(currentLocation.snp.trailing)
      $0.centerY.equalTo(currentLocation)
    }
    mapButton.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16)
      $0.width.height.equalTo(24)
    }
    filterButton.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(mapButton.snp.leading).offset(-4)
      $0.width.height.equalTo(24)
    }
  }
}
extension LookAroundViewController {
  
}
