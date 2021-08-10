//
//  ConditionModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/04.
//

import Foundation
struct ConditionModel {
  let eqRoomCount: String? //원룸 투룸
  let geDeposit: Int?
  let geMonthly: Int?
  let leDeposit: Int?
  let leMonthly: Int?
  let inFurnitures: [String]?
  let neType: NeType
}
enum NeType : String {
  case monthly = "MONTHLY"
}
