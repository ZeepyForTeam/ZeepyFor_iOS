//
//  BuildingRouter.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation
import Moya
enum BuildingRouter {
  case fetchBuildingList(param: BuildingRequest)
  case uploadBuilding(param: UplaodBuildingRequest)
  case fetchBuildingDetail(id: Int)
  case modifyBuilding(id: Int, param: ModiftyBuildingRequest)
  case deleteBuilding(id: Int)
  case searchByAddress(param:String)
  case searchByLocation(param: LocationModel)
  
  case fetchLikeBuildings
  case addLikeBuilding(param: LikeRequest)
  case fetchLikeBuildingDetail(id: Int)
  case modifyLikeBuilding(id: Int, param: LikeRequest)
  case deleteLikeBuilding(id: Int)
}

extension BuildingRouter : TargetType {
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {
    case .fetchBuildingList(param: let param):
      return "/buildings"
    case .uploadBuilding(param: let param):
      return "/buildings"
    case .fetchBuildingDetail(id: let id):
      return "/buildings/\(id)"
    case .modifyBuilding(id: let id, param: let param):
      return "/buildings/\(id)"
    case .deleteBuilding(id: let id):
      return "/buildings/\(id)"
    case .searchByAddress(param: let param):
      return "/buildings/address"
    case .searchByLocation(param: let param):
      return "/buildings/location"
    case .fetchLikeBuildings:
      return "/likes/buildings"
    case .addLikeBuilding:
      return "/likes/buildings"
    case .fetchLikeBuildingDetail(id: let id):
      return "/likes/buildings/\(id)"
    case .modifyLikeBuilding(id: let id, param: let param):
      return "/likes/buildings/\(id)"
    case .deleteLikeBuilding(id: let id):
      return "/likes/buildings/\(id)"
    }
  }
  var method: Moya.Method {
    switch self {
    case .fetchBuildingList(param: _),
         .fetchLikeBuildings,
         .fetchLikeBuildingDetail:
      return .get
    case .uploadBuilding(param: _),
         .addLikeBuilding:
      return .post
    case .fetchBuildingDetail(id: _):
      return .get
    case .modifyBuilding,
         .modifyLikeBuilding:
      return .put
    case .deleteBuilding(id: _),
         .deleteLikeBuilding(id: _):
      return .delete
    case .searchByAddress(param: _):
      return .get
    case .searchByLocation(param: _):
      return .get
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {
    case .fetchBuildingList(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.default)
    case .uploadBuilding(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .fetchBuildingDetail(id: let id):
      return .requestPlain
    case .modifyBuilding(id: let id, param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .deleteBuilding(id: let id):
      return .requestPlain
    case .searchByAddress(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.default)
    case .searchByLocation(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.default)
    case .fetchLikeBuildings:
      return .requestPlain
    case .addLikeBuilding(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.default)
    case .fetchLikeBuildingDetail(id: let id):
      return .requestPlain
    case .modifyLikeBuilding(id: let id, param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: URLEncoding.default)
    case .deleteLikeBuilding(id: let id):
      return .requestPlain
    }
  }
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "X-AUTH-TOKEN" : UserDefaultHandler.accessToken!]
    }
  }
}
