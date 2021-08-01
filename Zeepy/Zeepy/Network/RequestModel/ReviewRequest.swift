//
//  ReviewRequest.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation

// MARK: - SaveReviewRequest
struct SaveReviewRequest: Codable {
    let address: String
    let buildingId: Int
    let communcationTendency: String
    let furnitures, imageUrls: [String]
    let lessorAge, lessorGender, lessorReview, lightning: String
    let pest, review, roomCount, soundInsulation: String
    let totalEvaluation: String
    let user: Int
    let waterPressure: String
}
