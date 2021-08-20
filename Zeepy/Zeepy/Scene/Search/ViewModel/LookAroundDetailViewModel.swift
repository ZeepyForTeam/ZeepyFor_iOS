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
    let likeResult: Observable<Bool>
  }
}
extension LookAroundDetailViewModel {
  func transForm(inputs: Input) -> Output {
    weak var weakSelf = self
    var filterOriginUsecase : [FilterModel] = []
    var buildingId: Int!
    let building = inputs.loadTrigger.flatMapLatest{ id -> Observable<BuildingContent> in
      buildingId = id
      return weakSelf?.service.fetchBuildingDetailMapped(id: id) ?? .empty()
    }.map{$0.toDetailModel()}
    let imageUsecase = building.map{$0.buildingImages}.share()
    let likeResult = inputs.likeTrigger.flatMapLatest{ current -> Observable<Bool> in
      if current {
        return weakSelf?.service.deleteLikeBuilding(id: buildingId) ?? .empty()
      }
      else {
        return weakSelf?.service.addLikeBuilding(param: .init(buildingId: buildingId)) ?? .empty()
      }
    }
    return .init(images: imageUsecase,
                 buildingDetailUsecase: building,
                 likeResult: likeResult)
  }
}
