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
  case fetchKakaoAddress(keyword: String)
}

extension S3Router : TargetType {
  public var baseURL: URL {
    switch self {
    case .sendImg(url: let url, img: _) :
      return URL(string: url)!
    case .fetchKakaoAddress(keyword: let keyword) :
      return URL(string: Environment.kakaoURL)!
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
    case .fetchKakaoAddress:
      return ""
    }
  }
  var method: Moya.Method {
    switch self {

    case.s3Storage, .fetchKakaoAddress:
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
      let data = img.jpegData(compressionQuality: 0.4)!
      return .requestData(data)
    case .fetchKakaoAddress(keyword: let keyword):
      return .requestParameters(parameters: ["query": keyword], encoding: URLEncoding.queryString)
    }
  }
  var headers: [String : String]? {
    switch self {
    case .sendImg:
      return ["Content-Type":"application/json"]
    case .fetchKakaoAddress:
      return ["Content-Type": "application/json",
              "Authorization": "KakaoAK 82fbfb142396c7168cdb5e97cb3e1d8e"]
    default:
      guard let accessToken = UserDefaultHandler.accessToken else {
        return ["Content-Type": "application/json"]
      }
      return ["Content-Type": "application/json",
              "X-AUTH-TOKEN" : accessToken]
    }
  }
}
