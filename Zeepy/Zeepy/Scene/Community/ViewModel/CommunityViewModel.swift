//
//  CommunityViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/18.
//

import Foundation
import RxSwift
import Moya
class CommunityViewModel {
  private let service = CommunityService(provider: MoyaProvider<CommunityRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let loadView : Observable<Void>
    let filterSelect: Observable<(IndexPath, (PostType, Bool))>
    let filterSelect2: Observable<PostType> 
  }
  struct Output {
    let postUsecase : Observable<[PostModel]>
    let filterUsecase : Observable<[(PostType, Bool)]>
  }
  
  var filterList = [(PostType.total, true),
                    (PostType.deal, false),
                    (PostType.share, false),
                    (PostType.friend, false)]
}
extension CommunityViewModel {
  func transform(input: Input) -> Output {
    weak var weakSelf = self
    var postList : [PostModel] = []
    let postListObservable = input.filterSelect2.flatMapLatest{ type -> Observable<[PostModel]> in
      let response = weakSelf?.service.fetchPostList(param: .init(address: nil, communityType: type.requestEnum, offset: nil, pageNumber: nil, pageSize: nil, paged: nil))
        .map{
          $0.map{
              $0.toPostModel()
            }
        } ?? .empty()
      print("")
      return response
    }.share()
    let filterUsecase = input.loadView
      .flatMapLatest{ _ -> Observable<[(PostType, Bool)]> in
        return weakSelf?.modifyFilter(tapAction: input.filterSelect, origin: self.filterList) ?? .empty()
      }
    return .init(
      postUsecase: postListObservable,
      filterUsecase: filterUsecase)
  }
  //안써도되는게 확인되며눈삭제
//  func modifyPost(
//    tapAction: Observable<(IndexPath, (PostType, Bool))>,
//    origin: [PostModel]) -> Observable<[PostModel]> {
//    enum Action {
//      case tapAction(indexPath : IndexPath, model: (PostType, Bool))
//    }
//
//    return tapAction
//      .map(Action.tapAction)
//      .scan(into: origin) { state, action in
//        switch action {
//        case let .tapAction(model):
//          if model.indexPath.row == 0{
//            state = origin
//          }
//          else {
//            state = origin.filter{$0.type == model.model.0}
//          }
//        }
//      }
//      .startWith(origin)
//  }
  func modifyFilter(
    tapAction: Observable<(IndexPath, (PostType, Bool))>,
    origin: [(PostType, Bool)]) -> Observable< [(PostType, Bool)] > {
    enum Action {
      case tapAction(indexPath : IndexPath, model: (PostType, Bool))
    }
    
    return tapAction
      .map(Action.tapAction)
      .scan(into: origin) { state, action in
        switch action {
        case let .tapAction(model):
          for i in 0..<state.count {
            state[i].1 = false
          }
          state[model.0.row].1.toggle()
        }
      }
      .startWith(origin)
  }
}
