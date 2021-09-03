//
//  LoninManager.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/15.
//

import Foundation
import UIKit
class LoginManager: NSObject {
  
  static let shared = LoginManager()
  private let login = "isLogin"
  
  override private init() { }
  
  func isLogin() -> Bool {
    return UserDefaults.standard.bool(forKey: login)
  }
  
  func makeLoginStatus(
    accessToken: String,
    refreshToken: String,
    loginType: LoginType,
    userId: Int
  ) {
    UserDefaultHelper<String>.set(accessToken, forKey: .accessToken)
    UserDefaultHelper<String>.set(refreshToken, forKey: .refreshToken)
    UserDefaultHelper<String>.set(loginType.rawValue, forKey: .loginType)
    UserDefaultHelper<Int>.set(userId, forKey: .userId)

    UserDefaults.standard.set(true, forKey: login)
    UserDefaults.standard.synchronize()
  }
  
  func makeLogoutStatus() {
    UserDefaultHelper<Any>.clearAll()
    UserDefaults.standard.set(false, forKey: login)
    UserDefaults.standard.synchronize()
  }
  func unAuthorizeAction() {
    MessageAlertView.shared.showAlertView(title: "기능 제한 없이 Zeepy의\n모든 기능을 즐겨보세요!", grantMessage: "확인", denyMessage: "취소", okAction: {
      LoginManager.shared.makeLogoutStatus()
      let root = LoginEmailViewController()
      let rootNav = UINavigationController()
      rootNav.navigationBar.isHidden = true
      
      rootNav.viewControllers = [root]
      if let window = (UIApplication.shared.delegate as! AppDelegate).window {
        window.rootViewController = rootNav
      }
    })
  }
  func sendLogInPage() {
    MessageAlertView.shared.showAlertView(title: "정말 로그아웃 하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: {
      LoginManager.shared.makeLogoutStatus()
      let root = LoginEmailViewController()
      let rootNav = UINavigationController()
      rootNav.navigationBar.isHidden = true
      
      rootNav.viewControllers = [root]
      if let window = (UIApplication.shared.delegate as! AppDelegate).window {
        window.rootViewController = rootNav
      }
    })
  }
}
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift
class kakaoLoginManager: NSObject {
  static let shared = kakaoLoginManager()
  
  func makeLogin() {
    let disposeBag = DisposeBag()
    
    // 카카오톡 설치 여부 확인
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.rx.loginWithKakaoTalk()
        .subscribe(onNext:{ (oauthToken) in
          print("loginWithKakaoTalk() success.")
          print(oauthToken)
          //do something
          _ = oauthToken
        }, onError: {error in
          print(error)
        })
        .disposed(by: disposeBag)
    }
  }
}
import AuthenticationServices

final class AppleLoginManager: NSObject {
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }
}
