//
//  BuildingRequest.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation

struct BuildingRequest: Encodable {
  let eqRoomCount: String? //원룸 투룸 Type 물어보기
  let geDeposit: Int?
  let geMonthly: Int?
  let inFurnitures: [String]?
  let leDeposit: Int?
  let leMonthly: Int?
  let neType: String? // 거래종류
  let offset: Int?
  let pageNumber: Int?
  let pageSize: Int?
  let paged: Bool?
  let unpaged: Bool?
  init(eqRoomCount: String? = nil, geDeposit: Int? = nil, geMonthly: Int? = nil, inFurnitures: [String]? = nil, leDeposit: Int? = nil, leMonthly: Int? = nil, neType: String? = nil, offset: Int? = nil, pageNumber: Int? = nil, pageSize: Int? = nil, paged: Bool? = nil, unpaged:  Bool? = nil) {
    self.eqRoomCount = eqRoomCount
    self.geDeposit = geDeposit
    self.geMonthly = geMonthly
    self.inFurnitures = inFurnitures
    self.leDeposit = leDeposit
    self.leMonthly = leMonthly
    self.neType = neType
    self.offset = offset
    self.pageNumber = pageNumber
    self.pageSize = pageSize
    self.paged = paged
    self.unpaged = unpaged
  }
}


struct UplaodBuildingRequest: Codable {
    let address, apartmentName: String
    let areaCode, buildYear, exclusivePrivateArea, latitude: Int
    let longitude: Int
    let shortAddress: String
}
struct ModiftyBuildingRequest: Encodable {
    let address, apartmentName: String
    let areaCode, buildYear, exclusivePrivateArea, latitude: Int
    let longitude: Int
    let shortAddress: String
}
struct LocationModel: Encodable {
  let latitudeGreater : Double
  let latitudeLess : Double
  let longitudeGreater : Double
  let longitudeLess : Double

}

struct BuildingLikeRequset: Codable {
    let buildingId, likeDate, user: Int?
}
