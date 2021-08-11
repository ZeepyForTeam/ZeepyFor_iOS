//
//  ModifyInformationViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ModifyInformationViewController
class ModifyInformationViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let nicknameTitleLabel = UILabel()
  private let nicknameTextField = UITextField()
  private let socialEmailTitleLabel = UILabel()
  private let socialImageView = UIImageView()
  private let socialEmailLabel = UILabel()
  private let passwordTitleLabel = UILabel()
  private let passwordTextField = UITextField()
  private let modifyButton = UIButton()
  private let logoutButton = UIButton()
  private let drououtButton = UIButton()
  
  // MARK: - Variables
//  private var socialType: String?
  private var socialType = "kakao"
  private var socialImageName = ["kakao": "kakaologo",
                                 "apple": "applelogo",
                                 "naver": "naverlogo"]
//  private var socialEmail: String?
  private var socialEmail = "zeepy.official@gmail.com"
  
  // MARK: -LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
    setupNavigation()
    temp()
  }
}

// MARK: - Extensions
extension ModifyInformationViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutNicknameTitleLabel()
    layoutNicknameTextField()
    layoutSocialEmailTitleLabel()
    layoutSocialImageView()
    layoutSocialEmailLabel()
    layoutPasswordTitleLabel()
    layoutPasswordTextField()
    layoutModifyButton()
    layoutLogoutButton()
    layoutDropoutButton()
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
  
  private func layoutNicknameTitleLabel() {
    view.add(nicknameTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.navigationView.snp.bottom).offset(24)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
      }
    }
  }
  
  private func layoutNicknameTextField() {
    view.add(nicknameTextField) {
      $0.addLeftPadding()
      $0.backgroundColor = .whiteTextField
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.nicknameTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
        $0.height.equalTo(40)
        $0.width.equalTo(self.view.frame.width * 343/375)
      }
    }
  }
  
  private func layoutSocialEmailTitleLabel() {
    view.add(socialEmailTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.nicknameTextField.snp.bottom).offset(32)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutSocialImageView() {
    view.add(socialImageView) {
      $0.setRounded(radius: 12)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.socialEmailTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
        $0.width.height.equalTo(24)
      }
    }
  }
  
  private func layoutSocialEmailLabel() {
    view.add(socialEmailLabel) {
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.socialImageView.snp.centerY)
        $0.leading.equalTo(self.socialImageView.snp.trailing).offset(8)
      }
    }
  }
  
  private func layoutPasswordTitleLabel() {
    view.add(passwordTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.socialImageView.snp.bottom).offset(26)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutPasswordTextField() {
    view.add(passwordTextField) {
      $0.backgroundColor = .whiteTextField
      $0.setRounded(radius: 8)
      $0.addLeftPadding()
      $0.snp.makeConstraints {
        $0.top.equalTo(self.passwordTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
        $0.height.equalTo(40)
        $0.width.equalTo(self.view.frame.width * 264/375)
      }
    }
  }
  
  private func layoutModifyButton() {
    view.add(modifyButton) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.passwordTextField.snp.trailing).offset(8)
        $0.top.equalTo(self.passwordTextField.snp.top)
        $0.bottom.equalTo(self.passwordTextField.snp.bottom)
        $0.width.equalTo(self.view.frame.width * 71/375)
      }
    }
  }
  
  private func layoutLogoutButton() {
    view.add(logoutButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.passwordTextField.snp.bottom).offset(16)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
        $0.width.equalTo(44)
        $0.height.equalTo(14)
      }
    }
  }
   
  private func layoutDropoutButton() {
    view.add(drououtButton) {
      $0.addTarget(self,
                   action: #selector(self.clickedWithdrawButton),
                   for: .touchUpInside)
      
      $0.snp.makeConstraints {
        $0.top.equalTo(self.logoutButton.snp.top)
        $0.leading.equalTo(self.logoutButton.snp.trailing).offset(12)
        $0.width.equalTo(44)
        $0.height.equalTo(14)
      }
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func clickedWithdrawButton() {
    let withdrawVC = WithdrawalViewController()
    self.navigationController?.pushViewController(withdrawVC, animated: true)
  }
  
  // MARK: - General Helpers
  private func configData() {
    nicknameTitleLabel.setupLabel(text: "닉네임",
                                  color: .blackText,
                                  font: .nanumRoundBold(fontSize: 14))
    
    socialEmailTitleLabel.setupLabel(text: "이메일 ID",
                                     color: .blackText,
                                     font: .nanumRoundBold(fontSize: 14))
    
    socialImageView.image = UIImage(named: socialImageName[self.socialType]!)
    socialEmailLabel.setupLabel(text: socialEmail,
                                color: .blackText,
                                font: .nanumRoundRegular(fontSize: 16),
                                align: .left)
    
    passwordTitleLabel.setupLabel(text: "비밀번호",
                                  color: .blackText,
                                  font: .nanumRoundBold(fontSize: 14))
    
    modifyButton.setupButton(title: "변경",
                             color: .blackText,
                             font: .nanumRoundBold(fontSize: 14),
                             backgroundColor: .pale,
                             state: .normal,
                             radius: 8)
    
    logoutButton.setupButton(title: "로그아웃",
                             color: .brownGrey,
                             font: .nanumRoundRegular(fontSize: 12),
                             backgroundColor: .clear,
                             state: .normal,
                             radius: 0)
    
    drououtButton.setupButton(title: "회원탈퇴",
                              color: .brownGrey,
                              font: .nanumRoundRegular(fontSize: 12),
                              backgroundColor: .clear,
                              state: .normal,
                              radius: 0)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "내 정보 수정")
  }
  
  //로그아웃기능 임시
  private func temp() {
    logoutButton.rx.tap.bind{
      MessageAlertView.shared.showAlertView(title: "정말 로그아웃 하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: {
          LoginManager.shared.makeLogoutStatus()
          let root = LoginEmailViewController()
          let rootNav = UINavigationController()
        rootNav.navigationBar.isHidden = true

          rootNav.viewControllers = [root]

           if let window = self.view.window {
               window.rootViewController = rootNav
           }
      })
    }.disposed(by: disposeBag)
  }
}
