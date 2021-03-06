//
//  AuthRequest.swift
//  Zeepy
//
//  Created by κΉνν on 2021/08/05.
//

import Foundation
struct AuthRequest: Encodable {
  let email: String
  let password: String
}
struct RefreshRequest : Encodable {
  let accessToken : String
  let refreshToke : String
}
struct RegisterRequset: Encodable, Equatable {
  let email: String
  let name: String
  let password: String
  let nickname: String
  let sendMailCheck: Bool
}
struct AppleLoginParam: Encodable {
  let code: String
  let id_token: String
  let state: String?
  let user: String
}
