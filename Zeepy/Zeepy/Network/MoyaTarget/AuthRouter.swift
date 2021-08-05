//
//  AuthRouter.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/05.
//

import Foundation
import Moya
enum AuthRouter {
  case login(param: AuthRequest)
  case register
  case emailCheck
  case nicknameCheck
  case logout
  case refreshToken(param : RefreshRequest)
  case kakaoLogin(token: String)
}

extension AuthRouter : TargetType {
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {
    case .login(param: let param):
      return "/auth/login"
    case .register:
      return "/auth/logout"
    case .emailCheck:
      return "/auth"
    case .nicknameCheck:
      return "/auth"
    case .logout:
      return "/auth"
    case .refreshToken(param: let param):
      return "/auth/reissue"
    case .kakaoLogin(token: let token):
      return "/auth/login/kakao"
    }
  }
  var method: Moya.Method {
    switch self {


    case .login(param: let param):
      return .post
    case .register:
      return .post
    case .emailCheck:
      return .get
    case .nicknameCheck:
      return .get
    case .logout:
      return .delete
    case .refreshToken(param: let param):
      return .post
    case .kakaoLogin(token: let token):
      return .post
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {

    case .login(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .register:
      return .requestPlain
    case .emailCheck:
      return .requestPlain
    case .nicknameCheck:
      return .requestPlain
    case .logout:
      return .requestPlain
    case .refreshToken(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .kakaoLogin(token: let token):
      let param = ["accessToken" : token]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    }
  }
  var headers: [String : String]? {
    switch self {
    case .logout :
      return ["Content-Type":"application/json",
              "accessToken" : UserDefaultHandler.accessToken!]
    default:
      return ["Content-Type":"application/json"]
    }
  }
}
