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
  let exclusivePrivateArea, id: Int
  let latitude, longitude: Double
  let reviews: [Review]
  let shortAddress: String
}

struct BuildingModelByAddress: Codable {
  let apartmentName: String
  let areaCode, buildYear: Int
  let buildingDeals: [BuildingDeal]
  let buildingLikes: [BuildingLike]
  let exclusivePrivateArea: Float
  let id: Int
  let latitude, longitude: Double
  let reviews: [ReviewResponseDto]
  let shortAddress: String
}

// MARK: - BuildingDeal
struct BuildingDeal: Codable {
  let dealCost: Int
  let dealDate: String
  let dealType: String
  let deposit, floor, id, monthlyRent: Int
}

struct BuildingDeals: Codable {
    let dealCost: Int
    let dealDate: String
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
  let likeDate: String
  let email: String
}

struct BuildingLikes: Codable {
    let id: Int
    let likeDate: String
    let email: String
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
    let totalEvaluation : String
}

// MARK: - Review
struct MapReview: Codable {
    let communcationTendency: String
    let furnitures: [String]
    let id: Int
    let imageUrls: [String]
    let lessorAge, lessorGender, lessorReview, lightning: String
    let pest, review, roomCount, soundInsulation: String
    let totalEvaluation: String
    let user: MapUser
    let waterPressure: String
}

// MARK: - User
struct MapUser: Codable {
    let addresses: [MapAddress]
    let id: Int
    let name: String
}

// MARK: - Address
struct MapAddress: Codable {
    let cityDistinct, detailAddress, primaryAddress: String
}

//struct Review_all: Codable {
//    let id: Int
//    let user: User
//    let communcationTendency: String
//    let lessorGender: LessorGender
//    let lessorAge: LessorAge
//    let lessorReview: String
//    let roomCount: RoomCount
//    let soundInsulation, pest, lightning, waterPressure: Lightning
//    let furnitures: [JSONAny]
//    let review: String
//    let totalEvaluation: TotalEvaluation
//    let imageUrls: [JSONAny]
//}

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
//MARK: - BuildingAll

struct buildingAllListModel: Codable {
    let apartmentName: String
    let areaCode, buildYear: Int
    let buildingDeals: [BuildingDeals]
    let buildingLikes: [BuildingLikes]
    let exclusivePrivateArea: Float
    let fullNumberAddress, fullRoadNameAddress: String
    let id: Int
    let latitude, longitude : Double
    let reviews: [MapReview]
    let shortAddress, shortNumberAddress, shortRoadNameAddress: String
}

struct SearchAddressModel: Codable {
  let content: [Content]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
  let totalElements, totalPages: Int
}

// MARK: - Content
struct Content: Codable {
  let apartmentName, fullNumberAddress, fullRoadNameAddress: String
  let id: Int
  let shortAddress, shortNumberAddress, shortRoadNameAddress: String
}

// MARK: - BuildingUserLikeModel
struct BuildingUserLikeResponseModel: Codable {
  let content: [BuildingUserLikeResponse]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: PageableUserLike
  let size: Int
  let sort: SortUserLike
  let totalElements, totalPages: Int
}

// MARK: - Content
struct BuildingUserLikeResponse: Codable {
  let apartmentName: String
  let areaCode, buildYear: Int
  let buildingType: String
  let buildingDeals: [BuildingDealUserLike]
  let buildingLikes: [BuildingLikeUserLike]
  let exclusivePrivateArea: Float
  let fullNumberAddress, fullRoadNameAddress: String
  let id : Int
  let latitude, longitude: Double
  let reviews: [ReviewUserLike]
  let shortAddress, shortNumberAddress, shortRoadNameAddress: String
}

// MARK: - BuildingDeal
struct BuildingDealUserLike: Codable {
  let dealCost: Int
  let dealDate: String
  let dealType: String
  let deposit, floor, id, monthlyRent: Int
}

// MARK: - BuildingLike
struct BuildingLikeUserLike: Codable {
  let email: String
  let id: Int
  let likeDate: String
}

// MARK: - Review
struct ReviewUserLike: Codable {
  let communcationTendency: String
  let furnitures: [String]
  let id: Int
  let imageUrls: [String]?
  let lessorAge, lessorGender, lessorReview, lightning: String
  let pest, review, roomCount, soundInsulation: String
  let totalEvaluation: String
  let user: UserUserLike
  let waterPressure: String
}

// MARK: - User
struct UserUserLike: Codable {
  let addresses: [Addresses]
  let id: Int
  let name: String
}


// MARK: - Pageable
struct PageableUserLike: Codable {
  let offset, pageNumber, pageSize: Int
  let paged: Bool
  let sort: SortUserLike
  let unpaged: Bool
}

// MARK: - Sort
struct SortUserLike: Codable {
  let empty, sorted, unsorted: Bool
}


typealias BuildingLikeResponse = [BuildingLikeResponseElement]


extension BuildingContent {
  func toModel() -> BuildingModel {
    let firstImg = self.reviews.flatMap{$0.imageUrls}.first ?? ""
    let ownerType = self.reviews.flatMap{$0.communcationTendency}.map{ str -> ValidateType in
      switch String(str) {
      case "BUSINESS" :
        return ValidateType.business
      case "KIND" :
        return .kind
      case "GRAZE" :
        return .free
      case "SOFTY" :
        return .cute
      default :
        return ValidateType.bad
      }
    }.first ?? .business
    let review = self.reviews.flatMap{ ReviewInfo.init(reviewrName: String($0.user), review: $0.review)}.first ?? .init(reviewrName: "없음", review: "없음")
    return .init(buildingName: apartmentName, buildingImage: firstImg, ownderInfo: ownerType, review: review, filters: ["test","test","test"])
  }
}
