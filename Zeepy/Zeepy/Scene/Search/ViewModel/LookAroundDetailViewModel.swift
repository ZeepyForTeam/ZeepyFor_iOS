//
//  File.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/17.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
class LookAroundDetailViewModel {
  private let service = BuildingService(provider: MoyaProvider<BuildingRouter>(plugins: [NetworkLoggerPlugin()]))
  struct Input {
    let loadTrigger: Observable<Int>
    let likeTrigger: Observable<Bool>
  }
  struct Output {
    let images : Observable<[String]>
    let buildingDetailUsecase: Observable<BuildingDetailInfo>
    let reviewUsecase: Observable<[ReviewResponses]>
    let likeResult: Observable<Bool>
    let furnitures: Observable<String>
  }
  struct State {
    var likeId: Int? = nil
  }
}
extension LookAroundDetailViewModel {
  func transForm(inputs: Input) -> Output {
    weak var weakSelf = self
    var state = State()
    var filterOriginUsecase : [FilterModel] = []
    var buildingId: Int!
    let response = inputs.loadTrigger.flatMapLatest{ id -> Observable<BuildingContent> in
      buildingId = id
      return weakSelf?.service.fetchBuildingDetailMapped(id: id) ?? .empty()
    }.share()
    let building = response.map{model -> BuildingDetailInfo in
      state.likeId = model.buildingLikes?.first(where: {$0.userId == UserDefaultHandler.userId})?.id
      return model.toDetailModel()}.share()
    let imageUsecase = building.map{$0.buildingImages}.share()
    let likeResult = inputs.likeTrigger.flatMapLatest{ current -> Observable<Bool> in
      if current {
        guard let id = state.likeId else {
          return .empty()
        }
        return weakSelf?.service.deleteLikeBuilding(id: id) ?? .empty()
      }
      else {
        return weakSelf?.service.addLikeBuilding(param: .init(buildingId: buildingId)) ?? .empty()
      }
    }.share()
    let reviewResponse = response.map{$0.reviews ?? []}.share()
    let furnitures = reviewResponse.map{review -> String in
      var temp : [String] = []
      for r in review {
        for f in r.furnitures ?? [] {
          if !temp.contains(f) {
            temp.append(f)
          }
        }
      }
      var str = ""
      for i in temp {
        str += "\(i.furnitures),"
      }
      return str
    }.share()
    return .init(images: imageUsecase,
                 buildingDetailUsecase: building,
                 reviewUsecase : reviewResponse,
                 likeResult: likeResult,
                 furnitures: furnitures)
  }
}
