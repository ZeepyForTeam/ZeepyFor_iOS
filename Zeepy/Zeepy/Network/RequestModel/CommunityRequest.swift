//
//  CommunityRequest.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation
struct CommunityRequest: Encodable {
  let address: String?
  let communityType: String?
  let offset: Int?
  let pageNumber: Int?
  let pageSize: Int?
  let paged: Bool?
}

struct SaveCommunityRequest : Encodable {
  let address, communityCategory, content, title: String
  let imageUrls: [String]?
  let instructions, productName: String?
  let productPrice: Int?
  let purchasePlace, sharingMethod: String?
  let targetNumberOfPeople: Int?
}

struct LikeRequest: Encodable {
  let communityId: Int
}
struct JoinRequset: Codable {
    let comment: String
    let isSecret: Bool
}
struct PostCommentRequest: Encodable {
  let id: Int
  let writeCommentRequestDto : CommentRequest
}
struct CommentRequest : Encodable {
  let comment: String
  let isSecret: Bool
  let superCommentId: Int?
}
