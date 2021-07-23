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
        refreshToken: String
    ) {
        UserDefaultHelper<String>.set(accessToken, forKey: .accessToken)
        UserDefaultHelper<String>.set(refreshToken, forKey: .refreshToken)

        UserDefaults.standard.set(true, forKey: login)
        UserDefaults.standard.synchronize()
    }

    func makeLogoutStatus() {
        UserDefaultHelper<Any>.clearAll()
        UserDefaults.standard.set(false, forKey: login)
        UserDefaults.standard.synchronize()
    }
}
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
class kakaoLoginManager: NSObject {
  
}
