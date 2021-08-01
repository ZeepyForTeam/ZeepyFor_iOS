//
//  DealService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/31.
//

import Foundation
import Moya
import RxSwift
class DealService {
  private let provider: MoyaProvider<DealRouter>
  init(provider: MoyaProvider<DealRouter>) {
    self.provider = provider
  }
}
extension DealService {
  func fetchDealList() -> Observable<Response> {
    provider.rx.request(.fetchDealList)
      .asObservable()
  }
  func addBuildingDeal(param: BuildingDealRequest) -> Observable<Response> {
    provider.rx.request(.addBuildingDeal(param: param))
      .asObservable()
  }
  func fetchDealDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchDealDetail(id: id))
      .asObservable()
  }
  func modifyDeal(id:Int, param: BuildingDealRequest) -> Observable<Response> {
    provider.rx.request(.modifyDeal(id: id, param: param))
      .asObservable()
  }
  func deleteDeal(id:Int) -> Observable<Response> {
    provider.rx.request(.deleteDeal(id: id))
      .asObservable()
  }
  func fetchDealFloor(param: DealFloorsRequest) -> Observable<Response> {
    provider.rx.request(.fetchDealFloor(param: param))
      .asObservable()
  }
}
