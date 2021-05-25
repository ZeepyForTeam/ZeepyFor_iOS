//
//  CommentSectionModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/23.
//

import Foundation
import RxSwift
import RxDataSources
struct CommentSectionModel : IdentifiableType {
  let identity : Int
  let profile : String
  let userName : String
  let comment: String
  var hidden : Bool
  let postedAt: String
}
extension CommentSectionModel : Equatable {
  static func == (lds : CommentSectionModel , rds: CommentSectionModel) -> Bool {
    return lds.identity == rds.identity
  }
  static var dummy : [CommentSectionModel] {
    return [.init(identity: 0, profile: "", userName: "서울쥐김자랑", comment: "ㅁㄴ이러ㅣㅁ나ㅓㅇㄹ", hidden: true, postedAt: "2021-04-23"),
            .init(identity: 1, profile: "", userName: "시골쥐 포메라", comment: "ㅁㄴ이러ㅣㅁ나ㅓㅇㄹ", hidden: true, postedAt: "2021-04-23"),
            .init(identity: 2, profile: "", userName: "시골쥐 포메라", comment: "ㅁㄴ이러ㅣㅁ나ㅓㅇㄹ", hidden: true, postedAt: "2021-04-23"),
            .init(identity: 3, profile: "", userName: "수미칩먹는중", comment: "ㅁㄴ이러ㅣㅁ나ㅓㅇㄹ", hidden: false, postedAt: "2021-04-23"),
            .init(identity: 4, profile: "", userName: "서울쥐김자랑", comment: "ㅁㄴ이러ㅣㅁ나ㅓㅇㄹ", hidden: true, postedAt: "2021-04-23"),
            .init(identity: 5, profile: "", userName: "수미칩먹는중", comment: "ㅁㄴ이러ㅣㅁ나ㅓㅇㄹ", hidden: true, postedAt: "2021-04-23")]
  }
}
