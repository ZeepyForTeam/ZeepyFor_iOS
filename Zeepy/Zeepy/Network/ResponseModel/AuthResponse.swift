//
//  AuthResponse.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/05.
//

import Foundation
struct AuthResponse : Decodable {
  let accessToken : String
  let refreshToken : String
  let userId: Int
}
