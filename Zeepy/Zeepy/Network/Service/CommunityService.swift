//
//  CommunityService.swift
//  Zeepy
//
//  Created by κΉνν on 2021/08/01.
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
  func fetchPostList(param: CommunityRequest) -> Observable<[CommunityContent]> {
    provider.rx.request(.fetchPostList(param : param))
      .retryWithAuthIfNeeded()
      .filterError()
      .asObservable()
      .map([CommunityContent].self,atKeyPath: "content")
    
  }
  func fetchMyZip(param: PostType?) -> Observable<[MyZip]> {
    provider.rx.request(.fetchMyZip(param: param))
      .retryWithAuthIfNeeded()
      .filterError()
      .asObservable()
      .map([MyZip].self,atKeyPath: "myZip")
    
  }
  func addPostList(param: SaveCommunityRequest) -> Observable<Bool> {
    provider.rx.request(.addPostList(param : param))
      .successFlag()
      .asObservable()
  }
  func fetchPostDetail(id: Int) -> Observable<CommunityContent> {
    provider.rx.request(.fetchPostDetail(id : id))
      .filterError()
      .asObservable()
      .map(CommunityContent.self)
  }
  func modifyPostDetail(id: Int) -> Observable<Bool> {
    provider.rx.request(.modifyPostDetail(id: id))
      .successFlag()
      .asObservable()
  }
  func addComment(id: Int , param: PostCommentRequest) -> Observable<Bool> {
    provider.rx.request(.addComment(id: id, param : param))
      .successFlag()
      .asObservable()
  }
  func fetchPostLike(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchPostLike(id : id))
      .asObservable()
  }
  func addPostLike(param: LikeRequest) -> Observable<Bool> {
    provider.rx.request(.addPostLike(param : param))
      .successFlag()
      .asObservable()
  }
  func deletePostLike(param: LikeRequest) -> Observable<Bool> {
    provider.rx.request(.deletePostLike(param : param))
      .successFlag()
      .asObservable()
  }
  func fetchParticipation(id:Int) -> Observable<CommunityParticipation> {
    provider.rx.request(.fetchParticipation(id : id))
      .filterError()
      .asObservable()
      .map(CommunityParticipation.self)
  }
  func addParticipation(id:Int, param : JoinRequset) -> Observable<Bool> {
    provider.rx.request(.addParticipation(id : id, param : param))
      .successFlag()
      .asObservable()
  }
  func modifyParticipation(id:Int) -> Observable<Bool> {
    provider.rx.request(.modifyParticipation(id: id))
      .successFlag()
      .asObservable()
  }
}
