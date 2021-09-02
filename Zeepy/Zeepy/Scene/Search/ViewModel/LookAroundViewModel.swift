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
    let mapSelectAction: Observable<Void>
    let conditionFilter: Observable<BuildingRequest?>
    let buildingSelect: Observable<(IndexPath, BuildingModel)>
    let filterSelect: Observable<FilterModel>
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
    
    let filterDummy = Observable.just([FilterModel(title: .total, selected: true),
                                       FilterModel(title: .business, selected: false),
                                       FilterModel(title: .free, selected: false),
                                       FilterModel(title: .kind, selected: false),
                                       FilterModel(title: .cute, selected: false),
                                       FilterModel(title: .bad, selected: false)])
    let bindTrigger = filterDummy.map{ model in
      filterOriginUsecase = model
    }
    let filterUsecase = bindTrigger.flatMapLatest{ _ -> Observable<[FilterModel]> in
      return weakSelf?.configureCurrentFilter(tapAction: inputs.filterSelect, origin: filterOriginUsecase) ?? .empty()
    }
    let buildingUsecase = Observable.combineLatest( inputs.loadTrigger,
                                                    inputs.conditionFilter,
                                                    filterUsecase)
      .flatMapLatest{(page, conditionmodel, filter) -> Observable<[BuildingContent]> in
        let currentType = filter.first(where: {$0.selected})?.title ?? .total
        if var model = conditionmodel {
          model.eqCommunicationTendency = currentType.request
          return weakSelf?.service.fetchBuildingList(param: model) ?? .empty()
        }
        else {
          return weakSelf?.service.fetchBuildingList(param: .init(eqCommunicationTendency : currentType.request ,pageNumber:page, pageSize: 20, paged: true)) ?? .empty()
        }
      }.map{$0.map{$0.toModel()}}
    return .init(
      buildingUsecase: buildingUsecase,
      buildingDetailParam: inputs.buildingSelect.map{$0.1},
      filterUsecase: filterUsecase
    )
  }
}
extension LookAroundViewModel {
  func configureCurrentFilter(
    tapAction: Observable<FilterModel>,
    origin: [FilterModel]) -> Observable<[FilterModel]> {
    enum Action {
      case tapAction( model:FilterModel)
    }
    
    return tapAction
      .map(Action.tapAction)
      .scan(into: origin) { state, action in
        switch action {
        case let .tapAction(model):
          guard let index = state.firstIndex(where: {$0.title == model.title}) else {
            return
          }
          for i in 0..<state.count {
            state[i].selected = false
          }
          state[index].selected.toggle()
        }
      }
      .startWith(origin)
  }
}
