//
//  CommunityViewModel.swift
//  Zeepy
//
//  Created by κΉνν on 2021/05/18.
//

import Foundation
import RxSwift
import Moya
class CommunityViewModel : Services, ViewModelType{
  private let service = CommunityService(provider: MoyaProvider<CommunityRouter>(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let currentTab: Observable<Int>
    let loadView : Observable<Void>
    let filterSelect2: Observable<PostType>
    let resetAddress : Observable<[Addresses]>
    let pageNumber: Observable<Int?>

  }
  struct Output {
    let postUsecase : Observable<[PostModel]>
    let myZip: Observable<[PostModel]>
    let filterUsecase : Observable<[(PostType, Bool)]>
    let resetAddress: Observable<Bool>
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
    let currentAddress = UserManager.shared.currentAddress?.cityDistinct
    let resetAddressResult = input.resetAddress.flatMapLatest{ address in
      weakSelf?.userService.addAddress(param: .init(addresses: address)) ?? .empty()
    }
    let postListObservable = Observable.combineLatest(input.currentTab,
                                                      input.filterSelect2,
                                                      input.pageNumber)
      .flatMapLatest{ tab, type, page -> Observable<[PostModel]> in
      if tab == 0 {
        let response = weakSelf?.service.fetchPostList(param: .init(address: currentAddress, communityType: type.requestEnum, offset: nil, pageNumber: page, pageSize: nil, paged: nil))
        .map{
          $0.map{
              $0.toPostModel()
            }
        } ?? .empty()
      return response
      }
      else {
        let response = weakSelf?.service.fetchMyZip(param: nil).map{
          $0.map{
              $0.toPostModel()
            }
        } ?? .empty()
        return response
      }
    }.share()
    let myZip = input.loadView.flatMapLatest{ _ in
      weakSelf?.service.fetchMyZip(param: nil) ?? .empty()
    }.map{$0.map{$0.toPostModel()}}
    let filterUsecase = input.loadView
      .flatMapLatest{ _ -> Observable<[(PostType, Bool)]> in
        return weakSelf?.modifyFilter(tapAction: input.filterSelect2, origin: self.filterList) ?? .empty()
      }
    return .init(
      postUsecase: postListObservable,
      myZip: myZip,
      filterUsecase: filterUsecase,
      resetAddress: resetAddressResult)
  }
  //μμ¨λλλκ² νμΈλλ©°λμ­μ 
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
    tapAction: Observable<PostType>,
    origin: [(PostType, Bool)]) -> Observable< [(PostType, Bool)] > {
    enum Action {
      case tapAction(model: PostType)
    }
    
    return tapAction
      .map(Action.tapAction)
      .scan(into: origin) { state, action in
        switch action {
        case let .tapAction(model):
          for i in 0..<state.count {
            state[i].1 = false
          }
          guard let firstIndex = state.firstIndex(where: {$0.0 == model}) else {return}
          state[firstIndex].1.toggle()
        }
      }
      .startWith(origin)
  }
}
