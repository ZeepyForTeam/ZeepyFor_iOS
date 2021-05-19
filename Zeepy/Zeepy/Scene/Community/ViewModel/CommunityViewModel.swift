//
//  CommunityViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/18.
//

import Foundation
import RxSwift
class CommunityViewModel {
  struct Input {
    let loadView : Observable<Void>
    let filterSelect: Observable<(IndexPath, (PostType, Bool))>
  }
  struct Output {
    let postUsecase : Observable<[PostModel]>
    let filterUsecase : Observable<[(PostType, Bool)]>
  }
  
  var filterList = [(PostType.total, true),
                    (PostType.deal, false),
                    (PostType.share, false),
                    (PostType.friend, false)]
  private var postList : [PostModel] = [PostModel(type: PostType.deal, status: true, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                        PostModel(type: PostType.deal, status: false, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                        PostModel(type: PostType.share, status: true, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                      PostModel(type: PostType.friend, status: true, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                  
                                        PostModel(type: PostType.deal, status: true, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                        PostModel(type: PostType.share, status: true, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                        PostModel(type: PostType.share, status:true, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23"),
                                        PostModel(type: PostType.friend, status:false, postTitle: "타이틀", postConent: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㄴㅇㄹ", postedAt: "2021-04-23")]
}
extension CommunityViewModel {
  func transform(input: Input) -> Output {
    weak var weakSelf = self
    let postUsecase = input.loadView
      .flatMapLatest{ _ -> Observable<[PostModel]> in
        return weakSelf?.modifyPost(tapAction: input.filterSelect, origin: self.postList.sorted(by: {$0 > $1})
) ?? .empty()
      }
    let filterUsecase = input.loadView
      .flatMapLatest{ _ -> Observable<[(PostType, Bool)]> in
        return weakSelf?.modifyFilter(tapAction: input.filterSelect, origin: self.filterList) ?? .empty()
      }
    return .init(postUsecase: postUsecase,
                 filterUsecase: filterUsecase)
  }
  func modifyPost(
    tapAction: Observable<(IndexPath, (PostType, Bool))>,
    origin: [PostModel]) -> Observable<[PostModel]> {
    enum Action {
      case tapAction(indexPath : IndexPath, model: (PostType, Bool))
    }
    
    return tapAction
      .map(Action.tapAction)
      .scan(into: origin) { state, action in
        switch action {
        case let .tapAction(model):
          if model.indexPath.row == 0{
            state = origin
          }
          else {
            state = origin.filter{$0.type == model.model.0}
          }
        }
      }
      .startWith(origin)
  }
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
            if i == model.0.row {
              state[model.0.row].1.toggle()
            }
            state[i].1 = false
          }
        }
      }
      .startWith(origin)
  }
}
