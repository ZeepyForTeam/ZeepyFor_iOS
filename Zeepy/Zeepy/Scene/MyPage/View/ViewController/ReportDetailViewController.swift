//
//  ReportDetailViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ReportDetailViewController
class ReportDetailViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let reasonTitleLabel = UILabel()
  private let reasonTextField = UITextField()
  private let contentTitleLabel = UILabel()
  private let contentTextView = UITextView()
  private let sendButton = UIButton()
  
  // MARK: - Variables
  private final let contentPlaceholder =
    "신고하려는 게시물, 사용자에 대해\n조금 더 상세히 알려주세요"
  
  var reportModel = RequestReportModel(
    requestReportModelDescription: "",
    reportID: 0,
    reportType: "",
    reportUser: 0,
    targetTableType: "",
    targetUser: 0)
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension ReportDetailViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutReasonTitleLabel()
    layoutReasonTextField()
    layoutContentTitleLabel()
    layoutContentTextView()
    layoutSendButton()
  }
   
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self,
                           action: #selector(self.backButtonClicked),
                           for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func layoutReasonTitleLabel() {
    view.add(reasonTitleLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(28)
      }
    }
  }
  
  private func layoutReasonTextField() {
    view.add(reasonTextField) {
      $0.setRounded(radius: 8)
      $0.addLeftPadding(as: 17)
      $0.backgroundColor = .gray244
      $0.isUserInteractionEnabled = false
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.reasonTitleLabel.snp.leading)
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.reasonTitleLabel.snp.bottom).offset(8)
        $0.height.equalTo(40)
      }
    }
  }
  
  private func layoutContentTitleLabel() {
    view.add(contentTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.reasonTextField.snp.bottom).offset(20)
        $0.leading.equalTo(self.reasonTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutContentTextView() {
    view.add(contentTextView) {
      $0.setRounded(radius: 8)
      $0.backgroundColor = .gray244
      $0.textAlignment = .left
      $0.textContainerInset = UIEdgeInsets(top: 16, left: 17, bottom: 16, right: 17)
      $0.autocorrectionType = .no
      $0.autocapitalizationType = .none
      $0.textContainer.lineBreakMode = .byWordWrapping
      $0.delegate = self
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.reasonTitleLabel.snp.leading)
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.contentTitleLabel.snp.bottom).offset(8)
        $0.height.equalTo(212)
      }
    }
  }
  
  func layoutSendButton() {
    self.view.add(self.sendButton) {
      $0.tag = 0
      $0.setRounded(radius: 8)
      $0.setTitle("보내기", for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
      $0.isUserInteractionEnabled = false
      if $0.tag == 0 {
        $0.backgroundColor = .gray244
        $0.setTitleColor(.grayText, for: .normal)
        $0.isUserInteractionEnabled = false
      }
      else if $0.tag == 1 {
        $0.backgroundColor = .pointYellow
        $0.setTitleColor(.white, for: .normal)
        $0.isUserInteractionEnabled = true
      }
      $0.addTarget(self, action: #selector(self.sendButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38 - (self.tabBarController?.tabBar.frame.size.height ?? 40))
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    navigationView.naviTitle.text = "신고하기"
    reasonTitleLabel.setupLabel(text: "신고 사유",
                                color: .blackText,
                                font: .nanumRoundBold(fontSize: 14))
    
    reasonTextField.text = "기타"
    reasonTextField.textColor = .blackText
    reasonTextField.font = .nanumRoundBold(fontSize: 14)
    contentTitleLabel.setupLabel(text: "상세 내용",
                                 color: .blackText,
                                 font: .nanumRoundBold(fontSize: 14))
    
    contentTextView.text = contentPlaceholder
    contentTextView.textColor = .grayText
    contentTextView.font = .nanumRoundBold(fontSize: 14)
  }
  
  private func activateNextButton() {
    if contentTextView.hasText == false ||
        contentTextView.text != contentPlaceholder {
      sendButton.isUserInteractionEnabled = true
      sendButton.backgroundColor = .pointYellow
      sendButton.setTitleColor(.white, for: .normal)
    }
    else {
      sendButton.isUserInteractionEnabled = false
      sendButton.backgroundColor = .gray244
      sendButton.setTitleColor(.grayText, for: .normal)
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func sendButtonClicked() {
    let popupView = ReportPopupViewController()
    let count = self.navigationController?.children.count
    let rootVC = self.navigationController?.children[(count ?? 3) - 3]
    reportModel.requestReportModelDescription = contentTextView.text
    popupView.reportModel = reportModel
    popupView.resultClosure = { result in
      weak var `self` = self
      if result {
        self?.navigationController?.popToViewController(
          rootVC!,
          animated: true)
      }
    }
    popupView.modalPresentationStyle = .overFullScreen
    self.present(popupView, animated: true, completion: nil)
  }
}

// MARK: - contentTextView Delegate
extension ReportDetailViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == contentPlaceholder {
      textView.text = ""
      textView.textColor = .blackText
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.hasText == false {
      sendButton.isUserInteractionEnabled = false
      textView.text = contentPlaceholder
      textView.textColor = .grayText
    }
    activateNextButton()
  }
}
