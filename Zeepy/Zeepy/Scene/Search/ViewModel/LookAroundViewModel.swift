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

final class LookAroundViewModel: Services {
  private let service = BuildingService(provider: MoyaProvider<BuildingRouter>(plugins: [NetworkLoggerPlugin()]))
  struct Input {
    let loadTrigger: Observable<Int>
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

    
    let buildingUsecase = inputs.loadTrigger.flatMapLatest{ page in
      weakSelf?.service.fetchBuildingList(param: .init(pageNumber:page, pageSize: 20, paged: true)) ?? .empty()
    }.map{$0.map{$0.toModel()}}
  
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
                 filterUsecase: filterUsecase
                 )
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
