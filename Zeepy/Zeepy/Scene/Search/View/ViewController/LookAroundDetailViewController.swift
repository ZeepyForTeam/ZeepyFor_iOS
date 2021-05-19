//
//  LookAroundDetailViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/03.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
class LookAroundDetailViewController: BaseViewController {
  private let model : BuildingModel!
  private let viewModle = LookAroundDetailViewModel()
  private let loadTrigger = PublishSubject<Void>()
  private let disposeBag = DisposeBag()
  private let navigationView = UIView().then{
    $0.backgroundColor = .white
    let underBar = UIView().then{
      $0.backgroundColor = .gray244
    }
    $0.add(underBar)
    underBar.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  private let naviTitle = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 20)
  }
  private let leftBarBtn = UIButton().then {
    $0.setImage(UIImage(named: "btnBack"), for: .normal)
    $0.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
  }
  private let likeBtn = UIButton().then {
    
    $0.setImage(UIImage(named: "btnLikeUnselected"), for: .normal)

    $0.setImage(UIImage(named: "btnLike"), for: .selected)
  }
  private let scrollView = UIScrollView()
  private let containerView = UIView()
  private let addressView = UIView().then{
    $0.setRounded(radius: 12)
    $0.borderWidth = 1
    $0.borderColor = .mainBlue
  }
  private let addressLabel = UILabel().then {
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let buildingType = UILabel().then{
    $0.textColor = .mainBlue
    $0.textAlignment = .center
    $0.text = "건물 유형"
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let buildingTypeLabel = UILabel().then{
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.font = .nanumRoundRegular(fontSize: 14)
  }
  private let tradeType = UILabel().then{
    $0.textColor = .mainBlue
    $0.textAlignment = .center
    $0.text = "거래 종류"

    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let tradeTypeLabel = UILabel().then{
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.font = .nanumRoundRegular(fontSize: 14)
  }
  private let optionsLabel = UILabel().then{
  $0.textColor = .mainBlue
  $0.textAlignment = .center
    $0.text = "특징"

  $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let options = UILabel().then{
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.font = .nanumRoundRegular(fontSize: 14)
  }
  private let photoReviewTitle = UILabel().then{
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.text = "포토리뷰"
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let imagesBackground = UIView().then {
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  private var imageCollectionView: UICollectionView!
  private let ownerTypeLabel = UILabel().then{
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.text = "임대인 성향"
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let ownerTypeView = UIView().then{
    $0.backgroundColor = .white
  }
  private let ownerTypes : [OwnerTypeView] = [.init(),.init(),.init(),.init(),.init()]

  private let buildingReviewTitle = UILabel().then{
    $0.textColor = .blackText
    $0.textAlignment = .center
    $0.text = "건물 리뷰"
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let reviewView = UIView().then {
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  init?(nibName: String?, bundle: Bundle?,
        model : BuildingModel)
  {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension LookAroundDetailViewController {
  private func layout() {
    self.view.adds([navigationView,
                    scrollView])
    navigationView.adds([naviTitle, leftBarBtn, likeBtn])
    navigationView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
    leftBarBtn.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.width.height.equalTo(24)
      $0.bottom.equalToSuperview().offset(-18)
    }
    naviTitle.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(leftBarBtn.snp.trailing).offset(8)
    }
    likeBtn.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-10)
      $0.width.height.equalTo(36)
    }
    
    scrollView.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(navigationView.snp.bottom)
    }
    scrollView.add(containerView)
    containerView.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height).priority(250)
    }
    containerView.adds([addressView,
    buildingType,
    buildingTypeLabel,
    tradeType,
    tradeTypeLabel,
    optionsLabel,
    options,
    photoReviewTitle,
    imagesBackground,
    ownerTypeLabel,
    ownerTypeView,
    buildingReviewTitle,
    reviewView])
    addressView.add(addressLabel)
    addressView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(12)
      $0.height.equalTo(24)
    }
    addressLabel.snp.makeConstraints{
      $0.centerY.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(12)
      $0.top.equalToSuperview().offset(4)
    }
    buildingType.snp.makeConstraints{
      $0.top.equalTo(addressView.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
    }
    buildingTypeLabel.snp.makeConstraints{
      $0.centerY.equalTo(buildingType)
      $0.leading.equalTo(buildingType.snp.trailing).offset(8)
    }
    tradeType.snp.makeConstraints{
      $0.top.equalTo(buildingType.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
    }
    tradeTypeLabel.snp.makeConstraints{
      $0.centerY.equalTo(tradeType)
      $0.leading.equalTo(tradeType.snp.trailing).offset(8)
    }
    optionsLabel.snp.makeConstraints{
      $0.top.equalTo(tradeType.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
    }
    options.snp.makeConstraints{
      $0.centerY.equalTo(optionsLabel)
      $0.leading.equalTo(optionsLabel.snp.trailing).offset(8)
    }
    photoReviewTitle.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(optionsLabel.snp.bottom).offset(12)
    }
    imagesBackground.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(photoReviewTitle.snp.bottom).offset(8)
      $0.height.equalTo(96)
    }
    imagesBackground.add(imageCollectionView)
    imageCollectionView.snp.makeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
    ownerTypeLabel.snp.makeConstraints{
      $0.top.equalTo(imagesBackground.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    ownerTypeView.snp.makeConstraints{
      $0.top.equalTo(ownerTypeLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(80)
    }
    ownerTypeView.adds(ownerTypes)
    let width = UIScreen.main.bounds.width
    for i in 0..<ownerTypes.count {
      ownerTypes[i].setup()
      ownerTypes[i].typeImage.image = UIImage(named: "emoji\(i + 1)")
      ownerTypes[i].snp.makeConstraints{
        $0.centerX.equalToSuperview().offset((i - 2) * 63)
        $0.top.bottom.equalToSuperview()
      }
    }
    buildingReviewTitle.snp.makeConstraints{
      $0.top.equalTo(ownerTypeView.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    reviewView.snp.makeConstraints {
      $0.top.equalTo(buildingReviewTitle.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(80)
    }
  }
}
extension LookAroundDetailViewController {
  override func viewDidLoad() {
    setCollectionView()

    super.viewDidLoad()
    layout()
    setUpview()
    bind()
  }

  private func setCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 72, height: 72)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 9
    layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    imageCollectionView.backgroundColor = .gray244
    imageCollectionView.register(ReusableSimpleImageCell.self,
                                 forCellWithReuseIdentifier: ReusableSimpleImageCell.identifier)
    imageCollectionView.isScrollEnabled = false
  }
  private func setUpview() {
    self.naviTitle.text = model.buildingName
    self.addressLabel.text = model.buildingName
  }
  func bind() {
    let input = LookAroundDetailViewModel.Input(loadTrigger: loadTrigger)
    let output = viewModle.transForm(inputs: input)
    output.images.drive{
      print($0)
    }.disposed(by: disposeBag)
    output.images.asObservable()
      .bind(to: imageCollectionView.rx.items(cellIdentifier: ReusableSimpleImageCell.identifier,
                                             cellType: ReusableSimpleImageCell.self)) {row, data, cell in
        if row > 3 {
          print(row)
        }
        else {
          cell.bindCell(model: data,over: row == 3)
        }
      }.disposed(by: disposeBag)
    output.buildingDetailUsecase.bind{ [weak self] model in
      guard let self = self
      else { return }
      self.addressLabel.text = model.buildingAddress
      self.buildingType.text = model.buildingType
      self.tradeTypeLabel.text = model.contractType
      self.options.text = model.options.map{$0}.reduce(into : ""){$0 + "," + $1}
      for i in 0..<self.ownerTypes.count {
        self.ownerTypes[i].typeLabel.text = model.ownerInfo[i].type.rawValue
        self.ownerTypes[i].typeCount.text = "\(model.ownerInfo[i].count) 개"
        self.ownerTypes[i].typeCount.textColor = model.ownerInfo[i].count > 0 ? .mainBlue : .gray196
      }
    }.disposed(by: disposeBag)
    
    
    imageCollectionView.rx.itemSelected.bind{ [weak self] _ in
      print("사진리스트뷰로이동")
    }.disposed(by: disposeBag)
    loadTrigger.onNext(())
  }
}

class OwnerTypeView : UIView {
  let typeImage = UIImageView().then{
    $0.setRounded(radius: 20)
  }
  let typeLabel = UILabel().then{
    $0.font = .nanumRoundBold(fontSize: 10)
    $0.textColor = .blackText
    $0.textAlignment = .center
  }
  let typeCount = UILabel().then{
    $0.font = .nanumRoundBold(fontSize: 10)
    $0.textColor = .mainBlue
    $0.textAlignment = .center
  }
  func setup() {
    self.adds([typeImage, typeLabel, typeCount])
    typeImage.snp.makeConstraints{
      $0.centerX.top.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    typeLabel.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(typeImage.snp.bottom).offset(5)
    }
    typeCount.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(typeLabel.snp.bottom).offset(1)
    }
  }
}

