//
//  SimpleReviewView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class SimpleReviewView : UITableViewCell {
  let disposeBag = DisposeBag()
  public var isEnabled : Bool = false {
    didSet {
      if self.isEnabled {
        self.blockView.removeFromSuperview()
      }
      else {
        self.add(blockView)
        blockView.snp.remakeConstraints{
          $0.top.bottom.leading.trailing.equalToSuperview()
        }
      }
    }
  }
  private let blockView = UIView().then {
    $0.backgroundColor = .clear
    $0.setRounded(radius: 5)
    $0.alpha = 0.7
  }
  private let roomNumber = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 10)
  }
  private let createdAt = UILabel().then {
    $0.font = .nanumRoundRegular(fontSize: 10)
    $0.textColor = .blackText
  }
  let reportBtn = UIButton().then {
    $0.setTitle("신고", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .nanumRoundRegular(fontSize: 10)
  }
  private let reviewerName = UILabel()
  private let ownerReviewNotice = UILabel().then {
    $0.text = "임대인 리뷰"
    $0.textColor = .blueText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let ownerStyleBackground = UIView().then {
    $0.setRounded(radius: 8)
    $0.backgroundColor = .white
    $0.setBorder(borderColor: .blueText, borderWidth: 1)
  }
  private let ownerStyle = UILabel().then {
    $0.font = .nanumRoundBold(fontSize: 10)
    $0.textColor = .blackText
  }
  private let ownerReview = UILabel().then {
    $0.numberOfLines = 2
    $0.font = .nanumRoundRegular(fontSize: 12)
    $0.textColor = .blackText
    
  }
  private let houseReviewNotice = UILabel().then {
    $0.text = "집 리뷰"
    $0.textColor = .blueText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let houseReview = UILabel().then {
    $0.numberOfLines = 2
    $0.font = .nanumRoundRegular(fontSize: 12)
    $0.textColor = .blackText
  }
  private let totalReviewNotice = UILabel().then {
    $0.text = "집 리뷰"
    $0.textColor = .blueText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let totalReview = UILabel().then {
    $0.numberOfLines = 2
    $0.font = .nanumRoundRegular(fontSize: 12)
    $0.textColor = .blackText
  }
  let reviewDetailBtn = UIButton().then {
    $0.setTitle("리뷰 전체보기 >", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .nanumRoundRegular(fontSize: 10)
  }
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
    self.selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func layout() {
    self.backgroundColor = .gray244
    self.setRounded(radius: 5)
    self.adds([roomNumber,
               createdAt,
               reportBtn,
               reviewerName,
               ownerReviewNotice,
               ownerStyleBackground,
               ownerReview,
               houseReviewNotice,
               houseReview,
               totalReviewNotice,
               totalReview,
               reviewDetailBtn])
    
    roomNumber.snp.makeConstraints{
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalToSuperview().offset(16)
    }
    createdAt.snp.makeConstraints{
      $0.centerY.equalTo(roomNumber)
      $0.trailing.equalTo(reportBtn.snp.leading).offset(-8)
    }
    reportBtn.snp.makeConstraints{
      $0.centerY.equalTo(roomNumber)
      $0.trailing.equalToSuperview().offset(-16)
    }
    reviewerName.snp.makeConstraints{
      $0.top.equalTo(roomNumber.snp.bottom).offset(12)
      $0.leading.equalTo(roomNumber)
    }
    ownerReviewNotice.snp.makeConstraints{
      $0.top.equalTo(reviewerName.snp.bottom).offset(16)
      $0.leading.equalTo(roomNumber)
      
    }
    ownerStyleBackground.add(ownerStyle)
    ownerStyleBackground.snp.makeConstraints{
      $0.centerY.equalTo(ownerReviewNotice)
      $0.leading.equalTo(ownerReviewNotice.snp.trailing).offset(8)
      $0.height.equalTo(16)
    }
    ownerStyle.snp.makeConstraints{
      $0.centerY.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(4)
    }
    
    ownerReview.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(roomNumber)
      $0.top.equalTo(ownerReviewNotice.snp.bottom).offset(8)
      $0.height.equalTo(40)
    }
    houseReviewNotice.snp.makeConstraints{
      $0.top.equalTo(ownerReview.snp.bottom).offset(16)
      $0.leading.equalTo(roomNumber)
    }
    houseReview.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(roomNumber)
      $0.top.equalTo(houseReviewNotice.snp.bottom).offset(8)
      $0.height.equalTo(40)

    }
    totalReviewNotice.snp.makeConstraints{
      $0.top.equalTo(houseReview.snp.bottom).offset(16)
      $0.leading.equalTo(roomNumber)
    }
    totalReview.snp.makeConstraints{
      $0.leading.equalTo(roomNumber)
      $0.trailing.equalTo(reviewDetailBtn.snp.leading).offset(-16)
      $0.top.equalTo(totalReviewNotice.snp.bottom).offset(8)
      $0.bottom.equalTo(reviewDetailBtn)
      $0.height.equalTo(40)

    }
    reviewDetailBtn.snp.makeConstraints{
      $0.bottom.equalToSuperview().offset(-16)
      $0.trailing.equalToSuperview().offset(-18)
    }
  }
}

extension SimpleReviewView {
  func bind() {
    
  }
  func dummy() {
    roomNumber.text = "3**호에 거주한"
    createdAt.text = "2021.04.01 13:32"
    let attributedString = NSMutableAttributedString(string: "서울쥐김자랑 님의 후기", attributes: [
      .font: UIFont.nanumRoundExtraBold(fontSize: 18),
      .foregroundColor: UIColor.blackText
    ])
    attributedString.addAttribute(.foregroundColor, value: UIColor.blueText, range: NSRange(location: 0, length: 5))
    
    reviewerName.attributedText = attributedString
    ownerStyle.text = "30대 남자로 보여요."
    ownerReview.text  = "임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~"
    houseReview.text = "임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~"
    totalReview.text = "임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~임대인진짜최고에요~"
  }
}
