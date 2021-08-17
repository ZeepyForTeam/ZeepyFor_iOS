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
  let address, communityCategory, content: String
  let currentNumberOfPeople: Int
  let imageUrls: [String]
  let instructions, productName: String
  let productPrice: Int
  let purchasePlace, sharingMethod: String
  let targetNumberOfPeople: Int
  let title: String
  let writerId: Int
}

struct LikeRequest: Encodable {
  let commuinityId: Int
  let userEmail: String?
}
struct JoinRequset: Codable {
    let comment: String
    let isSecret: Bool
    let participationUserId: Int
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
