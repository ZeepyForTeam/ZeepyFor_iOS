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
  func fetchBuildingList(param: BuildingRequest) -> Observable<[BuildingContent]> {
    provider.rx.request(.fetchBuildingList(param: param))
      .retryWithAuthIfNeeded()
      .filterError()
      .asObservable()
      .map([BuildingContent].self, atKeyPath: "content")
  }
    
  //클라이언트에서 안씀
  func uploadBuilding(param: UplaodBuildingRequest) -> Observable<Response> {
    provider.rx.request(.uploadBuilding(param: param))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func fetchBuildingDetailMapped(id: Int) -> Observable<BuildingContent> {
    provider.rx.request(.fetchBuildingDetail(id: id))
      .retryWithAuthIfNeeded()
      .filterError()
      .map(BuildingContent.self)
  }
  func fetchBuildingDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchBuildingDetail(id: id))
      .retryWithAuthIfNeeded()
      .asObservable()

  }
  func modifyBuilding(id: Int, param: ModiftyBuildingRequest) -> Observable<Response> {
    provider.rx.request(.modifyBuilding(id: id, param: param))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func deleteBuilding(id: Int) -> Observable<Response> {
    provider.rx.request(.deleteBuilding(id: id))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func searchByAddress(param:String) -> Observable<Response> {
    provider.rx.request(.searchByAddress(param: param))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func searchByLocation(param: LocationModel) -> Observable<Response> {
    provider.rx.request(.searchByLocation(param: param))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func fetchLikeBuildings() -> Observable<Response> {
    provider.rx.request(.fetchLikeBuildings)
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func addLikeBuilding(param: BuildingLikeRequset) -> Observable<Bool> {
    provider.rx.request(.addLikeBuilding(param: param))
      .retryWithAuthIfNeeded()
      .successFlag()
      .asObservable()

  }
  func fetchLikeBuildingDetail(id: Int) -> Observable<Response> {
    provider.rx.request(.fetchLikeBuildingDetail(id: id))
      .retryWithAuthIfNeeded()
      .asObservable()
  }

  func modifyLikeBuilding(id: Int) -> Observable<Bool> {
    provider.rx.request(.modifyLikeBuilding(id: id))
      .retryWithAuthIfNeeded()
      .successFlag()
      .asObservable()
    
  }
  func deleteLikeBuilding(id: Int) -> Observable<Bool> {
    provider.rx.request(.deleteLikeBuilding(id: id))
      .retryWithAuthIfNeeded()
      .successFlag()
      .asObservable()
    
  }

  func fetchAllBuildings() -> Observable<Response>{
    provider.rx.request(.fetchAllBuildings).asObservable()
  }

  func fetchBuildingByAddress(address:String) ->
  Observable<Response> {
    provider.rx.request(.fetchBuildingByAddress(address: address))
      .asObservable()
  }
  
  func fetchBuildingUserLike() -> Observable<Response> {
    provider.rx.request(.fetchBuildingUserLike)
      .asObservable()
  }
}
