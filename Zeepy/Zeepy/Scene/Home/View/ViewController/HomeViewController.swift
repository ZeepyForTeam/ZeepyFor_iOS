//
//  HomeViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class HomeViewController : BaseViewController {
  private let headerView: UIView = {
    let v = UIView()
    v.addUnderBar()
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
    $0.setImage(UIImage(named: "btnArrowDown"), for: .normal)
  }
  private let scrollView = UIScrollView()
  private let contentView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let serviceLocationNoticeIcon = UIImageView().then {
    $0.image = UIImage(named: "fluent_info-20-regular")
  }
  private let serviceLocationNotice = UILabel().then {
    $0.setupLabel(text: "서울 강북, 세종 지역 오픈!", color: .grayText, font: .nanumRoundBold(fontSize: 10))
  }
  private let writeReviewButton = UIButton().then {
    $0.setTitle("자취방 후기 작성하기", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray244
  }
  private let selectTypeLabel = UILabel().then {
    $0.setupLabel(text: "성향에 맞는 자취방 고르자!", color: .blackText, font: .nanumRoundExtraBold(fontSize: 20))
  }
  private var selectTypeCollectionView: UICollectionView!
  private let communityTypeLabel = UILabel().then {
    $0.setupLabel(text: "우리 동네 자취생 다모았ZIP", color: .blackText, font: .nanumRoundExtraBold(fontSize: 20))
  }
  private let buyButton = UIButton().then {
    $0.setTitle("공동구매", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray244
  }
  private let shareButton = UIButton().then {
    $0.setTitle("무료나눔", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray244
  }
  private let friendButton = UIButton().then {
    $0.setTitle("동네친구", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray244
  }
  private let resetAddress = PublishSubject<[Addresses]>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    
    layout()
    bind()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.currentLocation.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 없음"
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name("address"), object: nil)

  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self,name: Notification.Name("address"), object: nil)
  }
  @objc
  private func didReceiveNotification(_ notification: Notification) {
    self.currentLocation.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 없음"
  }
  private func layout() {
    setUpCollectionView()
    self.view.adds([headerView,
                    scrollView])
    scrollView.add(contentView)
    contentView.adds([serviceLocationNoticeIcon,
                      serviceLocationNotice,
                      writeReviewButton,
                      selectTypeLabel,
                      selectTypeCollectionView,
                      communityTypeLabel,
                      buyButton,
                      shareButton,
                      friendButton
    ])
    headerView.snp.makeConstraints{
      $0.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    scrollView.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(headerView.snp.bottom)
    }
    contentView.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
      $0.height.equalToSuperview().priority(250)
      $0.width .equalToSuperview()
    }
    headerView.adds([currentLocation,
                     locationDropDown])
    currentLocation.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    locationDropDown.snp.makeConstraints{
      $0.height.width.equalTo(24)
      $0.leading.equalTo(currentLocation.snp.trailing)
      $0.centerY.equalTo(currentLocation)
    }
    serviceLocationNoticeIcon.snp.makeConstraints{
      $0.top.equalToSuperview().offset(19)
      $0.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(14)
    }
    serviceLocationNotice.snp.makeConstraints{
      $0.centerY.equalTo(serviceLocationNoticeIcon)
      $0.leading.equalTo(serviceLocationNoticeIcon.snp.trailing).offset(4)
    }
    writeReviewButton.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(serviceLocationNoticeIcon.snp.bottom).offset(7)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(50)
    }
    selectTypeLabel.snp.makeConstraints{
      $0.top.equalTo(writeReviewButton.snp.bottom).offset(36)
      $0.leading.equalToSuperview().offset(16)
    }
    selectTypeCollectionView.snp.makeConstraints{
      $0.top.equalTo(selectTypeLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(195)
    }
    communityTypeLabel.snp.makeConstraints{
      $0.top.equalTo(selectTypeCollectionView.snp.bottom).offset(64)
      $0.leading.equalToSuperview().offset(16)
    }
    buyButton.snp.makeConstraints{
      $0.top.equalTo(communityTypeLabel.snp.bottom).offset(20)
      $0.width.height.centerY.equalTo(shareButton)
      $0.width.height.centerY.equalTo(friendButton)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(50)
      $0.bottom.equalToSuperview().offset(-80)
    }
    shareButton.snp.makeConstraints{
      $0.leading.equalTo(buyButton.snp.trailing).offset(8)
    }
    friendButton.snp.makeConstraints{
      $0.leading.equalTo(shareButton.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().offset(-16)
    }
  
    
  }
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: 141, height: 194)
    layout.minimumInteritemSpacing = 8
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    selectTypeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    selectTypeCollectionView.showsHorizontalScrollIndicator = false
    selectTypeCollectionView.backgroundColor = .white
    selectTypeCollectionView.showsHorizontalScrollIndicator = false
    selectTypeCollectionView.register(SelectTypeCollectionViewCell.self,
                                      forCellWithReuseIdentifier: SelectTypeCollectionViewCell.identifier)
  }
  
  private let viewModel = HomeViewModel()
  private let buildingType = PublishSubject<ValidateType>()
  private let communityType = PublishSubject<PostType>()
  private let types = Observable.just([ValidateType.business,
                                       ValidateType.kind,
                                       ValidateType.free,
                                       ValidateType.cute,
                                       ValidateType.bad,
                                       ValidateType.total])
  private func bind() {
    
    
    let inputs = HomeViewModel.Input.init(resetAddress: resetAddress,
      writeReview: writeReviewButton.rx.tap.asObservable())
    let output = viewModel.transform(inputs: inputs)
    output.writeVC.bind{[weak self] vc in
      vc.hidesBottomBarWhenPushed = true
      
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
    output.resetResult.bind{
      print($0)
    }.disposed(by: disposeBag)
     types.bind(to: selectTypeCollectionView.rx.items(cellIdentifier: SelectTypeCollectionViewCell.identifier, cellType: SelectTypeCollectionViewCell.self)) {row, data, cell in
      cell.bind(type: data)
    }.disposed(by: disposeBag)

    selectTypeCollectionView.rx.modelSelected(ValidateType.self)
      .bind{[weak self] type in
        self?.tabBarController?.selectedIndex = 1
        if let lookaround = self?.tabBarController?.selectedViewController?.children.first as? LookAroundViewController {
          lookaround.fromHome(type: .init(title: type, selected: false))
          
        }
      }
      .disposed(by: disposeBag)
    communityType.bind{[weak self] type in
      self?.tabBarController?.selectedIndex = 2
      if let community = self?.tabBarController?.selectedViewController?.children.first as? CommunityViewController {
        community.type = type
        print(type)
        
      }
    }
    .disposed(by: disposeBag)
    locationDropDown.rx.tap.filter{!UserManager.shared.address.isEmpty}.bind{[weak self] in
      Dropdown.shared.addDropDown(items: UserManager.shared.address,
                                  disposeBag: self!.disposeBag,
                                  dissmissAction: { [weak self] in
                                    self?.currentLocation.text = UserManager.shared.currentAddress?.primaryAddress ?? "주소 선택"
                                    self?.resetAddress.onNext(UserManager.shared.address)
                                  },
                                  currentItemKey: UserManager.shared.currentAddress,
                                  color: UIColor.mainYellow)
    }.disposed(by: disposeBag)
    locationDropDown.rx.tap.filter{UserManager.shared.address.isEmpty}
      .bind{[weak self] in
        let vc = ManageAddressViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController?.setNavigationBarHidden(true, animated: false)
        self?.navigationController?.pushViewController(vc, animated: true)
      }.disposed(by: disposeBag)
    buyButton.rx.tap.map{return PostType.deal}.bind(to: communityType).disposed(by: disposeBag)
    shareButton.rx.tap.map{return PostType.share}.bind(to: communityType).disposed(by: disposeBag)
    friendButton.rx.tap.map{return PostType.friend}.bind(to: communityType).disposed(by: disposeBag)
  }
}








