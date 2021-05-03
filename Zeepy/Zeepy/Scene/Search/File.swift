//
//  File.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/19.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
class LookAroundViewModel {
  struct Input {
    
    let loadTrigger: Observable<Void>
    let filterAction: Observable<Void>
    let mapSelectAction: Observable<Void>
    let buildingSelect: Observable<(IndexPath, BuildingModel)>
  }
  struct Output {
    let buildingUsecase: Observable<[BuildingModel]>
  }
}
extension LookAroundViewModel {
  func transForm(inputs: Input) -> Output {
    weak var weakSelf = self
    let buildingDummy = BuildingModel(buildingName: "더미",
                                      buildingImage: "image/1",
                                      ownderInfo: OwnerInfo(ownerStatusImage: "", ownerStatusLabel: "비지니스형"), review: ReviewInfo(reviewrName: "서울쥐김자랑", review: "여기서살고싶어여기서살고싶어"), filters: ["발리", "투룸투룸투룸","2층"])
    let buildingUsecase = Observable.just([buildingDummy,buildingDummy,buildingDummy,buildingDummy,buildingDummy])
    return .init(buildingUsecase: buildingUsecase)
  }
}
