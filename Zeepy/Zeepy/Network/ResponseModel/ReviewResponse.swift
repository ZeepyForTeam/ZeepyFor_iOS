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
    let user: Int
    let waterPressure: String
}
