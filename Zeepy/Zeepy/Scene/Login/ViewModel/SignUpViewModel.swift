//
//  SignUpViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/05.
//

import Foundation
import RxSwift
import Moya


class SignUpViewModel {
  private let service = AuthService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let emailText : Observable<String>
    let passwordText: Observable<String>
    let passwordCheck: Observable<String>
    let nicknameText: Observable<String>
    let registerButtonDidTap: Observable<Void>
  }
  struct Output {
    let emailValidate: Observable<Bool>
    let passwordValidate: Observable<Bool>
    let passwordSame: Observable<Bool>
    let nickNameValidate: Observable<Bool>
    let registerEnabled: Observable<Bool>
    let registerResult: Observable<Bool>
    let autoLoginResult: Observable<Result<AuthResponse, APIError>>
  }
}
extension SignUpViewModel {
  func transform(inputs: Input) -> Output {
    weak var `self` = self
    let emailRuleValidate = inputs.emailText.share().map{$0.validate(with: .email)}.share()
      
    let emailValidate = Observable.zip(emailRuleValidate, inputs.emailText)
      .flatMapLatest{ (rule , text) -> Observable<Bool> in
        if rule {
          return self?.service.checkEmail(email: text) ?? .empty()
        }
        else {
          return Observable.just(false)
        }
      }.share()
    let nickNameRuleValidate = inputs.nicknameText.map{$0.validate(with: .nickname)}.share()
    let nickNameValidate = Observable.zip(nickNameRuleValidate, inputs.nicknameText)
      .flatMapLatest{ (rule , text) -> Observable<Bool> in
        if rule {
          return self?.service.checkEmail(email: text) ?? .empty()
        }
        else {
          return Observable.just(false)
        }
      }.share()
    let passWordRuleValidate = inputs.passwordText.map{$0.validate(with: .password)}.share()
    let passWordValidate = Observable.zip(inputs.passwordCheck, inputs.passwordText)
      .flatMapLatest{ (check, pw) -> Observable<Bool> in
          return Observable.just(check == pw)
       
      }.share()
    let registerEnabled = Observable.combineLatest(emailValidate,
                                                   passWordValidate,
                                                   nickNameValidate)
      .map{$0.0 && $0.1 && $0.2}.share()
    let makeRegister = inputs.registerButtonDidTap
      .withLatestFrom(Observable
                        .combineLatest(inputs.emailText,
                                       inputs.nicknameText,
                                       inputs.passwordText))
      
      .map{ (email, nickname, pw) in
      RegisterRequset(email: email, name: nickname, password: pw)
      }.distinctUntilChanged().flatMapLatest{ param -> Observable<Bool> in
        self?.service.register(param: param) ?? .empty()
      }.share()
    let login = makeRegister
      .filter{$0}
      .withLatestFrom(Observable
                        .combineLatest(inputs.emailText,
                                       inputs.passwordText))
      .flatMapLatest{ id, pw in
        self?.service.login(param: .init(email: id, password: pw)) ?? .empty()
      }.share()
    return .init(emailValidate: emailValidate,
                 passwordValidate: passWordRuleValidate,
                 passwordSame: passWordValidate,
                 nickNameValidate: nickNameValidate,
                 registerEnabled: registerEnabled,
                 registerResult: makeRegister,
                 autoLoginResult: login)
  }
}
