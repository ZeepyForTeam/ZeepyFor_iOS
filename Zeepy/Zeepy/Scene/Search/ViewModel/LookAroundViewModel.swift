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
    let ownerFilterAction : Observable<ValidateType?>
    let mapSelectAction: Observable<Void>
    let buildingSelect: Observable<(IndexPath, BuildingModel)>
    let filterSelect: Observable<(IndexPath, FilterModel)>
  }
  struct Output {
    let buildingUsecase: Observable<[BuildingModel]>
    let buildingDetailParam: Observable<BuildingModel>
    let filterUsecase: Observable<[FilterModel]>
    
  }
}
extension LookAroundViewModel {
  func transForm(inputs: Input) -> Output {
    weak var weakSelf = self
    var filterOriginUsecase : [FilterModel] = []

    let buildingDummy = BuildingModel(buildingName: "더미",
                                      buildingImage: "image/1",
                                      ownderInfo: .business, review: ReviewInfo(reviewrName: "서울쥐김자랑", review: "여기서살고싶어여기서살고싶어"), filters: ["발리", "투룸투룸투룸","2층"])
    let buildingUsecase = Observable.just([buildingDummy,buildingDummy,buildingDummy,buildingDummy,buildingDummy])

    let filterDummy = Observable.just([FilterModel(title: "전체", selected: true),
                                         FilterModel(title: "기본순", selected: false),
                                         FilterModel(title: "방음굿", selected: false),
                                         FilterModel(title: "해충 제로", selected: false),
                                         FilterModel(title: "채광 좋은", selected: false),
                                         FilterModel(title: "수압 완벽", selected: false)])
    let bindTrigger = filterDummy.map{ model in
      filterOriginUsecase = model
    }
    let filterUsecase = bindTrigger.flatMapLatest{ _ -> Observable<[FilterModel]> in
      return weakSelf?.configureCurrentFilter(tapAction: inputs.filterSelect, origin: filterOriginUsecase) ?? .empty()
    }
    return .init(buildingUsecase: buildingUsecase,
                 buildingDetailParam: inputs.buildingSelect.map{$0.1},
                 filterUsecase: filterUsecase)
  }
}
extension LookAroundViewModel {
  func configureCurrentFilter(
    tapAction: Observable<(IndexPath, FilterModel)>,
  origin: [FilterModel]) -> Observable<[FilterModel]> {
    enum Action {
      case tapAction(indexPath : IndexPath, model:FilterModel)
    }
    
    return tapAction
      .map(Action.tapAction)
      .scan(into: origin) { state, action in
        switch action {
        case let .tapAction(IndexPath, model):
          
          if state[IndexPath.row].title == model.title {
            for i in 0..<state.count {
              state[i].selected = false
            }
            state[IndexPath.row].selected.toggle()
          }
        }
      }
      .startWith(origin)
  }
}
