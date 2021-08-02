//
//  UserManager.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/02.
//

import Foundation
import UIKit
class UserManager: NSObject {
  static let shared = UserManager()
  var userId: Int? = nil
  var userName: String? = nil
  var userAddress: String? = nil
  override private init() { }
  
  func saveUserInfo(id : Int, name: String, address: String?) {
    self.userId = id
    self.userName = name
    self.userAddress = address
  }
}
