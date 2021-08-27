//
//  BuildingResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation
// MARK: - BuildingResponseModel
struct BuildingResponseModel: Decodable {
  let content: [BuildingContent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
  let totalElements, totalPages: Int
}

// MARK: - BuildingContent
struct BuildingContent: Decodable {
  let address, apartmentName: String?
  let id, areaCode, buildYear: Int?
  let buildingDeals: [BuildingDeal]?
  let buildingLikes: [BuildingLike]?
  let exclusivePrivateArea,latitude, longitude: Double?
  let reviews: [ReviewResponses]?
  let shortAddress, fullRoadNameAddress,
      shortRoadNameAddress,fullRoadAddress,fullNumberAddress,shortNumberAddress,buildingType: String?
  
}

struct BuildingModelByAddress: Decodable {
  let apartmentName: String?
  let areaCode, buildYear: Int?
  let buildingDeals: [BuildingDeal]
  let buildingLikes: [BuildingLike]
  let id: Int?
  let exclusivePrivateArea: Float
  let latitude, longitude: Double?
  let reviews: [ReviewReview]

  let shortAddress: String
}

// MARK: - BuildingDeal
struct BuildingDeal: Codable {
  let dealDate: String?
  let dealType: String?
  let deposit, floor, id, dealCost, monthlyRent: Int?

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
struct ReviewResponses: Decodable {
  let id: Int
  let user : UserResponses
  let address: String?
  let communcationTendency: String?
  let lessorGender: String?
  let lessorAge: String?
  let lessorReview: String?
  let roomCount: String?
  let soundInsulation: String?
  let pest: String?
  let lightning: String?
  let waterPressure: String?
  let furnitures: [String]?
  let review: String?
  let totalEvaluation: String?
  let imageUrls: [String]?
}
struct UserResponses : Decodable {
  let id: Int
  let name: String
  let addresses: [Addresses]?
 
  
}
// MARK: - Review
struct Review: Codable {
  let address, communcationTendency: String?
  let furnitures: [String]?
  let id: Int?
  let imageUrls: [String]?
  let lessorAge, lessorReview, lightning, pest: String?
  let review, soundInsulation: String?
  let user: Int?
  let waterPressure: String?
  let totalEvaluation : String?
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
    let id, buildYear: Int
    let apartmentName: String
    let shortAddress: String
    let fullRoadNameAddress, shortRoadNameAddress, fullNumberAddress, shortNumberAddress: String
    let exclusivePrivateArea: Float
    let areaCode: Int
    let latitude, longitude: Double
    let buildingType: String
    let buildingDeals: [BuildingDeals]
    let buildingLikes: [BuildingLikes]
    let reviews: [ReviewReview]
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
  func toDetailModel() -> BuildingDetailInfo {
    
    let dealTypes = (self.buildingDeals?.map{$0.dealType?.dealTypes
    }.first ?? "") ?? ""
    let images = reviews?.flatMap{$0.imageUrls?.first} ?? []
    var ownerTypes : [OwnerTypeCount] = [.init(type: .kind, count: 0),
                                          .init(type: .free, count: 0),
                                          .init(type: .cute, count: 0),
                                          .init(type: .business, count: 0),
                                          .init(type: .bad, count: 0)]
    var reviewInfos : [ReviewDetailInfo] = []
    for review in reviews ?? [] {
      if let idx = ownerTypes.firstIndex(where: {$0.type == review.communcationTendency?.validateType}) {
        ownerTypes[idx].count += 1
      }
      let reviewInfo = ReviewDetailInfo(reviewrName: "리뷰어",
                                        detailAddress: review.address ?? "",
                                        ownerReview: review.review ?? "",
                                        ownerEstimateAge: review.lessorAge ?? "",
                       houseReview: "방음 \(review.soundInsulation) 해충 \(review.pest) 채광 \(review.lightning) 수압 \(review.waterPressure)",
                       totalReview: review.totalEvaluation ?? "",
                       createdAt: "")
      reviewInfos.append(reviewInfo)
    }
    return .init(buildingId: id ?? -1,
                 buildingName: apartmentName ?? "",
                 buildingImages: images,
                 buildingAddress: fullNumberAddress ?? "",
                 buildingType: self.buildingType?.tagTypes.rawValue ?? "",
                 contractType: dealTypes,
                 options: [],
                 ownerInfo: ownerTypes,
                 review: reviewInfos,
                 filters: [])
  }
  func toModel() -> BuildingModel {
    let firstImg = self.reviews?.flatMap{$0.imageUrls}.first
    let ownerType = self.reviews?.flatMap{$0.communcationTendency}.map{ String($0).validateType
    }.first ?? .unknown
    var tagTypes : TagType {
      buildingType?.tagTypes ?? .unknown
    }
    var tags : [String] = []
    tags.append(tagTypes.rawValue)
//    if let floors = self.buildingDeals?.map{$0.floor!}.sorted().map{"\($0)층"} {    tags.append(contentsOf: floors)
//    }
//    if let dealTypes = self.buildingDeals?.map{ deal -> String in
//      deal.dealType?.dealTypes ?? ""
//    } {
//      tags.append(contentsOf:dealTypes)
//    }
    let review = self.reviews?.flatMap{ ReviewInfo.init(reviewrName: $0.user.name ?? "", review: $0.review ?? "")}.first ?? .init(reviewrName: "", review: "아직 작성된 리뷰가 없어요")
    return .init(buildingId: id!,buildingName: apartmentName ?? "", buildingImage: firstImg?.first, ownderInfo: ownerType, review: review, filters: tags)
  }
}
