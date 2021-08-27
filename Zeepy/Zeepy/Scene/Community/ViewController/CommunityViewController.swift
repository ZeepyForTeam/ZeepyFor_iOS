//
//  CommunityViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/05.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class CommunityViewController : BaseViewController {
  private let naviView = UIView().then{
    $0.backgroundColor = .white
    $0.addUnderBar()
  }
  private let dropDown = UIButton().then{
    $0.setImage(UIImage(named: "btnArrowDown"), for: .normal)
  }
  private let naviTitle = UILabel().then{
    $0.text = "한강로동 2가"
    $0.font = .nanumRoundExtraBold(fontSize: 20)
  }
  private let writeBtn = UIButton().then{
    $0.setImage(UIImage(named:"btn_write"), for: .normal)
  }
  private let viewModel = CommunityViewModel()
  private let selectedType = BehaviorSubject<PostType>(value: .total)
  private let resetAddress = PublishSubject<[Addresses]>()
  private let pagenation = BehaviorSubject<Int?>(value: 0)
  var currentPage = 0
  private let loadViewTrigger = PublishSubject<Void>()
  private let currentTab = BehaviorSubject<Int>(value: 0)
  private func setUpNavi() {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    self.view.add(naviView)
    naviView.snp.makeConstraints{
      $0.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    naviView.adds([naviTitle,dropDown,writeBtn])
    naviTitle.snp.makeConstraints{
      $0.bottom.equalToSuperview().offset(-20)
      $0.leading.equalToSuperview().offset(16)
    }
    dropDown.snp.makeConstraints{
      $0.width.height.equalTo(24)
      $0.leading.equalTo(naviTitle.snp.trailing)
      $0.centerY.equalTo(naviTitle)
    }
    writeBtn.snp.makeConstraints{
      $0.centerY.equalTo(dropDown)
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  private let segmentView = UIView().then{
    $0.backgroundColor = .white
  }
  private let postTab = UIView()
    .then{
      $0.backgroundColor = .white
    }
  private let postTablabel = UILabel().then{
    $0.text = "이야기ZIP"
    $0.font = .nanumRoundExtraBold(fontSize: 14)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  private let myTab = UIView()
    .then{
      $0.backgroundColor = .white
    }
  let myTablabel = UILabel().then{
    $0.text = "참여목록"
    $0.font = .nanumRoundExtraBold(fontSize: 14)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  private let indicator = UIView().then{
    $0.setRounded(radius: 2)
    $0.backgroundColor = .communityGreen
  }
  private func setUpSegment() {
    self.view.add(segmentView)
    segmentView.adds([postTab, myTab, indicator])
    segmentView.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(naviView.snp.bottom)
      $0.height.equalTo(56)
    }
    
    indicator.snp.makeConstraints{
      $0.width.equalTo(167)
      $0.height.equalTo(4)
      $0.bottom.equalToSuperview().offset(-8)
      $0.leading.equalToSuperview().offset(16)
    }
    postTab.snp.makeConstraints{
      $0.top.leading.bottom.equalToSuperview()
      
      $0.width.equalTo(myTab.snp.width)
    }
    postTab.add(postTablabel)
    postTablabel.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    myTab.snp.makeConstraints{
      $0.top.trailing.bottom.equalToSuperview()
      $0.leading.equalTo(postTab.snp.trailing)
    }
    
    myTab.add(myTablabel)
    myTablabel.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    postTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab1Action(sender:))))
    myTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tab2Action(sender:))))
    
  }
  private var segmentCollectionView : UICollectionView!
  private var postFilterCollectionView : UICollectionView!
  @objc
  private func tab1Action(sender : UITapGestureRecognizer) {
    setTabView(tabIndex: 0)
    moveColletionViewNextPage(tabIndex: 0)
  }
  @objc
  private func tab2Action(sender : UITapGestureRecognizer) {
    setTabView(tabIndex: 1)
    moveColletionViewNextPage(tabIndex: 1)
  }
  @objc
  private func didReceiveNotification(_ notification: Notification) {
    if self.naviTitle.text != UserManager.shared.currentAddress?.primaryAddress {
      self.naviTitle.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 없음"
      loadViewTrigger.onNext(())
      selectedType.onNext(.total)
    }
  }
  private func setTabView(tabIndex i : Int) {
    // default, selected
    currentTab.onNext(i)

    myTablabel.font = i == 1 ? .nanumRoundExtraBold(fontSize: 14) : .nanumRoundRegular(fontSize: 14)
    postTablabel.font = i == 0 ? .nanumRoundExtraBold(fontSize: 14) : .nanumRoundRegular(fontSize: 14)
    
    myTablabel.textColor = i == 0 ? .grayText : .blackText
    postTablabel.textColor = i == 1 ? .grayText : .blackText
    if i == 1 {
      UIView.animate(withDuration: 0.2) {
        self.postFilterCollectionView.alpha = 0
      }
    }
    else {
      UIView.animate(withDuration: 0.2) {
        self.postFilterCollectionView.alpha = 1
      }
    }
  }
  private func moveColletionViewNextPage(tabIndex:Int) {
    UIView.animate(withDuration: 0.2) {
      self.segmentCollectionView.contentOffset.x = CGFloat(tabIndex) * CGFloat(UIScreen.main.bounds.width)
    }
  }
  
}
extension CommunityViewController : UICollectionViewDelegate{
  private func setupCollectionView() {
    let filterlayout = UICollectionViewFlowLayout().then{
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 8
      $0.itemSize = UICollectionViewFlowLayout.automaticSize
      $0.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height : 30)
      $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    postFilterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filterlayout)
    postFilterCollectionView.register(PostFilterCollectionViewCell.self,
                                      forCellWithReuseIdentifier: PostFilterCollectionViewCell.identifier)
    
    
    postFilterCollectionView.backgroundColor = .white
    postFilterCollectionView.showsHorizontalScrollIndicator = false
    postFilterCollectionView.showsVerticalScrollIndicator = false
    
