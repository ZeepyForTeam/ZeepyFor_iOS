//
//  DealRequest.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/31.
//

import Foundation
// MARK: - BuildingDealRequest
struct BuildingDealRequest: Codable {
    let buildingId, dealCost, dealDate, deposit: Int?
    let floor, monthlyRent: Int?
}
struct DealFloorsRequest: Codable {
  let floor : Int
  let id: Int
}
