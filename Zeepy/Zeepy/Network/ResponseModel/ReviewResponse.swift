//
//  ReviewResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation
// MARK: - ReviewResponse
struct ReviewResponse: Codable {
  let reviewResponseDtos: [ReviewResponseDto]
}

// MARK: - ReviewResponseDto
struct ReviewResponseDto: Codable {
  let address, communcationTendency: String
  let furnitures: [String]
  let id: Int
  let imageUrls: [String]
  let lessorAge, lessorReview, lightning, pest: String
  let review, soundInsulation: String
  let user: User
  let waterPressure: String
}

// MARK: - User
struct User: Codable {
    let addresses: [Addresses]
    let id: Int
    let name: String
}

// MARK: - UserReviewResponseModel
struct UserReviewResponseModel: Codable {
  let simpleReviewDtoList: [SimpleReviewDtoList]
}

// MARK: - SimpleReviewDtoList
struct SimpleReviewDtoList: Codable {
  let communcationTendency: String
  let id: Int
  let lessorAge, lightning, pest, soundInsulation: String
  let waterPressure: String
  let reviewDate: String
  let apartmentName: String?
}
