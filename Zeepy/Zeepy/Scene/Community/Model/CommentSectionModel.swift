//
//  CommentSectionModel.swift
//  Zeepy
//
//  Created by κΉνν on 2021/05/23.
//

import Foundation
import RxSwift
import RxDataSources
struct CommentSectionModel : IdentifiableType {
  var postUser: Int
  let identity : Int
  let profile : String
  let userName : String
  let userId: Int
  let comment: String
  var hidden : Bool
  let postedAt: String
  let isMember: Bool
}
extension CommentSectionModel : Equatable {
  static func == (lds : CommentSectionModel , rds: CommentSectionModel) -> Bool {
    return lds.identity == rds.identity
  }
}
