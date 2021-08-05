//
//  BuildingService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation
import Moya
import RxSwift
class BuildingService {
  private let provider: MoyaProvider<BuildingRouter>
  init(provider: MoyaProvider<BuildingRouter>) {
    self.provider = provider
  }
}
extension BuildingService {
  func fetchBuildingList(param: BuildingRequest) -> Observable<BuildingResponseModel> {
    provider.rx.request(.fetchBuildingList(param: param))
      .filterError()
      .asObservable()
      .map(BuildingResponseModel.self)
  }
  //클라이언트에서 안씀
  func uploadBuilding(param: UplaodBuildingRequest) -> Observable<Response> {
    provider.rx.request(.uploadBuilding(param: param))
      .asObservable()
  }
  func fetchBuildingDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchBuildingDetail(id: id))
      .asObservable()
  }
  func modifyBuilding(id: Int, param: ModiftyBuildingRequest) -> Observable<Response> {
    provider.rx.request(.modifyBuilding(id: id, param: param))
      .asObservable()
  }
  func deleteBuilding(id: Int) -> Observable<Response> {
    provider.rx.request(.deleteBuilding(id: id))
      .asObservable()
  }
  func searchByAddress(param:String) -> Observable<Response> {
    provider.rx.request(.searchByAddress(param: param))
      .asObservable()
  }
  func searchByLocation(param: LocationModel) -> Observable<Response> {
    provider.rx.request(.searchByLocation(param: param))
      .asObservable()
  }
  func fetchLikeBuildings() -> Observable<Response> {
    provider.rx.request(.fetchLikeBuildings)
      .asObservable()
  }
  func addLikeBuilding(param: LikeRequest) -> Observable<Response> {
    provider.rx.request(.addLikeBuilding(param: param))
      .asObservable()
  }
  func fetchLikeBuildingDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchLikeBuildingDetail(id: id))
      .asObservable()
  }
  func modifyLikeBuilding(id: Int, param: LikeRequest) -> Observable<Response> {
    provider.rx.request(.modifyLikeBuilding(id: id, param: param))
      .asObservable()
  }
  func deleteLikeBuilding(id: Int) -> Observable<Response> {
    provider.rx.request(.deleteLikeBuilding(id: id))
      .asObservable()
  }
}
