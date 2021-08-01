//
//  AreaCodeRouter.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation
import Moya

enum AreaCodeRouter {
  case uploadAreaCode(param: AreaCodeRequest)
  case updateAreaCode(id: Int, param:AreaCodeRequest)
  case deleteAreaCode(id: Int)
  
}

extension AreaCodeRouter : TargetType {
  
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {
    
    case .uploadAreaCode:
      return "/codes"
    case .updateAreaCode(let id, _):
      return "/codes/\(id)"
    case .deleteAreaCode(let id):
      return "/codes/\(id)"
    }
  }
  var method: Moya.Method {
    switch self {
    
    case .uploadAreaCode(param: let param):
      return .post
    case .updateAreaCode(id: let id, param: let param):
      return .put
    case .deleteAreaCode(id: let id):
      return .delete
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {
    
    case .uploadAreaCode(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .updateAreaCode(id: let id, param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .deleteAreaCode(id: let id):
      return .requestPlain
    }
  }
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json"]
    }
  }
}
