//
//  UserResponse.swift
//  Zeepy
//
//  Created by λΈνμ on 2021/08/11.
//

import Foundation

struct ResponseGetAddress: Codable {
  var addresses: [Addresses]
}

struct ResponseFetchNickname: Codable {
  var nickname: String
  var email: String
}

struct ResponseFetchEmail: Codable {
  var sendMailCheck: Bool
}
 
