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
    return v
  }()
  private let currentLocation = UILabel().then{
    $0.adjustsFontSizeToFitWidth = true
    $0.font = .nanumRoundExtraBold(fontSize: 20)
    $0.text = "한강로동 2가"
    $0.textColor = .blackText
  }
  private let locationDropDown = UIButton().then{
    $0.setImage(UIImage(named: ""), for: .normal)
  }
  private let filterButton = UIButton().then{
    $0.setImageByName("iconFilter")
  }
  private let mapButton = UIButton().then{
    $0.setImageByName("iconMap")
  }
  private var tableViewHeader: UICollectionView!
  private let tableView = UITableView()
  private let loadViewTrigger = PublishSubject<Void>()
  private let viewModel: LookAroundViewModel = LookAroundViewModel()
  
  private let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    setupCollectionView()
    setupTableView()
    layout()
    bind()
    bindAction()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
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
                                           mapSelectAction: mapButton.rx.tap.asObservable(),
                                           buildingSelect: buildingSelection,
                                           filterSelect: filterSelectUsecase)
    let outputs = viewModel.transForm(inputs: inputs)
    
    outputs.buildingUsecase
      .bind(to: tableView.rx.items(cellIdentifier: LookAroundTableViewCell.identifier,
                                                        cellType: LookAroundTableViewCell.self)) { [weak self] row, data, cell in
        cell.bind(model: data)
      }.disposed(by: disposeBag)
    outputs.buildingDetailParam
      .bind{ [weak self] model in
        if let vc = LookAroundDetailViewController(nibName: nil, bundle: nil, model: model) {
          self?.navigationController?.pushViewController(vc, animated: true)
        }
      }.disposed(by: disposeBag)
    
    outputs.filterUsecase
      .bind(to: tableViewHeader.rx.items(cellIdentifier: tableViewHeaderCollectionViewCell.identifier,
                                                            cellType: tableViewHeaderCollectionViewCell.self)) {row, data, cell in
        cell.bindCell(data, first: row == 0 && data.title == "전체")
    }.disposed(by: disposeBag)
    
    filterButton.rx.tap.bind{[weak self] in
      let vc = ConditionViewController(nibName: nil, bundle: nil)
      self?.navigationController?.pushViewController(vc, animated : true)
    }.disposed(by: disposeBag)
    mapButton.rx.tap.bind{[weak self] in
      let vc = SearchViewController(nibName: nil, bundle: nil)
      self?.navigationController?.pushViewController(vc, animated : true)
    }.disposed(by: disposeBag)
    loadViewTrigger.onNext(())
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
      $0.height.equalTo(60)
    }
    tableViewHeader.snp.makeConstraints{
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(44)
    }
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
