//
//  UserResponse.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/11.
//

import Foundation

struct ResponseGetAddress: Codable {
  var addresses: [Addresses]
}

struct ResponseFetchNickname: Codable {
  var nickname: String
}

struct ResponseFetchEmail: Codable {
  var sendMailCheck: Bool
}
 
