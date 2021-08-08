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
  func loginFail() {
    MessageAlertView.shared.showAlertView(title: "로그인에 실패하였습니다.", grantMessage: "확인")
  }
  func login(param: AuthRequest) -> Observable<Result<AuthResponse,APIError>> {
    provider.rx.request(.login(param: param))
      .filterError()
      .mapResult(AuthResponse.self)
  }
}
