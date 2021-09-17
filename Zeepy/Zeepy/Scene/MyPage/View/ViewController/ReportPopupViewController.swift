//
//  ReportPopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/23.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - ReportPopupViewController
class ReportPopupViewController: BaseViewController {
  
  // MARK: - Components
  private let cardView = UIView()
  private let titleLabel = UILabel()
  private let firstContextLabel = UILabel()
  private let secondContextLabel = UILabel()
  private let cancelButton = UIButton()
  private let reportButton = UIButton()
  
  // MARK: - Variables
  var reportModel = RequestReportModel(
    requestReportModelDescription: "",
    reportID: 0,
    reportType: "",
    reportUser: 0,
    targetTableType: "",
    targetUser: 0)
  
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  var resultClosure: ((Bool) -> ())?
  private var registerResult: Bool = false
  
 
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
}

// MARK: - Extensions
extension ReportPopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    view.backgroundColor = .popupBackground
    layoutCardView()
    layoutTitleLabel()
    layoutFirstContextLabel()
    layoutSecondContextLabel()
    layoutCancelButton()
    layoutReportButton()
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
      $0.setupLabel(text: "정말로 신고하시겠습니까?",
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
        string: "*신고 후에는 신고 내용을 수정하거나\n취소하실 수 없습니다.",
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
        string: "*악의적인 의도나 허위로 신고할 경우에는\n서비스 이용이 제한될 수 있습니다.",
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
                     color: .pointYellow,
                     font: .nanumRoundExtraBold(fontSize: 14),
                     backgroundColor: .gray249,
                     state: .normal,
                     radius: 8)
      $0.addTarget(self, action: #selector(self.cancelButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.cardView.snp.leading).offset(12)
        $0.top.equalTo(self.secondContextLabel.snp.bottom).offset(31)
        $0.height.equalTo(self.view.frame.width * 48/375)
        $0.width.equalTo(self.view.frame.width * 81/375)
      }
    }
  }
  
  private func layoutReportButton() {
    cardView.add(reportButton) {
      $0.setupButton(title: "확인했으며, 신고할게요",
                     color: .white,
                     font: .nanumRoundExtraBold(fontSize: 14),
                     backgroundColor: .pointYellow,
                     state: .normal,
                     radius: 8)
      $0.addTarget(self, action: #selector(self.reportButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.cancelButton.snp.trailing).offset(10)
        $0.trailing.equalTo(self.cardView.snp.trailing).offset(-12)
        $0.top.equalTo(self.secondContextLabel.snp.bottom).offset(31)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  // MARK: - General Helpers
  private func report() {
    userService.report(param: reportModel)
      .subscribe(onNext: {[weak self] response in
        if (200...300).contains(response.statusCode) {
          do {
            print("success")
            
            self?.dismiss(animated: false, completion: {
              self?.registerResult = true
              if let closure = self?.resultClosure {
                closure(self?.registerResult == true)
              }
            })
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  // MARK: - Action Helpers
  @objc
  private func cancelButtonClicked() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func reportButtonClicked() {
    report()
  }
}
