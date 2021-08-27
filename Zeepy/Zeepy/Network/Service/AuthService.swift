//
//  AuthService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/05.
//

import Foundation
import Moya
import RxSwift
class AuthService {
  private let provider : MoyaProvider<AuthRouter>
  init(provider : MoyaProvider<AuthRouter>) {
    self.provider = provider
  }
}
extension AuthService {

  func login(param: AuthRequest) -> Observable<Result<AuthResponse,APIError>> {
    provider.rx.request(.login(param: param))
      .filterError()
      .mapResult(AuthResponse.self)
  }
  func kakaoLogin(token : String) -> Observable<Result<AuthResponse,APIError>> {
    provider.rx.request(.kakaoLogin(token: token))
      .filterError()
      .mapResult(AuthResponse.self)
  }
  func naverLogin(token : String) -> Observable<Result<AuthResponse,APIError>> {
    provider.rx.request(.naverLogin(token: token))
      .filterError()
      .mapResult(AuthResponse.self)
  }
  func appleLogin(param : AppleLoginParam) -> Observable<Result<AppleResponse,APIError>> {
    provider.rx.request(.appleLogin(param: param))
      .filterError()
      .mapResult(AppleResponse.self)
  }
  func checkEmail(email: String) -> Observable<Bool> {
    provider.rx.request(.emailCheck(email: email))
      .successFlag()
      .asObservable()
  }
  func checkNickname(name: String) -> Observable<Bool> {
    provider.rx.request(.nicknameCheck(name: name))
      .successFlag()
      .asObservable()
  }
  func register(param: RegisterRequset) -> Observable<Bool> {
    provider.rx.request(.register(param: param))
      .successFlag()
      .asObservable()
  }
}
