//
//  BuildingRequest.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/28.
//

import Foundation

struct BuildingRequest: Encodable {
  var eqCommunicationTendency: String?
  var eqLightning: String?
  var eqPest: String?
  var eqSoundInsulation: String?
  var eqWaterPressure: String?
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
  var shortAddress: String?
  init(eqCommunicationTendency: String? = nil, eqLightning: String? = nil,eqPest: String? = nil ,eqSoundInsulation: String? = nil,eqWaterPressure: String? = nil, eqRoomCount: String? = nil, geDeposit: Int? = nil, geMonthly: Int? = nil, inFurnitures: [String]? = nil, leDeposit: Int? = nil, leMonthly: Int? = nil, neType: String? = nil, offset: Int? = nil, pageNumber: Int? = nil, pageSize: Int? = nil, paged: Bool? = nil, unpaged:  Bool? = nil, shortAddress: String? = nil) {
    self.eqCommunicationTendency = eqCommunicationTendency
    self.eqLightning = eqLightning
    self.eqPest = eqPest
    self.eqSoundInsulation = eqSoundInsulation
    self.eqWaterPressure = eqWaterPressure
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
    self.shortAddress = shortAddress
  }
}

struct UplaodBuildingRequest: Codable {
    let address, apartmentName: String
    let areaCode, buildYear, exclusivePrivateArea : Int
    let latitude, longitude: Double
    let shortAddress: String
}
struct ModiftyBuildingRequest: Encodable {
    let address, apartmentName: String
    let areaCode, buildYear, exclusivePrivateArea: Int
    let longitude, latitude: Double
    let shortAddress: String
}
struct LocationModel: Encodable {
  let latitudeGreater : Double
  let latitudeLess : Double
  let longitudeGreater : Double
  let longitudeLess : Double
}

struct BuildingLikeRequset: Codable {
    let buildingId: Int
}
