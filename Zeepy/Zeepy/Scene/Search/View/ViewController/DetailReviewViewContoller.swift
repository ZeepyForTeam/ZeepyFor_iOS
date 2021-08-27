//
//  DetailReviewViewContoller.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class DetailReviewViewContoller : BaseViewController {
  private let reviewId : Int!
  init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, reviewId : Int) {
    self.reviewId = reviewId
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  private let viewModel = ReviewDetailViewModel()
  private let width = 109 * (UIScreen.main.bounds.width / 375)
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let naviView = CustomNavigationBar()
  private let writeReviewBtn = UIButton().then {
    $0.setImage(UIImage(named:"btn_write"), for: .normal)
  }
  private let scrollView = UIScrollView()
  private let contentView = UIView().then {
    $0.backgroundColor = .white
  }
  private let reviewerName = UILabel()
  private let roomNumber = UILabel().then {
    $0.setupLabel(text: "", color: .grayText, font: .nanumRoundRegular(fontSize: 10))
  }
  private let createdAt = UILabel().then {
    $0.setupLabel(text: "2021.04.01 14:20", color: .grayText, font: .nanumRoundRegular(fontSize: 10))
  }
  private let simpleInfoNotice = UILabel().then {
    $0.setupLabel(text: "요약", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private let simpleInfoBackground = UIView().then {
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray244
  }
  private let simpleInfoOwnerNotice = UILabel().then {
    $0.setupLabel(text: "임대인", color: .blueText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let simpleInfoOwnerLabel = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let simpleInfoCommunicationNotice = UILabel().then {
    $0.setupLabel(text: "임대인 소통 성향", color: .blueText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let simpleInfoCommunicationImg = UIImageView()
  private let simpleInfoCommunicationLabel = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let simpleInfoHouseNotice = UILabel().then {
    $0.setupLabel(text: "집", color: .blueText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let soundNotice = UILabel().then {
    $0.setupLabel(text: "방음", color: .blackText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let soundReview = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let pestNotice = UILabel().then {
    $0.setupLabel(text: "해충", color: .blackText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let pestReview = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let lightNotice = UILabel().then {
    $0.setupLabel(text: "채광", color: .blackText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let lightReview = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let waterNotice = UILabel().then {
    $0.setupLabel(text: "수압", color: .blackText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let waterReview = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let ownerReviewNotice = UILabel().then {
    $0.setupLabel(text: "임대인 리뷰", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private let ownerReviewBackground = UIView().then {
    $0.setRounded(radius: 8)
    $0.setBorder(borderColor: .black, borderWidth: 1)
  }
  private let ownerReview = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12), align: .left)
    $0.numberOfLines = 0
  }
  private let houseReviewNotice = UILabel().then {
    $0.setupLabel(text: "집 리뷰", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private let houseReviewBackground = UIView().then {
    $0.setRounded(radius: 8)
    $0.setBorder(borderColor: .black, borderWidth: 1)
  }
  private let houseReview = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12), align: .left)
    $0.numberOfLines = 0
  }
  private let photoReviewNotice = UILabel().then {
    $0.setupLabel(text: "첨부된 사진", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private var collectionView : UICollectionView!
  private func setCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: width, height: width)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ReusableSimpleImageCell.self,
                            forCellWithReuseIdentifier: ReusableSimpleImageCell.identifier)
    collectionView.isScrollEnabled = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setCollectionView()
    layout()
    bind()
  }
  private func layout() {
    naviView.setUp(title: "금성토성빌 상세리뷰", rightBtn: writeReviewBtn)
    self.view.adds([naviView,
                    scrollView])
    naviView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    scrollView.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(naviView.snp.bottom)
      
    }
    scrollView.add(contentView)
    contentView.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalToSuperview().priority(250)
    }
    contentView.adds([reviewerName,roomNumber,
                      createdAt,
                      simpleInfoNotice,
                      simpleInfoBackground,
                      ownerReviewNotice,
                      ownerReviewBackground,
                      houseReviewNotice,
                      houseReviewBackground,
                      photoReviewNotice,
                      collectionView
    ])
    
    houseReviewBackground.add(houseReview)
    ownerReviewBackground.add(ownerReview)
    
    
    reviewerName.snp.makeConstraints{
      $0.top.leading.equalToSuperview().offset(16)
    }
    roomNumber.snp.makeConstraints{
      $0.bottom.equalTo(reviewerName)
      $0.leading.equalTo(reviewerName.snp.trailing).offset(4)
    }
    createdAt.snp.makeConstraints{
      $0.bottom.equalTo(reviewerName)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    simpleInfoNotice.snp.makeConstraints{
      $0.top.equalTo(reviewerName.snp.bottom).offset(25)
      $0.leading.equalTo(reviewerName)
    }
    simpleInfoBackground.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(reviewerName)
      $0.top.equalTo(simpleInfoNotice.snp.bottom).offset(8)
      
    }
    ownerReviewNotice.snp.makeConstraints{
      $0.top.equalTo(simpleInfoBackground.snp.bottom).offset(32)
      $0.leading.equalTo(reviewerName)
    }
    ownerReviewBackground.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(reviewerName)
      $0.top.equalTo(ownerReviewNotice.snp.bottom).offset(8)
    }
    ownerReview.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(12)
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-10)
    }
    houseReviewNotice.snp.makeConstraints{
      $0.top.equalTo(ownerReviewBackground.snp.bottom).offset(32)
      $0.leading.equalTo(reviewerName)
    }
    houseReviewBackground.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(reviewerName)
      $0.top.equalTo(houseReviewNotice.snp.bottom).offset(8)
      
    }
    houseReview.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(12)
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-10)
    }
    photoReviewNotice.snp.makeConstraints{
      
      $0.top.equalTo(houseReviewBackground.snp.bottom).offset(32)
      $0.leading.equalTo(reviewerName)
    }
    collectionView.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(reviewerName)
      $0.top.equalTo(photoReviewNotice.snp.bottom).offset(8)
      $0.bottom.equalToSuperview().offset(-25)
      $0.height.equalTo(170)
    }
    
    simpleInfoBackground.adds([simpleInfoOwnerNotice,
                               simpleInfoOwnerLabel,
                               simpleInfoCommunicationNotice,
                               simpleInfoCommunicationImg,
                               simpleInfoCommunicationLabel,
                               simpleInfoHouseNotice,
                               soundNotice,
                               soundReview,
                               pestNotice,
                               pestReview,
                               lightNotice,
                               lightReview,
                               waterNotice,
                               waterReview])
    simpleInfoOwnerNotice.snp.makeConstraints{
      $0.top.leading.equalToSuperview().offset(12)
    }
    simpleInfoOwnerLabel.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoOwnerNotice)
      $0.leading.equalTo(simpleInfoOwnerNotice.snp.trailing).offset(8)
    }
    simpleInfoCommunicationNotice.snp.makeConstraints{
      $0.leading.equalTo(simpleInfoOwnerNotice)
      $0.top.equalTo(simpleInfoOwnerNotice.snp.bottom).offset(8)
    }
    simpleInfoCommunicationImg.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoCommunicationNotice)
      $0.leading.equalTo(simpleInfoCommunicationNotice.snp.trailing).offset(8)
      $0.width.height.equalTo(16)
    }
    simpleInfoCommunicationLabel.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoCommunicationNotice)
      $0.leading.equalTo(simpleInfoCommunicationImg.snp.trailing).offset(8)
    }
    simpleInfoHouseNotice.snp.makeConstraints{
      $0.leading.equalTo(simpleInfoOwnerNotice)
      $0.top.equalTo(simpleInfoCommunicationNotice.snp.bottom).offset(8)
      $0.bottom.equalToSuperview().offset(-12)
    }
    soundNotice.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(simpleInfoHouseNotice.snp.trailing).offset(8)
    }
    soundReview.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(soundNotice.snp.trailing).offset(8)
    }
    pestNotice.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(soundReview.snp.trailing).offset(8)
    }
    pestReview.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(pestNotice.snp.trailing).offset(8)
    }
    lightNotice.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(pestReview.snp.trailing).offset(8)
    }
    lightReview.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(lightNotice.snp.trailing).offset(8)
    }
    waterNotice.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(lightReview.snp.trailing).offset(8)
    }
    waterReview.snp.makeConstraints{
      $0.centerY.equalTo(simpleInfoHouseNotice)
      $0.leading.equalTo(waterNotice.snp.trailing).offset(8)
    }
  }
  private func bind(){
    let input = ReviewDetailViewModel.Input(loadView: Observable.just(reviewId))
    let output = viewModel.transform(input: input)
    collectionView.rx.observeWeakly(CGSize.self, "contentSize")
      .compactMap{$0?.height}
      .distinctUntilChanged()
      .bind{[weak self] height in
        self?.collectionView.snp.updateConstraints{
          $0.height.equalTo(height)
        }
      }.disposed(by: disposeBag)
    ownerReviewBackground.rx.observeWeakly(CGSize.self, "contentSize")
      .compactMap{$0?.height}
      .distinctUntilChanged()
      .bind{[weak self] height in
        self?.collectionView.snp.updateConstraints{
          $0.height.equalTo(height + 32)
        }
      }.disposed(by: disposeBag)
    houseReviewBackground.rx.observeWeakly(CGSize.self, "contentSize")
      .compactMap{$0?.height}
      .distinctUntilChanged()
      .bind{[weak self] height in
        self?.collectionView.snp.updateConstraints{
          $0.height.equalTo(height + 32)
        }
      }.disposed(by: disposeBag)
    output.reviewInfo.map{$0.imageUrls ?? [] }
      .bind(to: collectionView.rx.items(cellIdentifier: ReusableSimpleImageCell.identifier,
                                        cellType: ReusableSimpleImageCell.self)) {[weak self] row, data, cell in
        cell.bindCell(model: data, width: self?.width ?? 109)
      }.disposed(by: disposeBag)
    output.reviewInfo.bind{[weak self ] reviewModel in
      let attributedString = NSMutableAttributedString(string: "\(reviewModel.user.name)님의 후기", attributes: [
        .font: UIFont.nanumRoundExtraBold(fontSize: 16),
        .foregroundColor: UIColor.blackText
      ])
      attributedString.addAttribute(.foregroundColor, value: UIColor.blueText, range: NSRange(location: 0, length: reviewModel.user.name.count))
      
      self?.reviewerName.attributedText = attributedString
      self?.ownerReview.text = "\(reviewModel.lessorReview ?? "")"
      self?.simpleInfoOwnerLabel.text = "\(reviewModel.lessorAge?.AgeTranslate ?? "") \(reviewModel.lessorGender?.GenderTranslate ?? "")로 보여요"
      self?.simpleInfoCommunicationLabel.text = "\(reviewModel.communcationTendency?.validateType.rawValue ?? "" )"
      self?.simpleInfoCommunicationImg.image = UIImage(named: reviewModel.communcationTendency?.validateType.image ?? "")
      self?.houseReview.text = "\(reviewModel.review ?? "")"
      
      self?.soundReview.text = reviewModel.soundInsulation?.HouseValidate ?? "적당해요"
      self?.pestReview.text = reviewModel.pest?.HouseValidate ?? "적당해요"
      self?.lightReview.text = reviewModel.lightning?.HouseValidate ?? "적당해요"
      self?.waterReview.text = reviewModel.waterPressure?.HouseValidate ?? "적당해요"
    }.disposed(by: disposeBag)
    writeReviewBtn.rx.tap.bind{[weak self] in
      let vc = SelectAddressViewController()
      self?.navigationController?.pushViewController(vc, animated: true)
      
    }.disposed(by: disposeBag)
  }
}
