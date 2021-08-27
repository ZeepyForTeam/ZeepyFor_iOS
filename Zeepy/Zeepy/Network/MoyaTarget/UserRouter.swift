//
//  UserRouter.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/11.
//

import Foundation
import Moya

enum UserRouter {
  case getAddress
  case addAddress(param: ResponseGetAddress)
  case modifyNickname(nickname: String)
  case modifyPassword(param: RequestModifyPassword)
  case checkForRedundancyEmail(email: String)
  case checkFromRedundancyNickname(nickname : String)
  case registration(param: RequestRegistration)
  case memberShipWithdrawal
  case fetchNickname
  case fetchEmail
  case putMarketing
  case report(param: RequestReportModel)
}

extension UserRouter : TargetType {
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {
    case .getAddress:
      return "/user/address"
    case .addAddress(param: let param):
      return "/user/address"
    case .modifyNickname(nickname: let nickname):
      return "/user/nickname"
    case .modifyPassword(param: let param):
      return "/user/password"
    case .checkForRedundancyEmail(email: let email):
      return "/user/redundancy/email"
    case .checkFromRedundancyNickname(nickname: let nickname):
      return "/user/redundancy/nickname"
    case .registration(param: let param):
      return "/user/registration"
    case .memberShipWithdrawal:
      return "/user/withdrawal"
    case .fetchNickname:
      return "/user/nickname/email"
    case .fetchEmail:
      return "/user/mail"
    case .putMarketing:
      return "/user/mail"
    case .report(param: let param):
      return "/reports"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getAddress,
         .fetchNickname,
         .fetchEmail:
      return .get
    case .checkForRedundancyEmail,
         .checkFromRedundancyNickname,
         .registration,
         .report:
      return .post
    case .addAddress,
         .putMarketing:
      return .put
    case .modifyNickname,
         .modifyPassword:
      return .put
    case .memberShipWithdrawal:
      return .delete
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .getAddress:
      return .requestPlain
    case .addAddress(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .modifyNickname(nickname: let nickname):
      let param = ["nickname": nickname]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .modifyPassword(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .checkForRedundancyEmail(email: let email):
      let param = ["email": email]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .checkFromRedundancyNickname(nickname: let nickname):
      let param = ["nickname": nickname]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .registration(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .memberShipWithdrawal:
      return .requestPlain
    case .fetchNickname:
      return .requestPlain
    case .fetchEmail:
      return .requestPlain
    case .putMarketing:
      return .requestPlain
    case .report(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    }
  }
  var headers: [String : String]? {
    switch self {
    default :
      guard let accessToken = UserDefaultHandler.accessToken else {
        return ["Content-Type": "application/json"]
      }
      return ["Content-Type": "application/json",
              "X-AUTH-TOKEN" : accessToken]
    }
  }
}