    let offset = Int((UIScreen.main.bounds.width / 2.0 - 167)/2)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 629)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    segmentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    segmentCollectionView.backgroundColor = .white
    segmentCollectionView.isPagingEnabled = true
    segmentCollectionView.register(TapCell.self, forCellWithReuseIdentifier: TapCell.identifier)
    segmentCollectionView.showsHorizontalScrollIndicator = false
    segmentCollectionView.showsVerticalScrollIndicator = false
    segmentCollectionView.bounces = true
    segmentCollectionView.isHidden = false
    indicator.frame.size.width = 167
    indicator.frame.origin.x = CGFloat(offset)
    segmentCollectionView.rx.didScroll
      .map{[unowned self] in self.segmentCollectionView.contentOffset.x}
      .bind(onNext: { [unowned self] in
        let itemIndex = Int(($0 / UIScreen.main.bounds.width).rounded())
        let indicatorWidth = 167
        UIView.animate(withDuration: 0.2) {
          setTabView(tabIndex: itemIndex)
          indicator.frame.origin.x = CGFloat(itemIndex) * (CGFloat(indicatorWidth + offset * 2)) + CGFloat(offset)
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: disposeBag)
    
    self.view.adds([segmentCollectionView, postFilterCollectionView])
    segmentCollectionView.snp.makeConstraints{
      $0.top.equalTo(segmentView.snp.bottom).offset(4)
      $0.width.equalTo(self.view.frame.width)
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    postFilterCollectionView.snp.makeConstraints{
      $0.top.equalTo(segmentView.snp.bottom).offset(4)
      $0.width.equalTo(self.view.frame.width)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(44)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNavi()
    setUpSegment()
    setupCollectionView()
    bind()
  }
  private func fromHome(type: PostType) {
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.naviTitle.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 없음"
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name("address"), object: nil)
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self,name: Notification.Name("address"), object: nil)
  }
  func bind() {
    let selection = Observable.zip (postFilterCollectionView.rx.itemSelected,
                                    postFilterCollectionView.rx.modelSelected((PostType, Bool).self))
    let input = CommunityViewModel.Input(currentTab:currentTab,
                                         loadView: loadViewTrigger,
                                         filterSelect: selection,
                                         filterSelect2: selectedType,
                                         resetAddress: resetAddress,
                                         pageNumber: pagenation)
    let output = viewModel.transform(input: input)
    
    output.filterUsecase.bind(to: postFilterCollectionView.rx
                                .items(cellIdentifier: PostFilterCollectionViewCell.identifier,
                                       cellType: PostFilterCollectionViewCell.self)) {row, data, cell in
      cell.bindCell(str: data.0.rawValue, selected: data.1)
    }.disposed(by: disposeBag)
    output.resetAddress.bind{[weak self] result in
      if result {
        self?.loadViewTrigger.onNext(())
        self?.selectedType.onNext(.total)

      }
    }.disposed(by: disposeBag)
    Observable.just([0, 1])
      .bind(to: segmentCollectionView.rx.items(cellIdentifier: TapCell.identifier,
                                               cellType: TapCell.self)) { [weak self] row, data, cell in
        guard let self = self else {return}
        cell.currentTab = data
        cell.layout()
        cell.viewModel = self.viewModel
        cell.changeCollectionViewSection(tab: data)
        cell.bind(output: output, dispose: self.disposeBag)
        
      }.disposed(by: disposeBag)
    
    dropDown.rx.tap.filter{!UserManager.shared.address.isEmpty}.bind{[weak self] in
      Dropdown.shared.addDropDown(items: UserManager.shared.address,
                                  disposeBag: self!.disposeBag,
                                  dissmissAction: { [weak self] in
                                    self?.naviTitle.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 선택"
                                    self?.resetAddress.onNext(UserManager.shared.address)
                                  },
                                  currentItemKey: UserManager.shared.currentAddress)
    }.disposed(by: disposeBag)
   
    writeBtn.rx.tap.bind{[weak self] in
      let vc = PostViewController()
      vc.hidesBottomBarWhenPushed = true
      
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
    postFilterCollectionView.rx.modelSelected((PostType, Bool).self)
      .map{$0.0}
      .bind(to: selectedType)
      .disposed(by: disposeBag)
    loadViewTrigger.onNext(())
  }
}
