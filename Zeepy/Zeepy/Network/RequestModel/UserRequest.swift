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
  let bcryptEncoding: String
  let password: String
}

struct RequestRegistration: Encodable {
  let email: String
  let name: String
  let password: String
}
