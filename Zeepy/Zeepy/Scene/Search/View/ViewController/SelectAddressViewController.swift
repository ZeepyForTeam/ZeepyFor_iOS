//
//  SelectAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/04/17.
//
import SnapKit
import Then
import UIKit

class SelectAddressViewController: BaseViewController {
  // MARK: - Constants
  let titleLabelNumberOfLine = 2
  
  // MARK: - Components
  let titleLabel = UILabel()
  let addressLabel = UILabel()
  let submitButton = UIButton()
  let addressTableContainerView = UIView()
  let addressTableView = UITableView()
  let addressTableFooterLabel = UILabel()
  let separatorView = UIView()
  let nextButton = UIButton()
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "리뷰작성")
  }
}
// MARK: - Extensions
extension SelectAddressViewController {
  // MARK: - Helpers
  func layoutTitleText() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "거주하고 계신 집을 \n검색하세요",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 8))
    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  func layoutAddressLabel() {
    self.view.add(self.addressLabel) {
      $0.textColor = .blackText
      $0.font = UIFont.nanumRoundExtraBold(fontSize: 18)
      $0.text = "현재 등록된 주소"
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(64)
      }
    }
  }
  func layoutSubmitButton() {
    self.view.add(self.submitButton) {
      $0.setTitle("직접 등록하기", for: .normal)
      $0.setTitleColor(.blackText, for: .normal)
      $0.titleLabel?.font = .nanumRoundBold(fontSize: 10)
      $0.addTarget(self, action: #selector(self.submitButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.addressLabel.snp.centerY)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
      }
    }
  }
  func layoutAddressTableContainerView() {
    self.view.add(self.addressTableContainerView) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.addressLabel.snp.bottom).offset(16)
      }
    }
  }
  func layoutAddressTableView() {
    self.addressTableContainerView.add(self.addressTableView) {
      $0.estimatedRowHeight = UITableView.automaticDimension
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.addressTableContainerView.snp.leading)
        $0.trailing.equalTo(self.addressTableContainerView.snp.trailing)
        $0.top.equalTo(self.addressTableContainerView.snp.top)
      }
    }
  }
  func layoutAddressTableFooterLabel() {
    self.addressTableContainerView.add(self.addressTableFooterLabel) {
      $0.text = "* 최대 3개까지 등록 가능합니다."
      $0.textColor = .grayText
      $0.font = .nanumRoundRegular(fontSize: 10)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.addressTableContainerView.snp.bottom).offset(16)
        $0.leading.equalTo(self.addressTableContainerView.snp.leading)
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
        $0.leading.equalTo(self.addressTableContainerView.snp.leading)
        $0.trailing.equalTo(self.addressTableContainerView.snp.trailing)
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
    layoutTitleText()
    layoutAddressLabel()
    layoutSubmitButton()
    layoutAddressTableContainerView()
    layoutAddressTableView()
    layoutAddressTableFooterLabel()
    layoutNextButton()
    layoutseparatorView()
  }
  
  @objc func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = CommunicationTendencyViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
  
  @objc func submitButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = SearchAddressViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
 
}

