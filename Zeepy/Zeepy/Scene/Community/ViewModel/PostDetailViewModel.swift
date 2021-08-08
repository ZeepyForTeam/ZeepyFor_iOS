//
//  PostDetailViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya
class PostDetailViewModel  {
  private let service = CommunityService(provider: MoyaProvider<CommunityRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let loadView : Observable<Int>
  }
  struct Output {
    let communityInfo : Observable<CommunityContent>
    let commentUsecase : Observable<[CommentSectionType]>
  }
}
extension PostDetailViewModel {
  func transform(input : Input) -> Output {
    weak var `self` = self
    let dummyUsecase = input.loadView.map{ _ in
      return [CommentSectionType.init(model: .init(identity: 7, profile: "", userName: "서울쥐김자랑", comment: "ㅁㄴ이럼ㄴㅇ리ㅏㅁㅇㄴㄹ", hidden: true, postedAt: ""), items: CommentSectionModel.dummy),
              CommentSectionType.init(model: .init(identity: 8, profile: "", userName: "수미칩먹는중", comment: "ㅁㄴ,ㅇ럼ㄴ알", hidden: false, postedAt: ""), items: CommentSectionModel.dummy),
              CommentSectionType.init(model: .init(identity: 9, profile: "", userName: "시골쥐 포메라", comment: "ㅁㄴ이ㅓㄹㅁㄴ", hidden: true, postedAt: ""), items: CommentSectionModel.dummy)]
    }
    let usecase = input.loadView.flatMapLatest{
      self?.service.fetchPostDetail(id: $0) ?? .empty()
    }
    let comments = usecase.map{
      $0.comments.map{$0.toCommentModel()}
    }.map{ comments in
      comments.map{ comment in
        CommentSectionType.init(model: comment, items: [])
      }
    }
    let postDetail = input.loadView.map{ _ in
      
    }
    return .init(
      communityInfo: usecase,
      commentUsecase: comments)
  }
}
