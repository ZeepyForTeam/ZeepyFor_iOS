//
//  PostModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import Foundation
struct PostModel {
  let id: Int
  let type: PostType
  let status: Bool
  let postTitle: String
  let postConent: String
  let postedAt: String
}
enum PostType : String {
  case total  = "전체 보기"
  case deal  = "공동 구매"
  case share  = "무료 나눔"
  case friend  = "동네 친구"
  
}
extension PostType {
  var requestEnum : String? {
    switch self {
    case .total:
      return nil
    case .deal:
      return "JOINTPURCHASE"
    case .share:
      return "FREESHARING"
    case .friend:
      return "NEIGHBORHOODFRIEND"
    }
  }
}
extension PostModel : Comparable {
  static func < (lhs: PostModel, rhs: PostModel) -> Bool {
    return rhs.status
  }
}
struct PostDetailModel {
  let id : Int
  let type: PostType
  let status: Bool
  let postTitle: String
  let postConent: String
  let postedAt: String
  var like : Bool
  let images : [String]
}
