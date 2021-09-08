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
  case register(param: RegisterRequset)
  case emailCheck(email: String)
  case nicknameCheck(name:String)
  case logout
  case refreshToken(param : RefreshRequest)
  case kakaoLogin(token: String)
  case appleLogin(param: AppleLoginParam)
  case naverLogin(token: String)
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
      return "/user/registration"
    case .emailCheck:
      return "/user/redundancy/email"
    case .nicknameCheck:
      return "/user/redundancy/nickname"
    case .logout:
      return "/auth/logout"
    case .refreshToken(param: let param):
      return "/auth/reissue"
    case .kakaoLogin(token: let token):
      return "/auth/login/kakao"
    case .appleLogin:
      return "/auth/login/apple"
    case .naverLogin:
      return "/auth/login/naver"
    }
  }
  var method: Moya.Method {
    switch self {
    case .login(param: let param):
      return .post
    case .register:
      return .post
    case .emailCheck:
      return .post
    case .nicknameCheck:
      return .post
    case .logout:
      return .delete
    case .refreshToken(param: let param):
      return .post
    case .kakaoLogin(token: let token):
      return .post
    case .appleLogin,
         .naverLogin:
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
    case .register(let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .emailCheck(let email):
      let param = ["email" : email]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .nicknameCheck(let name):
      let param = ["nickname" : name]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .logout:
      return .requestPlain
    case .refreshToken(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .kakaoLogin(token: let token):
      let param = ["accessToken" : token]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .appleLogin(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .naverLogin(token: let token):
      let param = ["accessToken" : token]
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    }
    
  }
  var headers: [String : String]? {
    switch self {
    case .logout :
      guard let accessToken = UserDefaultHandler.accessToken else {
        return ["Content-Type": "application/json"]
      }
      return ["Content-Type": "application/json",
              "X-AUTH-TOKEN" : accessToken]
    default:
      return ["Content-Type":"application/json"]
    }
  }
}
