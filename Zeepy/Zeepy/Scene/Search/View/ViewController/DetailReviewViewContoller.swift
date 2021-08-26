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
  private let reviewModel : ReviewResponses!
  init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, review : ReviewResponses) {
    self.reviewModel = review
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let naviView = CustomNavigationBar().then {
    $0.backBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
  }
  private let writeReviewBtn = UIButton().then {
    $0.setImage(UIImage(named:"btn_write"), for: .normal)
  }
  private let scrollView = UIScrollView()
  private let contentView = UIView().then {
    $0.backgroundColor = .white
  }
  private let reviewerName = UILabel()
  private let roomNumber = UILabel().then {
    $0.setupLabel(text: "(호 거주)", color: .grayText, font: .nanumRoundRegular(fontSize: 10))
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
    $0.setupLabel(text: "30대 남자로 보여요", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let simpleInfoCommunicationNotice = UILabel().then {
    $0.setupLabel(text: "임대인 소통 성향", color: .blueText, font: .nanumRoundExtraBold(fontSize: 12))
  }
  private let simpleInfoCommunicationImg = UIImageView()
  private let simpleInfoCommunicationLabel = UILabel().then {
    $0.setupLabel(text: "츤데레형", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
  }
  private let simpleInfoHouseNotice = UILabel().then {
    $0.setupLabel(text: "집", color: .blueText, font: .nanumRoundExtraBold(fontSize: 12))
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
    layout.itemSize = CGSize(width: 72, height: 72)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 9
    layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
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
  
      $0.height.equalTo(80)
    }
    ownerReview.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(12)
    }
    houseReviewNotice.snp.makeConstraints{
      $0.top.equalTo(ownerReviewBackground.snp.bottom).offset(32)
      $0.leading.equalTo(reviewerName)
    }
    houseReviewBackground.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(reviewerName)
      $0.top.equalTo(houseReviewNotice.snp.bottom).offset(8)
      $0.height.equalTo(80)

    }
    houseReview.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(12)
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
                               simpleInfoHouseNotice])
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
    
  }
  private func bind(){
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
    let width = 109 * (UIScreen.main.bounds.width / 375)

    Observable.just(reviewModel.imageUrls ?? [])
      .bind(to: collectionView.rx.items(cellIdentifier: ReusableSimpleImageCell.identifier,
                                           cellType: ReusableSimpleImageCell.self)) {row, data, cell in
      cell.bindCell(model: data, width: width)
    }.disposed(by: disposeBag)
    
    let attributedString = NSMutableAttributedString(string: "\(reviewModel.user.name)님의 후기", attributes: [
      .font: UIFont.nanumRoundExtraBold(fontSize: 16),
      .foregroundColor: UIColor.blackText
    ])
    attributedString.addAttribute(.foregroundColor, value: UIColor.blueText, range: NSRange(location: 0, length: reviewModel.user.name.count))
    
    reviewerName.attributedText = attributedString
    ownerReview.text = "\(reviewModel.lessorReview ?? "")"
    houseReview.text = "\(reviewModel.review ?? "")"
    
    writeReviewBtn.rx.tap.bind{[weak self] in
      let vc = SelectAddressViewController()
      self?.navigationController?.pushViewController(vc, animated: true)
      
    }.disposed(by: disposeBag)
  }
  
  
}
