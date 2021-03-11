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
}
