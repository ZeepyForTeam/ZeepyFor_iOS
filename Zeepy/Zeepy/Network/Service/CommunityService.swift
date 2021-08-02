//
//  CommunityService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/01.
//

import Foundation
import Moya
import RxSwift
class CommunityService {
  private let provider: MoyaProvider<CommunityRouter>
  init(provider: MoyaProvider<CommunityRouter>) {
    self.provider = provider
  }
}
extension CommunityService {
  func fetchPostList(param: CommunityRequest) -> Observable<Response> {
    provider.rx.request(.fetchPostList(param : param))
      .asObservable()
  }
  func addPostList(param: SaveCommunityRequest) -> Observable<Response> {
    provider.rx.request(.addPostList(param : param))
      .asObservable()
  }
  func fetchPostDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchPostDetail(id : id))
      .asObservable()
  }
  func modifyPostDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.modifyPostDetail(id: id))
      .asObservable()
  }
  func addComment(id: Int , param: PostCommentRequest) -> Observable<Response> {
    provider.rx.request(.addComment(id: id, param : param))
      .asObservable()
  }
  func fetchPostLike(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchPostLike(id : id))
      .asObservable()
  }
  func addPostLike(param: LikeRequest) -> Observable<Response> {
    provider.rx.request(.addPostLike(param : param))
      .asObservable()
  }
  func deletePostLike(param: LikeRequest) -> Observable<Response> {
    provider.rx.request(.deletePostLike(param : param))
      .asObservable()
  }
  func fetchParticipation(id:Int) -> Observable<Response> {
    provider.rx.request(.fetchParticipation(id : id))
      .asObservable()
  }
  func addParticipation(id:Int, param : JoinRequset) -> Observable<Response> {
    provider.rx.request(.addParticipation(id : id, param : param))
      .asObservable()
  }
  func modifyParticipation(id:Int, cancelUserId: Int) -> Observable<Response> {
    provider.rx.request(.modifyParticipation(id: id, cancelUserId: cancelUserId))
      .asObservable()
  }
}
