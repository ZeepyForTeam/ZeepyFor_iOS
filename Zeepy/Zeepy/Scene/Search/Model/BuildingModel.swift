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
  let ownderInfo: [ReviewDetailInfo]
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
