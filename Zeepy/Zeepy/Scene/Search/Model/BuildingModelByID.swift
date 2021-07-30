//
//  BuildingModelByID.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/27.
//

import Foundation

// MARK: - BuildingModelByID
struct BuildingModelByID: Codable {
    let address, apartmentName: String
    let areaCode, buildYear: Int
    let buildingDeals: [BuildingDeal]
    let buildingLikes: [BuildingLike]
    let exclusivePrivateArea, id, latitude, longitude: Int
    let reviews: [Review]
    let shortAddress: String
}

// MARK: - BuildingDeal
struct BuildingDeal: Codable {
    let dealCost: Int
    let dealDate: DealDateClass
    let dealType: String
    let deposit, floor, id, monthlyRent: Int
}

// MARK: - DealDateClass
struct DealDateClass: Codable {
    let date, day, hours, minutes: Int
    let month, nanos, seconds, time: Int
    let timezoneOffset, year: Int
}

// MARK: - BuildingLike
struct BuildingLike: Codable {
    let id: Int
    let likeDate: DealDateClass
    let user: Int
}

// MARK: - Review
struct Review: Codable {
    let address, communcationTendency: String
    let furnitures: [String]
    let id: Int
    let imageUrls: [String]
    let lessorAge, lessorReview, lightning, pest: String
    let review, soundInsulation: String
    let user: Int
    let waterPressure: String
}

