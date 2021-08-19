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
  }
  struct Output {
    let images : Observable<[String]>
    let buildingDetailUsecase: Observable<BuildingDetailInfo>
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
    
    return .init(images: imageUsecase,
                 buildingDetailUsecase: building)
  }
}
