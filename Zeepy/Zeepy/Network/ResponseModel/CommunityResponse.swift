//
//  CommunityResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation
// MARK: - CommunityResponseModel
struct CommunityResponseModel: Decodable {
    let content: [CommunityContent]
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let pageable: Pageable
    let size: Int
    let sort: Sort
    let totalElements, totalPages: Int
}

// MARK: - Content
struct CommunityContent: Decodable {
    let address: String
    let comments: [Comment]
    let communityCategory, content: String
    let id: Int
    let imageUrls: [String]
    let isLiked, isParticipant: Bool
    let participationList: [ParticipationList]
    let productName: String
    let productPrice: Int
    let sharingMethod: String
    let targetNumberOfPeople: Int
    let title: String
    let user: ContentUser
}
extension CommunityContent {
  func toPostModel() -> PostModel {
    var type : PostType
    switch communityCategory {
    case "JOINTPURCHASE" :
      type = .deal
    case "FREESHARING" :
      type = .share
    case "NEIGHBORHOODFRIEND" :
      type = .friend
    default :
      type = .total
    }
    return .init(id: id, type: type, status: true, postTitle: content, postConent: content, postedAt: "2021-04-23")
  }
}

// MARK: - Comment
struct Comment: Decodable {
    let comment: String
    let community: Community
    let createdDate: String
    let id: Int
    let isParticipation, isSecret: Bool
    let subComments: [String]
    let user: CommunityUser
}
extension Comment {
  func toCommentModel() -> CommentSectionModel {
    return .init(identity: id, profile: "", userName: user.name, comment: comment, hidden: isSecret, postedAt: createdDate)
  }
}
// MARK: - Community
struct Community: Decodable {
    let address: String
    let comments: [String]
    let communityCategory, content, createdDate: String
    let currentNumberOfPeople, id: Int
    let imageUrls: [String]
    let instructions: String
    let likes: [Like]
    let participationsList: [String]
    let productName: String
    let productPrice: Int
    let purchasePlace, sharingMethod: String
    let targetNumberOfPeople: Int
    let title: String
    let user: CommunityUser
}

// MARK: - Like
struct Like: Decodable {
    let createdDate: String
    let id: Int
}

// MARK: - CommunityUser
struct CommunityUser: Decodable {
    let communities: [String]
    let id: Int
    let likedCommunities: [Like]
    let name: String
    let participatingCommunities: [String]
    let place: String
}

// MARK: - ParticipationList
struct ParticipationList: Decodable {
    let community: Community
    let createdDate: String
    let id: Int
    let user: CommunityUser
}

// MARK: - ContentUser
struct ContentUser: Decodable {
    let id: Int
    let name: String
}

struct CommunityParticipation: Decodable {
    let participationResDtoList, writeOutResDtoList: [ResDtoList]
}

// MARK: - ResDtoList
struct ResDtoList: Decodable {
    let communityCategory, content: String
    let id: Int
    let title: String
}
