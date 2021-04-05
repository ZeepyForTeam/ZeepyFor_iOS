//
//  RxMoya+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/10.
//

import Foundation
import RxSwift
import Moya
import CoreData
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  //static let authProvider = MoyaProvider<AuthServices>(plugins: [NetworkLoggerPlugin()])

  public func filter401StatusCode() -> Single<Element> {
    return flatMap { response in
      guard response.statusCode != 401 else {
        throw MoyaError.statusCode(response)
      }
      return .just(response)
    }
  }
  public func filter500StatusCode() -> Single<Element> {
    return flatMap { response in
      guard response.statusCode != 500 else {
        MessageAlertView.shared.showAlertView(title: "서버 에러입니다.", grantMessage: "확인")
        throw MoyaError.statusCode(response)
      }
      return .just(response)
    }
  }
}
