//
//  CommunityResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation
// MARK: - CommunityResponseModel
struct CommunityResponseModel: Codable {
    let content: [CommunityContent]
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let pageable: Pageable
    let size: Int
    let sort: Sort
    let totalElements, totalPages: Int
}

// MARK: - Content
struct CommunityContent: Codable {
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

// MARK: - Comment
struct Comment: Codable {
    let comment: String
    let community: Community
    let createdDate: String
    let id: Int
    let isParticipation, isSecret: Bool
    let subComments: [String]
    let user: CommunityUser
}

// MARK: - Community
struct Community: Codable {
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
struct Like: Codable {
    let createdDate: String
    let id: Int
}

// MARK: - CommunityUser
struct CommunityUser: Codable {
    let communities: [String]
    let id: Int
    let likedCommunities: [Like]
    let name: String
    let participatingCommunities: [String]
    let place: String
}

// MARK: - ParticipationList
struct ParticipationList: Codable {
    let community: Community
    let createdDate: String
    let id: Int
    let user: CommunityUser
}

// MARK: - ContentUser
struct ContentUser: Codable {
    let id: Int
    let name: String
}

struct CommunityParticipation: Codable {
    let participationResDtoList, writeOutResDtoList: [ResDtoList]
}

// MARK: - ResDtoList
struct ResDtoList: Codable {
    let communityCategory, content: String
    let id: Int
    let title: String
}
