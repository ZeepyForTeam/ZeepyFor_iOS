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
  let ownderInfo: OwnerInfo
  let review : ReviewInfo
  let filters : [String]
}
struct OwnerInfo {
  let ownerStatusImage: String
  let ownerStatusLabel: String
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
