//
//  UserService.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/11.
//

import Foundation

import Moya
import RxSwift

class UserService {
  private let provider : MoyaProvider<UserRouter>
  init(provider : MoyaProvider<UserRouter>) {
    self.provider = provider
  }
}
extension UserService {

  func getAddress() -> Observable<Response> {
    provider.rx.request(.getAddress)
      .asObservable()
  }
  func addAddress(param: ResponseGetAddress) -> Observable<Response> {
    provider.rx.request(.addAddress(param: param))
      .asObservable()
  }
  func modifyNickname(nickname: String) -> Observable<Response> {
    provider.rx.request(.modifyNickname(nickname: nickname))
      .asObservable()
  }
  func modifyPassword(param: RequestModifyPassword) -> Observable<Response> {
    provider.rx.request(.modifyPassword(param: param))
      .asObservable()
  }
  func checkForRedundancyEmail(email: String) -> Observable<Response> {
    provider.rx.request(.checkForRedundancyEmail(email: email))
      .asObservable()
  }
  func checkFromRedundancyNickname(nickname: String) -> Observable<Response> {
    provider.rx.request(.checkFromRedundancyNickname(nickname: nickname))
      .asObservable()
  }
  func registration(param: RequestRegistration) -> Observable<Response> {
    provider.rx.request(.registration(param: param))
      .asObservable()
  }
  func memberShipWithdrawal() -> Observable<Response> {
    provider.rx.request(.memberShipWithdrawal)
      .asObservable()
  }
}

