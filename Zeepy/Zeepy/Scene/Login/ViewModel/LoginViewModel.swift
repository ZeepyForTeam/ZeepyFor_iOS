//
//  LoginViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/04.
//

import Foundation
import RxSwift
import Moya

class LoginViewModel {
  private let service = AuthService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let emailText : Observable<String>
    let passwordText: Observable<String>
    let loginButtonDidTap: Observable<Void>
//    let findEmail: Observable<Void>
//    let findPassword: Observable<Void>
//    let register: Observable<Void>
  }
  struct Output {
    let isLoginSuccess: Observable<Result<AuthResponse, APIError>>
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
    
    return .init(isLoginSuccess: result)
  }
}
