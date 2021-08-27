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
  case fetchReviewDetail(review: Int)
  case deleteReview(id: Int)
  case getUserReviews
  case s3Storage
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
    case .deleteReview(let id):
      return "/review/\(id)"
    case .fetchReviewDetail(let review) :
      return "/review/\(review)"
    case .getUserReviews:
      return "/review/user"
    case .s3Storage:
      return "/s3"
    }
  }
  var method: Moya.Method {
    switch self {

    case .addReview(param: let param):
      return .post
    case .fetchReviewByAddress,
         .fetchReviewDetail:
      return .get
    case .deleteReview(id: let id):
      return .delete
    case .getUserReviews,
         .s3Storage:
      return .get
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
    case .getUserReviews,
         .fetchReviewDetail:
      return .requestPlain

    case .s3Storage:
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
