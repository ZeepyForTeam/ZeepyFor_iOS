//
//  UserRequest.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/11.
//

import Foundation

// MARK: - RequestAddAddress
struct RequestAddAddress: Codable {
  let addresses: [Addresses]
}

// MARK: - Addresses
struct Addresses: Codable, Equatable {
  var cityDistinct, primaryAddress: String
  var isAddressCheck: Bool
}
extension Addresses{
  static func == (lds : Addresses , rds: Addresses) -> Bool {
    return lds.primaryAddress == rds.primaryAddress
  }
}
struct RequestModifyPassword: Encodable {
  var password: String
}

struct RequestRegistration: Encodable {
  let email: String
  let name: String
  let password: String
}

// MARK: - RequestReportModel
struct RequestReportModel: Codable {
    var requestReportModelDescription: String
    var reportID: Int
    var reportType: String
    var reportUser: Int
    var targetTableType: String
    var targetUser: Int

    enum CodingKeys: String, CodingKey {
        case requestReportModelDescription = "description"
        case reportID = "reportId"
        case reportType, reportUser, targetTableType, targetUser
    }
}
