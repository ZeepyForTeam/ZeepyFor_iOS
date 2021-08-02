//
//  BuildingResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation
// MARK: - BuildingResponseModel
struct BuildingResponseModel: Codable {
    let content: [BuildingContent]
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let pageable: Pageable
    let size: Int
    let sort: Sort
    let totalElements, totalPages: Int
}

// MARK: - BuildingContent
struct BuildingContent: Codable {
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

// MARK: - Pageable
struct Pageable: Codable {
    let offset, pageNumber, pageSize: Int
    let paged: Bool
    let sort: Sort
    let unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}


// MARK: - BuildingLikeResponseElement
struct BuildingLikeResponseElement: Codable {
    let id: Int?
    let likeDate: LikeDate?
    let user: Int?
}

// MARK: - LikeDate
struct LikeDate: Codable {
    let date, day, hours, minutes: Int?
    let month, nanos, seconds, time: Int?
    let timezoneOffset, year: Int?
}

typealias BuildingLikeResponse = [BuildingLikeResponseElement]


extension BuildingContent {
//  var toModel: BuildingModel {
//    return .init(buildingName: apartmentName,
//                 buildingImage: "",
//                 ownderInfo: <#T##ValidateType#>,
//                 review: .init(reviewrName: <#T##String#>, review: <#T##String#>),
//                 filters: <#T##[String]#>)
//  }
}
