//
//  AdditionalInformationViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/10.
//

import SnapKit
import Then
import UIKit

class AdditionalInformationViewController: BaseViewController {
  
  let titleLabelNumberOfLine = 2
  let titleLabel = UILabel()
  let reviewTitleLabel = UILabel()
  let reviewTextField = UITextField()
  let assessTitleLabel = UILabel()
  let assessTableView = UITableView()
  let nextButton = UIButton()
  let separatorView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
  
  
}

extension AdditionalInformationViewController {
  func layoutTitleLabel() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "집에 대한 정보를\n조금 더 알려주세요!",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 1))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 15, length: 6))

    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  func layoutReviewTitleLabel() {
    self.view.add(reviewTitleLabel) {
      $0.text = "상세리뷰"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(32)
      }
    }
  }
  func layoutReviewTextField() {
    self.view.add(self.reviewTextField) {
      $0.textColor = .blackText
      $0.font = .nanumRoundRegular(fontSize: 10)
      $0.setRounded(radius: 8)
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.backgroundColor = .clear
      $0.textAlignment = .left
      $0.contentVerticalAlignment = .top
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.reviewTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.reviewTitleLabel.snp.bottom).offset(12)
        $0.height.equalTo(self.view.frame.height*163/812)
      }
    }
  }
  func layoutAssessTitleLabel() {
    self.view.add(assessTitleLabel) {
      $0.text = "종합평가"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.reviewTextField.snp.bottom).offset(32)
      }
    }
  }
  func layoutAssessTableView() {
    self.view.add(assessTableView) {
      $0.estimatedRowHeight = UITableView.automaticDimension
      $0.backgroundColor = .clear
      $0.separatorStyle = .none
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.assessTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.assessTitleLabel.snp.bottom).offset(12)
      }
    }
  }
  func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.backgroundColor = .gray244
      $0.setTitle("다음으로", for: .normal)
      $0.setTitleColor(.grayText, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.reviewTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38-(self.tabBarController?.tabBar.frame.height ?? 44))
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  func layoutSeparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  func layout() {
    layoutTitleLabel()
    layoutReviewTitleLabel()
    layoutReviewTextField()
    layoutAssessTitleLabel()
    layoutAssessTableView()
    layoutNextButton()
    layoutSeparatorView()
  }
}
