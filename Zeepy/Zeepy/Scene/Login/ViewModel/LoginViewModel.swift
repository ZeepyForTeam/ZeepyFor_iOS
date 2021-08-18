//
//  LoginViewModel.swift
//  Zeepy
//

import Foundation
import RxSwift
import Moya

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

import AuthenticationServices

class LoginViewModel {
  private let service = AuthService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let emailText : Observable<String>
    let passwordText: Observable<String>
    let loginButtonDidTap: Observable<Void>
    let kakaoLogin: Observable<Void>
//    let appleLogin: Observable<Void>
    //    let findEmail: Observable<Void>
    //    let findPassword: Observable<Void>
    //    let register: Observable<Void>
  }
  struct Output {
    let isLoginSuccess: Observable<Result<AuthResponse, APIError>>
    let socialLoginSuccess:  Observable<Result<AuthResponse, APIError>>
  }
}
extension LoginViewModel {
  func transform(inputs: Input) -> Output {
    weak var `self` = self
    let idPw = Observable.combineLatest(inputs.emailText, inputs.passwordText)
    let result = inputs.loginButtonDidTap
      .withLatestFrom(idPw)
      .flatMapLatest{ (id, pw) in
        self?.service.login(param: .init(email: id, password: pw)) ?? .empty()
      }
    

    
    let socialLogin = inputs.kakaoLogin.flatMapLatest{  _ -> Observable<OAuthToken> in
      if (UserApi.isKakaoTalkLoginAvailable()) {
        return UserApi.shared.rx.loginWithKakaoTalk()
      }
      else {
        return .empty()
      }
    }.flatMapLatest{ token in
      self?.service.kakaoLogin(token: token.accessToken) ?? .empty()
    }
    return .init(isLoginSuccess: result,
                 socialLoginSuccess: socialLogin)
  }
}
