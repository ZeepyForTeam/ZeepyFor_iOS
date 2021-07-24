//
//  LenderInformationViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/03.
//

import SnapKit
import Then
import UIKit

class LenderInformationViewController: BaseViewController {
  
  // MARK: - Constants
  let titleLabelNumberOfLine = 2
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  let titleLabel = UILabel()
  let genderTitleLabel = UILabel()
  let maleButton = UIButton()
  let femaleButton = UIButton()
  let ageTitleLabel = UILabel()
  let ageView = UIView()
  let ageContextLabel = UILabel()
  let ageButton = UIButton()
  let ageUnitLabel = UILabel()
  let detailTitleLabel = UILabel()
  let detailTextField: UITextField = {
    let textField = UITextField.textFieldWithInsets(insets:
                                                      UIEdgeInsets(top: 10,
                                                                   left: 10,
                                                                   bottom: 10,
                                                                   right: 10))
    return textField
  }()
  let detailTextFieldFooterLabel = UILabel()
  let nextButton = UIButton()
  let separatorView = UIView()
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
    setupNavigation()
  }
}
// MARK: - Extensions
extension LenderInformationViewController {
  
  // MARK: - Layout Helpers
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  func layoutTitleLabel() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "임대인에 대해\n조금 더 알려주세요!",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 3, length: 10))

    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
      }
    }
  }
  func layoutGenderTitleLabel() {
    self.view.add(self.genderTitleLabel) {
      $0.text = "성별"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(32)
      }
    }
  }
  func layoutMaleButton() {
    self.view.add(self.maleButton) {
      $0.backgroundColor = .mainBlue
      $0.setTitle("남", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
      $0.setRounded(radius: 16)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.trailing).offset(22)
        $0.centerY.equalTo(self.genderTitleLabel.snp.centerY)
        $0.width.height.equalTo(32)
      }
    }
  }
  func layoutFemaleButton() {
    self.view.add(self.femaleButton) {
      $0.backgroundColor = .white
      $0.setTitle("여", for: .normal)
      $0.setTitleColor(.mainBlue, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
      $0.setRounded(radius: 16)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.maleButton.snp.trailing).offset(11)
        $0.centerY.equalTo(self.genderTitleLabel.snp.centerY)
        $0.width.height.equalTo(32)
      }
    }
  }
  func layoutAgeTitleLabel() {
    self.view.add(self.ageTitleLabel) {
      $0.text = "연령대"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.genderTitleLabel.snp.centerY)
        $0.leading.equalTo(self.femaleButton.snp.trailing).offset(53)
      }
    }
  }
  func layoutAgeView() {
    self.view.add(self.ageView) {
      $0.backgroundColor = .gray244
      $0.setRounded(radius: 4)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageTitleLabel.snp.centerY)
        $0.leading.equalTo(self.ageTitleLabel.snp.trailing).offset(4)
        $0.width.equalTo(54)
        $0.height.equalTo(24)
      }
    }
  }
  func layoutAgeContextLabel() {
    self.ageView.add(self.ageContextLabel) {
      $0.text = "50"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageView.snp.centerY)
        $0.leading.equalTo(self.ageView.snp.leading).offset(15)
      }
    }
  }
  func layoutAgeButton() {
    self.ageView.add(self.ageButton) {
      $0.setBackgroundImage(UIImage(named: "iconSearch"), for: .normal)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageView.snp.centerY)
        $0.trailing.equalTo(self.ageView.snp.trailing).offset(-3)
        $0.width.height.equalTo(10)
      }
    }
  }
  func layoutAgeUnitLabel() {
    self.view.add(self.ageUnitLabel) {
      $0.text = "대"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageView.snp.centerY)
        $0.leading.equalTo(self.ageView.snp.trailing).offset(4)
      }
    }
  }
  func layoutDetailTitleLabel() {
    self.view.add(self.detailTitleLabel) {
      $0.text = "상세정보"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.leading)
        $0.top.equalTo(self.genderTitleLabel.snp.bottom).offset(24)
      }
    }
  }
  func layoutDetailTextField() {
    self.view.add(self.detailTextField) {
      $0.textColor = .blackText
      $0.font = .nanumRoundRegular(fontSize: 10)
      $0.setRounded(radius: 8)
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.backgroundColor = .clear
      $0.textAlignment = .left
      $0.contentVerticalAlignment = .top
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.detailTitleLabel.snp.bottom).offset(12)
        $0.height.equalTo(self.view.frame.height*163/812)
      }
    }
  }
  func layoutDetailTextFieldFooterLabel() {
    self.view.add(detailTextFieldFooterLabel) {
      $0.text = "*임대인을 향한 비방이나 너무 심한 욕설은 자제해주세요. T-T!"
      $0.textColor = .grayText
      $0.font = .nanumRoundRegular(fontSize: 10)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.leading)
        $0.top.equalTo(self.detailTextField.snp.bottom).offset(12)
      }
    }
  }
  func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.tag = 1
      $0.setRounded(radius: 8)
      $0.setTitle("다음으로", for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      if $0.tag == 0 {
        $0.backgroundColor = .gray244
        $0.setTitleColor(.grayText, for: .normal)
        $0.isUserInteractionEnabled = false
      }
      else if $0.tag == 1 {
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.isUserInteractionEnabled = true
      }
      $0.addTarget(self, action: #selector(self.nextButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.detailTextField.snp.leading)
        $0.trailing.equalTo(self.detailTextField.snp.trailing)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38-(self.tabBarController?.tabBar.frame.height ?? 44))
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  func layoutseparatorView() {
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
    layoutNavigationView()
    layoutTitleLabel()
    layoutGenderTitleLabel()
    layoutMaleButton()
    layoutFemaleButton()
    layoutAgeTitleLabel()
    layoutAgeView()
    layoutAgeContextLabel()
    layoutAgeButton()
    layoutAgeUnitLabel()
    layoutDetailTitleLabel()
    layoutDetailTextField()
    layoutDetailTextFieldFooterLabel()
    layoutNextButton()
    layoutseparatorView()
  }
  @objc func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = AdditionalInformationViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
}
