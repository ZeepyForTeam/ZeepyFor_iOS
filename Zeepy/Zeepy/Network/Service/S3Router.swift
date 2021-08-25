//
//  S3Router.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/25.
//

import Foundation
import Moya

enum S3Router {
  case s3Storage
  case sendImg(url: String , img : UIImage)
}

extension S3Router : TargetType {
  public var baseURL: URL {
    switch self {
    case .sendImg(url: let url, img: _) :
      return URL(string: url)!
    default :
      return URL(string: Environment.baseUrl)!
    }
  }
  var path: String {
    switch self {
 
    case .s3Storage:
      return "/s3"
    case .sendImg:
      return ""
    }
  }
  var method: Moya.Method {
    switch self {

    case.s3Storage:
      return .get
    case .sendImg:
      return .put
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {
  
    case .s3Storage:
      return .requestPlain
    case .sendImg(_, let img):
      let data = img.jpegData(compressionQuality: 1.0)!
      return .requestData(data)
    }
  }
  var headers: [String : String]? {
    switch self {
    case .sendImg:
      return ["Content-Type":"application/json"]
    default:
      return ["Content-Type":"application/json",
              "X-AUTH-TOKEN" : UserDefaultHandler.accessToken!]
    }
  }
}
