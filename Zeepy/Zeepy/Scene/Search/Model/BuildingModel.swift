//
//  BuildingModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/14.
//

import Foundation
struct BuildingModel {
  let buildingName: String
  let buildingImage: String
  let ownderInfo: ValidateType
  let review : ReviewInfo
  let filters : [String]
}
struct ReviewInfo {
  let reviewrName: String
  let review: String
}
struct BuildingDetailInfo {
  let buildingName: String
  let buildingImages: [String]
  let buildingAddress: String
  let buildingType: String
  let contractType: String
  let options: [String]
  let ownerInfo: [OwnerTypeCount]
  let review: [ReviewInfo]
  let filters : [String]
}
struct ReviewDetailInfo {
  let reviewrName: String
  let detailAddress: String
  let ownerReview: String
  let ownerEstimateAge: String
  let houseReview: String
  let totalReview: String
  let createdAt: String
}
struct OwnerTypeCount {
  let type: ValidateType
  let count : Int
}
enum ValidateType: String {
  case business = "비지니스형"
  case kind = "친절형"
  case free = "방목형"
  case cute = "츤데레형"
  case bad = "할많하않"
}
extension ValidateType {
  var image : String {
    switch self {
    case .business:
      return "emoji1"
    case .kind:
      return "emoji2"
    case .free:
      return "emoji3"
    case .cute:
      return "emoji4"
    case .bad:
      return "emoji5"
    }
  }
  var inEnglish: String {
    switch self {
    case .business:
      return "business"
    case .kind:
      return "Kind"
    case .free:
      return "Graze"
    case .cute:
      return "Softy"
    case .bad:
      return "Bad"
    }
  }
  var color: UIColor {
    switch self {
    case .business:
      return UIColor.rgb(255, 147, 123)
    case .kind:
      return UIColor.rgb(255, 224, 135)
    case .free:
      return UIColor.rgb(133, 240, 205)
    case .cute:
      return UIColor.rgb(137, 169, 255)
    case .bad:
      return UIColor.rgb(196, 196, 196)
    }
  }
}
