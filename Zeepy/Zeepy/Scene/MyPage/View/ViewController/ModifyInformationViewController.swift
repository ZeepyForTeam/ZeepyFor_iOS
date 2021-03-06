//
//  ModifyInformationViewController.swift
//  Zeepy
//
//  Created by λΈνμ on 2021/07/23.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then
import NaverThirdPartyLogin

// MARK: - ModifyInformationViewController
class ModifyInformationViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let nicknameTitleLabel = UILabel()
  private let nicknameLabel = UILabel()
  private let separatorView = UIView()
  private let socialEmailTitleLabel = UILabel()
  private let socialImageView = UIImageView()
  private let socialEmailLabel = UILabel()
  private let secondSeparatorView = UIView()
  private let passwordTitleLabel = UILabel()
  private let passwordTextField = UITextField()
  private let modifyButton = UIButton()
  private let thirdSeparatorView = UIView()
  private let logoutButton = UIButton()
  private let drououtButton = UIButton()
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
  // MARK: - Variables
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  ///  private var socialType: String?
  var userName: String?
  private var socialType = UserDefaultHandler.loginType
  private var socialImageName = ["kakao": "logoCacao",
                                 "apple": "logoApple",
                                 "naver": "logoNaver",
                                 "email": "AppIcon"]
  var socialEmail: String?
  private var passwordModel = RequestModifyPassword(password: "")
  
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
    layoutNicknameLabel()
    layoutSeparatorView()
    layoutSocialEmailTitleLabel()
    layoutSocialImageView()
    layoutSocialEmailLabel()
    layoutSecondSeparatorView()
    layoutPasswordTitleLabel()
    layoutPasswordTextField()
    layoutModifyButton()
    layoutThirdSeparatorView()
    layoutLogoutButton()
    layoutDropoutButton()
  }
  
  private func layoutNavigationView() {
    view.add(navigationView) {
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
  
  private func layoutNicknameLabel() {
    view.add(nicknameLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.nicknameTitleLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutSeparatorView() {
    view.add(separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.top.equalTo(self.nicknameLabel.snp.bottom).offset(16)
        $0.height.equalTo(1)
      }
    }
  }
  
  private func layoutSocialEmailTitleLabel() {
    view.add(socialEmailTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.separatorView.snp.bottom).offset(20)
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
  
  private func layoutSecondSeparatorView() {
    view.add(secondSeparatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(1)
        $0.top.equalTo(self.socialImageView.snp.bottom).offset(16)
      }
    }
  }
  
  private func layoutPasswordTitleLabel() {
    view.add(passwordTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.secondSeparatorView.snp.bottom).offset(20)
        $0.leading.equalTo(self.nicknameTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutPasswordTextField() {
    view.add(passwordTextField) {
      $0.backgroundColor = .whiteTextField
      $0.setRounded(radius: 8)
      $0.addLeftPadding()
      $0.isSecureTextEntry = true
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
      $0.addTarget(self,
                   action: #selector(self.passwordModifyButtonClicked),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.passwordTextField.snp.trailing).offset(8)
        $0.top.equalTo(self.passwordTextField.snp.top)
        $0.bottom.equalTo(self.passwordTextField.snp.bottom)
        $0.width.equalTo(self.view.frame.width * 71/375)
      }
    }
  }
  
  private func layoutThirdSeparatorView() {
    view.add(thirdSeparatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(1)
        $0.top.equalTo(self.passwordTextField.snp.bottom).offset(23)
      }
    }
  }
  private func layoutLogoutButton() {
    view.add(logoutButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.thirdSeparatorView.snp.bottom).offset(20)
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
    nicknameTitleLabel.setupLabel(text: "λλ€μ",
                                  color: .blackText,
                                  font: .nanumRoundBold(fontSize: 14))
    
    nicknameLabel.setupLabel(text: userName ?? "",
                             color: .blackText,
                             font: .nanumRoundRegular(fontSize: 14))
    
    socialEmailTitleLabel.setupLabel(text: "μ΄λ©μΌ ID",
                                     color: .blackText,
                                     font: .nanumRoundBold(fontSize: 14))
    
    socialImageView.image = UIImage(named: socialImageName[self.socialType ?? "email"] ?? "AppIcon")
    socialEmailLabel.setupLabel(text: socialEmail ?? "",
                                color: .blackText,
                                font: .nanumRoundRegular(fontSize: 16),
                                align: .left)
    
    passwordTextField.font = .nanumRoundRegular(fontSize: 12)
    passwordTextField.textColor = .blackText
    
    passwordTitleLabel.setupLabel(text: "λΉλ°λ²νΈ",
                                  color: .blackText,
                                  font: .nanumRoundBold(fontSize: 14))
    
    modifyButton.setupButton(title: "λ³κ²½",
                             color: .blackText,
                             font: .nanumRoundBold(fontSize: 14),
                             backgroundColor: .pale,
                             state: .normal,
                             radius: 8)
    
    logoutButton.setupButton(title: "λ‘κ·Έμμ",
                             color: .brownGrey,
                             font: .nanumRoundRegular(fontSize: 12),
                             backgroundColor: .clear,
                             state: .normal,
                             radius: 0)
    
    let logoutText = NSMutableAttributedString(string: "λ‘κ·Έμμ",
                                               attributes: [
                                                .font: UIFont.nanumRoundRegular(fontSize: 12),
                                                .foregroundColor: UIColor.brownGrey])
    
    logoutText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: logoutText.length))
    
    logoutButton.titleLabel?.attributedText = logoutText
    
    
    
    drououtButton.setupButton(title: "νμνν΄",
                              color: .brownGrey,
                              font: .nanumRoundRegular(fontSize: 12),
                              backgroundColor: .clear,
                              state: .normal,
                              radius: 0)
    
    let dropoutText = NSMutableAttributedString(string: "νμ νν΄",
                                                attributes: [
                                                  .font: UIFont.nanumRoundRegular(fontSize: 12),
                                                  .foregroundColor: UIColor.brownGrey])
    
    dropoutText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: dropoutText.length))
    
    drououtButton.titleLabel?.attributedText = dropoutText
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "λ΄ μ λ³΄ μμ ")
  }
  
  //λ‘κ·ΈμμκΈ°λ₯ μμ
  private func temp() {
    logoutButton.rx.tap.bind{
        MessageAlertView.shared.showAlertView(title: "μ λ§ λ‘κ·Έμμ νμκ² μ΅λκΉ?", grantMessage: "νμΈ", denyMessage: "μ·¨μ", mainColor: .pointYellow, okAction: { [weak self] in
        if UserDefaultHandler.loginType == "naver" {
          self?.loginInstance?.requestDeleteToken()
        }
        LoginManager.shared.makeLogoutStatus()
        let root = LoginEmailViewController()
        let rootNav = UINavigationController()
        rootNav.navigationBar.isHidden = true
        
        rootNav.viewControllers = [root]
        
        if let window = self?.view.window {
          window.rootViewController = rootNav
        }
      })

    }.disposed(by: disposeBag)
  }
  
  // MARK: - Aciton Helpers
  @objc
  private func passwordModifyButtonClicked() {
    let popupVC = ModifyPasswordPopupViewController()
    if passwordTextField.hasText == true {
      popupVC.passwordModel.password = passwordTextField.text ?? ""
      popupVC.modalPresentationStyle = .overFullScreen
      self.present(popupVC, animated: true, completion: nil)
    }
  }
}
