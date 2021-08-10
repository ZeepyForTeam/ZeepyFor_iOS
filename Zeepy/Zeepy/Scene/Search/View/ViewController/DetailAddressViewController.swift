//
//  DetailAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/25.
//
import UIKit

import SnapKit
import Then

// MARK: - DetailAddressViewController
class DetailAddressViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let titleLabelNumberOfLine = 2
  private let titleLabel = UILabel()
  private let distrinctContainerView = UIView()
  private let distrinctLabel = UILabel()
  private let primaryAddressContainerView = UIView()
  private let primaryAddressLabel = UILabel()
  private let closeButton = UIButton()
  private let detailTextField = UITextField()
  private let separatorView = UIView()
  private let nextButton = UIButton()
  
  // MARK: - Variables
  var addressModel = Addresses(cityDistinct: "",
                               primaryAddress: "",
                               detailAddress: "")
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
    setupNavigation()
  }

}

// MARK: - Extensions
extension DetailAddressViewController {
  
  // MARK: - Layout Helpers
  func layout() {
    layoutNavigationView()
    layoutTitleLabel()
    layoutDistrinctContainerView()
    layoutDistrinctLabel()
    layoutPrimaryAddressContainerView()
    layoutPrimaryAddressLabel()
    layoutDetailTextField()
    layoutNextButton()
    layoutseparatorView()
  }
  
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func configureTitleLabel() -> NSMutableAttributedString {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "후기를 작성할 집이\n이 곳이 맞나요?",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: titleText.length - 9))
    return titleText
  }
  
  private func layoutTitleLabel() {
    self.view.add(self.titleLabel) {
      $0.attributedText = self.configureTitleLabel()
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
      }
    }
  }
  
  private func layoutDistrinctContainerView() {
    self.view.add(distrinctContainerView) {
      $0.backgroundColor = .gray244
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(44)
        $0.height.equalTo(self.view.frame.width*48/375)
      }
    }
  }
  
  private func layoutDistrinctLabel() {
    self.distrinctContainerView.add(distrinctLabel) {
      $0.setupLabel(text: self.addressModel.cityDistinct,
                    color: .blackText,
                    font: .nanumRoundRegular(fontSize: 14))
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.distrinctContainerView.snp.centerY)
        $0.leading.equalTo(self.distrinctContainerView.snp.leading).offset(12)
      }
    }
  }
  
  private func layoutPrimaryAddressContainerView() {
    self.view.add(primaryAddressContainerView) {
      $0.backgroundColor = .gray244
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.distrinctContainerView.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.distrinctContainerView.snp.bottom).offset(8)
        $0.height.equalTo(self.view.frame.width*48/375)
      }
    }
  }
  
  private func layoutPrimaryAddressLabel() {
    self.primaryAddressContainerView.add(primaryAddressLabel) {
      $0.setupLabel(text: self.addressModel.primaryAddress,
                    color: .blackText,
                    font: .nanumRoundRegular(fontSize: 14))
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.primaryAddressContainerView.snp.centerY)
        $0.leading.equalTo(self.primaryAddressContainerView.snp.leading).offset(12)
      }
    }
  }
  
  
  private func layoutDetailTextField() {
    self.view.add(detailTextField) {
      $0.addLeftPadding()
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.setRounded(radius: 8)
      $0.configureTextField(textColor: .blackText, font: .nanumRoundRegular(fontSize: 14))
      $0.delegate = self
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.distrinctContainerView.snp.leading)
        $0.top.equalTo(self.primaryAddressContainerView.snp.bottom).offset(8)
        $0.width.equalTo(self.distrinctContainerView.snp.width)
        $0.height.equalTo(self.distrinctContainerView.snp.height)
      }
    }
  }
  
  private func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.tag = 0
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
        $0.leading.equalTo(self.distrinctContainerView.snp.leading)
        $0.trailing.equalTo(self.distrinctContainerView.snp.trailing)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38)
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  
  private func layoutseparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  
  // MARK: - General Helpers
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
  
  // MARK: - Action Helpers
  @objc func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = CommunicationTendencyViewController()
    reviewModel.address = "\(addressModel.cityDistinct) \(addressModel.primaryAddress) \(detailTextField.text ?? "")"
    nextViewController.reviewModel = reviewModel
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
}

// MARK: - UITextField Delegate
extension DetailAddressViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
      nextButton.backgroundColor = .mainBlue
      nextButton.setTitleColor(.white, for: .normal)
      nextButton.isUserInteractionEnabled = true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.hasText == false {
      nextButton.backgroundColor = .gray244
      nextButton.setTitleColor(.grayText, for: .normal)
      nextButton.isUserInteractionEnabled = false
    }
  }
}
