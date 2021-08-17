//
//  ReviewModel.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/30.
//

import Foundation

// MARK: - ReviewModel
struct ReviewModel: Codable {
  var address: String
  var buildingID: Int
  var communcationTendency: String
  var furnitures, imageUrls: [String]
  var lessorAge, lessorGender, lessorReview, lightning: String
  var pest, review, roomCount, soundInsulation: String
  var totalEvaluation: String
  var waterPressure: String
  
  enum CodingKeys: String, CodingKey {
    case address
    case buildingID = "buildingId"
    case communcationTendency, furnitures, imageUrls, lessorAge, lessorGender, lessorReview, lightning, pest, review, roomCount, soundInsulation, totalEvaluation, waterPressure
  }
  
}


