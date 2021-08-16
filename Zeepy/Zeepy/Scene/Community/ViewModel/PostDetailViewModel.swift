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
    let likePost : Observable<LikeRequest>
    let likeCancel : Observable<LikeRequest>
    let addComment: Observable<PostCommentRequest>
  }
  struct Output {
    let communityInfo : Observable<CommunityContent>
    let commentUsecase : Observable<[CommentSectionType]>
    let likeResult: Observable<Bool>
    let likeCancelResult: Observable<Bool>
    let commentResult: Observable<Bool>
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
    }.share()
    let comments = usecase.map{
      $0.comments.map{$0.toCommentModel()}
    }.map{ comments in
      comments.map{ comment in
        CommentSectionType.init(model: comment, items: [])
      }
    }
    let likePost = input.likePost.flatMapLatest{ param in
      self?.service.addPostLike(param: param) ?? .empty()
    }.share()
    let likeCancel = input.likeCancel.flatMapLatest{ param in
      self?.service.deletePostLike(param: param) ?? .empty()
    }.share()
    let comment = Observable.combineLatest(input.loadView, input.addComment)
      .flatMapLatest{ id, param in
        self?.service.addComment(id: id, param: param) ?? .empty()
      }.share()
    return .init(
      communityInfo: usecase,
      commentUsecase: comments,
      likeResult: likePost,
      likeCancelResult: likeCancel,
      commentResult: comment)
  }
}
