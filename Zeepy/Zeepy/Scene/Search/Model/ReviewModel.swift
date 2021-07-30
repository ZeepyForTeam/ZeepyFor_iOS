//
//  ReviewModel.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/30.
//

import Foundation

// MARK: - ReviewModel
struct ReviewModel: Codable {
  let address: String
  let buildingID: Int
  let communcationTendency: String
  let furnitures, imageUrls: [String]
  let lessorAge, lessorGender, lessorReview, lightning: String
  let pest, review, roomCount, soundInsulation: String
  let totalEvaluation: String
  let user: Int
  let waterPressure: String
  
  enum CodingKeys: String, CodingKey {
    case address
    case buildingID = "buildingId"
    case communcationTendency, furnitures, imageUrls, lessorAge, lessorGender, lessorReview, lightning, pest, review, roomCount, soundInsulation, totalEvaluation, user, waterPressure
  }
}


