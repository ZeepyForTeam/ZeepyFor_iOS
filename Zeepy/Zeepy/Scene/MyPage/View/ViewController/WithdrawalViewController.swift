//
//  WithdrawalViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/11.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - WithdrawalViewController
class WithdrawalViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let termsContainerView = UIView()
  private let firstTermDotView = UIView()
  private let firstTermLabel = UILabel()
  private let secondTermDotView = UIView()
  private let secondTermLabel = UILabel()
  private let withdrawalButton = UIButton()
  
  // MARK: - Variables
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins:[NetworkLoggerPlugin(verbose: true)]))
  
  private final let firstTerm = "ZEEPY 회원탈퇴 시 ZEEPY 서비스에서 탈퇴되며, 회원탈퇴 후 재가입하더라도 탈퇴 전의 회원정보, 게시글 및 댓글 목록, 찜 목록 등은 복구되지 않습니다."
  private final let secondTerm = "ZEEPY 회원탈퇴 시 회원정보 및 서비스 이용기록은 모두 삭제되며, 삭제된 데이터는 복구가 불가능합니다. 다만 법령에 의하여 보관해야 하는 경우 또는 회원가입 남용, 서비스 부정사용 등을 위한 정보는 회원탈퇴 후에도 일정기간 보관됩니다."
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    relayoutTermsContainerView()
  }
}

// MARK: - Extensions
extension WithdrawalViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutTitleLabel()
    layoutSubtitleLabel()
    layoutTermsContainerView()
    layoutFirstTermDotView()
    layoutFirstTermLabel()
    layoutSecondTermDotView()
    layoutSecondTermLabel()
    layoutWithdrawalButton()
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
  
  private func layoutTitleLabel() {
    view.add(titleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
      }
    }
  }
  
  private func layoutSubtitleLabel() {
    view.add(subtitleLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
      }
    }
  }
  
  private func layoutTermsContainerView() {
    view.add(termsContainerView) {
      $0.backgroundColor = .gray249
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(22)
        $0.centerX.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 328/375)
        $0.height.equalTo(self.view.frame.width * 304/375)
      }
    }
  }
  
  private func layoutFirstTermDotView() {
    termsContainerView.add(firstTermDotView) {
      $0.backgroundColor = .blackText
      $0.setRounded(radius: 2)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.termsContainerView.snp.leading).offset(12)
        $0.top.equalTo(self.termsContainerView.snp.top).offset(30)
        $0.width.height.equalTo(4)
      }
    }
  }
  
  private func layoutFirstTermLabel() {
    termsContainerView.add(firstTermLabel) {
      $0.numberOfLines = 0
      $0.lineBreakMode = .byWordWrapping
      if #available(iOS 14.0, *) {
        $0.lineBreakStrategy = .hangulWordPriority
      }
      $0.snp.makeConstraints {
        $0.top.equalTo(self.firstTermDotView.snp.top).offset(-2)
        $0.leading.equalTo(self.firstTermDotView.snp.trailing).offset(8)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  private func layoutSecondTermDotView() {
    termsContainerView.add(secondTermDotView) {
      $0.backgroundColor = .blackText
      $0.setRounded(radius: 2)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.firstTermDotView.snp.leading)
        $0.top.equalTo(self.firstTermLabel.snp.bottom).offset(40)
        $0.width.height.equalTo(4)
      }
    }
  }
  
  private func layoutSecondTermLabel() {
    termsContainerView.add(secondTermLabel) {
      $0.numberOfLines = 0
      $0.lineBreakMode = .byWordWrapping
      if #available(iOS 14.0, *) {
        $0.lineBreakStrategy = .hangulWordPriority
      }
      $0.snp.makeConstraints {
        $0.top.equalTo(self.secondTermDotView.snp.top).offset(-2)
        $0.leading.equalTo(self.firstTermLabel.snp.leading)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  private func layoutWithdrawalButton() {
    view.add(withdrawalButton) {
      $0.addTarget(self,
                   action: #selector(self.clickedWithdrawButton),
                   for: .touchUpInside)
      
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(self.view.snp.bottom)
          .offset(-49 - (self.tabBarController?.tabBar.frame.height)!)
        $0.width.equalTo(self.view.frame.width * 296/375)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  private func relayoutTermsContainerView() {
    termsContainerView.snp.remakeConstraints {
      $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(22)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(self.view.frame.width * 328/375)
      $0.bottom.equalTo(self.secondTermLabel.snp.bottom).offset(40)
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    navigationView.naviTitle.text = "회원탈퇴"
    titleLabel.setupLabel(text: "유의사항",
                          color: .blackText,
                          font: .nanumRoundExtraBold(fontSize: 16))
    
    subtitleLabel.setupLabel(text: "회원 탈퇴 전에 꼭 확인해주세요.",
                             color: .grayText,
                             font: .nanumRoundRegular(fontSize: 12))
    
    configFirstTerm()
    configSecondTerm()
    withdrawalButton.setupButton(title: "회원 탈퇴",
                                 color: .blackText,
                                 font: .nanumRoundExtraBold(fontSize: 14),
                                 backgroundColor: .gray249,
                                 state: .normal,
                                 radius: 10)
  }
  
  private func configFirstTerm() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(
      string: self.firstTerm,
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 14),
                   .foregroundColor: UIColor.blackText])
    
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    
    firstTermLabel.attributedText = titleText
  }
  
  private func configSecondTerm() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(
      string: self.secondTerm,
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 14),
                   .foregroundColor: UIColor.blackText])
    
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    
    secondTermLabel.attributedText = titleText
  }
  
  private func withdraw() {
    userService.memberShipWithdrawal()
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            print("success")
            LoginManager.shared.makeLogoutStatus()
            let root = LoginEmailViewController()
            let rootNav = UINavigationController()
            rootNav.navigationBar.isHidden = true
            rootNav.viewControllers = [root]
            if let window = self.view.window {
              window.rootViewController = rootNav
            }
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  // MARK: - Action Helpers
  @objc
  private func clickedWithdrawButton() {
    withdraw()
  }
}