class SelectTypeCollectionViewCell : UICollectionViewCell {
  private let iconImage = UIImageView()
  private let iconName = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 20))
  }
  private let iconNameKr = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 10))
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    layout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func layout() {
    self.setRounded(radius: 8)
    self.adds([iconImage,
               iconName,
               iconNameKr])
    iconImage.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(109)
    }
    iconName.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(iconImage.snp.bottom).offset(13)
    }
    iconNameKr.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(iconName.snp.bottom).offset(6)
      $0.bottom.equalToSuperview().offset(-16)
    }
  }
  func bind(type: ValidateType) {
    let text = UILabel().then {
      $0.setupLabel(text: "유형 모두 보기", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
    }
    if type == .total {
      self.iconName.isHidden = true
      self.iconImage.isHidden = true
      self.iconNameKr.isHidden = true
      self.add(text)
      self.backgroundColor = type.color

      text.isHidden = false
      text.snp.remakeConstraints{
        $0.centerX.centerY.equalToSuperview()
      }
    }
    else {
      self.iconName.isHidden = false
      self.iconImage.isHidden = false
      self.iconNameKr.isHidden = false
      text.isHidden = true
//      text.snp.removeConstraints()
      text.removeFromSuperview()

      self.iconImage.image = UIImage(named: type.image)
      self.backgroundColor = type.color
      self.iconName.text = type.inEnglish
      self.iconNameKr.text = type.rawValue
    }
  }
}
