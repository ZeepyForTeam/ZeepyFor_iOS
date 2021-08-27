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
// MARK: - MyZip
struct MyZip : Decodable {
  
  let id: Int?
  let communityCategory: String?
  let title: String?
  let content: String?
  let createdTime: String?
  let isCompleted: Bool?
  
}
extension MyZip {
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
    return .init(id: id ?? 0, type: type, status: isCompleted == false, postTitle: title ?? "", postConent: content ?? "", postedAt: createdTime ?? "")
  }
}
// MARK: - Content
struct CommunityContent: Decodable {
  let address: String?
  let comments: [Comment]?
  let communityCategory, content: String?
  let createdTime: String?
  let id: Int?
  let imageUrls: [String]?
  let isCompleted, isLiked, isParticipant: Bool?
  let participants: [ParticipationList]?
  let productName: String?
  let purchasePlace: String?
  let productPrice: String?
  let sharingMethod: String?
  let targetNumberOfPeople: Int?
  let title: String?
  let user: ContentUser?
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
    return .init(id: id ?? 0, type: type, status: isCompleted == false, postTitle: title ?? "", postConent: content ?? "", postedAt: createdTime ?? "")
  }
  var category: String{
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
    return type.rawValue
  }
}

// MARK: - Comment
struct Comment: Decodable {
  let comment: String
  let createdTime: String
  let id: Int
  let communityId: Int
  let superCommentId: Int?
  let isParticipation, isSecret: Bool?
  let subComments: [Comment]?
  let writer: ContentUser
  
}
extension Comment {
  func toCommentModel() -> CommentSectionModel {
    return .init(identity: id, profile: writer.profileImage ?? "", userName: writer.name ?? "비공개", userId: writer.id ?? -1, comment: comment, hidden: isSecret == true, postedAt: createdTime ,isMember: isParticipation == true)
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
  
  let id: Int
  let user: ContentUser
}

// MARK: - ContentUser
struct ContentUser: Decodable {
  let id: Int?
  let name: String?
  let profileImage: String?
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
