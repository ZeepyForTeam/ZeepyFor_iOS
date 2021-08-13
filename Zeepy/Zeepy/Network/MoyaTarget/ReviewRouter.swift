//
//  ReviewRouter.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/01.
//

import Foundation
import Moya
enum ReviewRouter {
  case addReview(param: ReviewModel)
  case fetchReviewByAddress(address: String)
  case deleteReview(id: Int)
}

extension ReviewRouter : TargetType {
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {

    case .addReview(param: let param):
      return "/review"
    case .fetchReviewByAddress(address: let address):
      return "/review/\(address)"
    case .deleteReview(let id) :
      return "/review/\(id)"
    }
  }
  var method: Moya.Method {
    switch self {

    case .addReview(param: let param):
      return .post
    case .fetchReviewByAddress(address: let address):
      return .get
    case .deleteReview(id: let id):
      return .delete
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {
   
    case .addReview(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding
                                  .default)
    case .fetchReviewByAddress(address: let address):
      return .requestPlain
    case .deleteReview(id: let id):
      return .requestPlain
    }
  }
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "X-AUTH-TOKEN" : UserDefaultHandler.accessToken!]
    }
  }
}
