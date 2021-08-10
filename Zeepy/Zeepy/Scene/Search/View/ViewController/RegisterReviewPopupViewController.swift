//
//  RegisterReviewPopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/10.
//

import UIKit

import SnapKit
import Then

// MARK: - RegisterReviewPopupViewController
class RegisterReviewPopupViewController: UIViewController {
  
  // MARK: - Components
  private let cardView = UIView()
  private let titleLabel = UILabel()
  private let firstContextLabel = UILabel()
  private let secondContextLabel = UILabel()
  private let cancelButton = UIButton()
  private let registerButton = UIButton()
  
  // MARK: - Variables
  var reviewModel = ReviewModel(address: "",
                                buildingID: 0,
                                communcationTendency: "",
                                furnitures: [],
                                imageUrls: [],
                                lessorAge: "",
                                lessorGender: "",
                                lessorReview: "",
                                lightning: "",
                                pest: "",
                                review: "",
                                roomCount: "",
                                soundInsulation: "",
                                totalEvaluation: "",
                                user: 0,
                                waterPressure: "")
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
  
  override func viewDidLayoutSubviews() {
    self.cardView.snp.remakeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(self.view.frame.width * 288/375)
      $0.bottom.equalTo(self.registerButton.snp.bottom).offset(16)
    }
  } 
}

// MARK: - Extensions
extension RegisterReviewPopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    view.backgroundColor = .popupBackground
    layoutCardView()
    layoutTitleLabel()
    layoutFirstContextLabel()
    layoutSecondContextLabel()
    layoutCancelButton()
    layoutRegisterButton()
  }
  
  private func layoutCardView() {
    view.add(cardView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: 10)
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 288/375)
        $0.height.equalTo(self.view.frame.width * 247/375)
      }
    }
  }
  
  private func layoutTitleLabel() {
    cardView.add(titleLabel) {
      $0.setupLabel(text: "리뷰를 등록하시겠습니까?",
                    color: .blackText,
                    font: .nanumRoundExtraBold(fontSize: 18))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.cardView.snp.top).offset(46)
      }
    }
  }
  
  private func layoutFirstContextLabel() {
    cardView.add(firstContextLabel) {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 5
      titleParagraphStyle.alignment = .center
      let titleText = NSMutableAttributedString(
        string: "*리뷰 등록 후에는 수정하거나 삭제하실 수\n없으니 글 작성에 유의해주세요",
        attributes: [
          .font: UIFont.nanumRoundBold(fontSize: 12),
          .foregroundColor: UIColor.grayText])
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      $0.attributedText = titleText
      $0.numberOfLines = 0
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(17)
        $0.centerX.equalToSuperview()
        
      }
    }
  }
  
  private func layoutSecondContextLabel() {
    cardView.add(secondContextLabel) {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 5
      titleParagraphStyle.alignment = .center
      let titleText = NSMutableAttributedString(
        string: "*허위/중복/성의없는 정보 또는 비방글을\n작성할 경우, 서비스 이용이 제한될 수 있습니다.",
        attributes: [.font: UIFont.nanumRoundBold(fontSize: 12),
                     .foregroundColor: UIColor.grayText])
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      $0.attributedText = titleText
      $0.numberOfLines = 0
      $0.snp.makeConstraints {
        $0.top.equalTo(self.firstContextLabel.snp.bottom).offset(10)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  private func layoutCancelButton() {
    cardView.add(cancelButton) {
      $0.setupButton(title: "취소",
                     color: .mainBlue,
                     font: .nanumRoundExtraBold(fontSize: 14),
                     backgroundColor: .gray249,
                     state: .normal,
                     radius: 8)
      $0.snp.makeConstraints {
        $0.trailing.equalTo(self.cardView.snp.centerX).offset(-5)
        $0.leading.equalTo(self.cardView.snp.leading).offset(12)
        $0.top.equalTo(self.secondContextLabel.snp.bottom).offset(31)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  private func layoutRegisterButton() {
    cardView.add(registerButton) {
      $0.setupButton(title: "확인",
                     color: .white,
                     font: .nanumRoundExtraBold(fontSize: 14),
                     backgroundColor: .mainBlue,
                     state: .normal,
                     radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.cardView.snp.centerX).offset(5)
        $0.trailing.equalTo(self.cardView.snp.trailing).offset(-12)
        $0.top.equalTo(self.secondContextLabel.snp.bottom).offset(31)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func cancelButtonClicked() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func registerButtonClicked() {
    registerReview()
  }
  
  // MARK: - General Helpers
  private func registerReview() {
    // TODO: - Server Connection
  }
}
