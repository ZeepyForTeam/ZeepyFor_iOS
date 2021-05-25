//
//  DetailAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/25.
//
import SnapKit
import Then
import UIKit

class DetailAddressViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "리뷰작성")
  }
  
  let titleLabelNumberOfLine = 2
  let titleLabel = UILabel()
  let addressContainerView = UIView()
  let addressLabel = UILabel()
  let closeButton = UIButton()
  let detailTextField = UITextField()
  let separatorView = UIView()
  let nextButton = UIButton()
}

extension DetailAddressViewController {
  func layout() {
    layoutTitleLabel()
    layoutAddressContainerView()
    layoutAddressLabel()
    layoutCloseButton()
    layoutDetailTextField()
    layoutNextButton()
    layoutseparatorView()
  }
  func configureTitleLabel() -> NSMutableAttributedString {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "상세주소를\n입력해주세요.",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 5, length: 7))
    return titleText
  }
  func layoutTitleLabel() {
    self.view.add(self.titleLabel) {
      $0.attributedText = self.configureTitleLabel()
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  func layoutAddressContainerView() {
    self.view.add(addressContainerView) {
      $0.backgroundColor = .gray244
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(100)
        $0.height.equalTo(self.view.frame.width*48/375)
      }
    }
  }
  func layoutAddressLabel() {
    self.addressContainerView.add(addressLabel) {
      $0.setupLabel(text: "서울시 등촌동 22번지 구름빌라", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.addressContainerView.snp.centerY)
        $0.leading.equalTo(self.addressContainerView.snp.leading).offset(12)
      }
    }
  }
  func layoutCloseButton() {
    self.addressContainerView.add(closeButton) {
      $0.setImageByName("btnClose")
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.addressContainerView.snp.centerY)
        $0.trailing.equalTo(self.addressContainerView.snp.trailing).offset(-13)
        $0.height.width.equalTo(16)
      }
    }
  }
  func layoutDetailTextField() {
    self.view.add(detailTextField) {
      $0.addLeftPadding()
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.setRounded(radius: 8)
      $0.configureTextField(textColor: .blackText, font: .nanumRoundRegular(fontSize: 14))
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.addressContainerView.snp.leading)
        $0.top.equalTo(self.addressContainerView.snp.bottom).offset(8)
        $0.width.equalTo(self.addressContainerView.snp.width)
        $0.height.equalTo(self.addressContainerView.snp.height)
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
        $0.leading.equalTo(self.addressContainerView.snp.leading)
        $0.trailing.equalTo(self.addressContainerView.snp.trailing)
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
  @objc func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = SelectAddressViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
}
