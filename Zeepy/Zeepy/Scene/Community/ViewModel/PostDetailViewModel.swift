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
    let joinAction: Observable<JoinRequset>
    let cancleJoin : Observable<Int>
  }
  struct Output {
    let communityInfo : Observable<CommunityContent>
    let commentUsecase : Observable<[CommentSectionType]>
    let likeResult: Observable<Bool>
    let likeCancelResult: Observable<Bool>
    let commentResult: Observable<Bool>
    let joinResult: Observable<Bool>
    let cancleResult : Observable<Bool>
  }
}
extension PostDetailViewModel {
  func transform(input : Input) -> Output {
    weak var `self` = self
    var postId: Int = 0

    let usecase = input.loadView.flatMapLatest{ id -> Observable<CommunityContent> in
      postId = id
      return self?.service.fetchPostDetail(id: id) ?? .empty()
    }.share()
    let comments = usecase.map{$0.comments ?? []}.map{
      $0.map{($0.toCommentModel(), $0.subComments ?? [])}
        .map{comment, subComment in
          CommentSectionType.init(model: comment, items: subComment.map{$0.toCommentModel()})
        }
    }
//    .map{ comments in
//      comments.map{ comment in
//        CommentSectionType.init(model: comment, items: [])
//      }
//    }
    let likePost = input.likePost.flatMapLatest{ param in
      self?.service.addPostLike(param: param) ?? .empty()
    }.share()
    let likeCancel = input.likeCancel.flatMapLatest{ param in
      self?.service.deletePostLike(param: param) ?? .empty()
    }.share()
    let comment = input.addComment
      .flatMapLatest{  param in
        self?.service.addComment(id: postId ?? 0, param: param) ?? .empty()
      }.share()
    let join = input.joinAction
      .flatMapLatest{ param in
        self?.service.addParticipation(id: postId ?? 0, param: param) ?? .empty()
      }
    let cancel = input.cancleJoin
      .flatMapLatest{ id in
        self?.service.modifyParticipation(id: id) ?? .empty()
      }
    return .init(
      communityInfo: usecase,
      commentUsecase: comments,
      likeResult: likePost,
      likeCancelResult: likeCancel,
      commentResult: comment, joinResult: join,
      cancleResult: cancel)
  }
}
