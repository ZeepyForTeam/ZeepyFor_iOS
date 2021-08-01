//
//  DealResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/31.
//

import Foundation
// MARK: - BuildingDealResponseElement
struct BuildingDealResponseElement: Codable {
    let dealCost: Int?
    let dealDate: DealDate?
    let dealType: String?
    let deposit, floor, id, monthlyRent: Int?
}

// MARK: - DealDate
struct DealDate: Codable {
    let date, day, hours, minutes: Int?
    let month, nanos, seconds, time: Int?
    let timezoneOffset, year: Int?
}

typealias BuildingDealResponse = [BuildingDealResponseElement]
