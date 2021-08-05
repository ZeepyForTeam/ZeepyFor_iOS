//
//  DealRouter.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/31.
//

import Foundation
import Moya
enum DealRouter {
  case fetchDealList
  case addBuildingDeal(param: BuildingDealRequest)
  case fetchDealDetail(id: Int)
  case modifyDeal(id:Int, param: BuildingDealRequest)
  case deleteDeal(id:Int)
  case fetchDealFloor(param: DealFloorsRequest)
}

extension DealRouter : TargetType {
  public var baseURL: URL {
    return URL(string: Environment.baseUrl)!
  }
  var path: String {
    switch self {
    
    case .fetchDealList:
      return "/deals"
    case .addBuildingDeal:
      return "/deals"

    case .fetchDealDetail(id: let id):
      return "/deals/\(id)"

    case .modifyDeal(id: let id,_):
      return "/deals/\(id)"

    case .deleteDeal(id: let id):
      return "/deals/\(id)"

    case .fetchDealFloor:
      return "/deals/floors"
    }
  }
  var method: Moya.Method {
    switch self {
    case .fetchDealList:
      return .get
    case .addBuildingDeal:
      return .post
    case .fetchDealDetail:
      return .get
    case .modifyDeal:
      return .put
    case .deleteDeal:
      return .delete
    case .fetchDealFloor:
      return .get
    }
  }
  var sampleData: Data {
    return Data()
  }
  var task: Task {
    switch self {
    case .fetchDealList:
      return .requestPlain
    case .addBuildingDeal(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding
                                  .default)
    case .fetchDealDetail:
      return .requestPlain
    case .modifyDeal(_, param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding
                                  .default)
    case .deleteDeal:
      return .requestPlain
    case .fetchDealFloor(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding
                                  .default)
    }
  }
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "accessToken" : UserDefaultHandler.accessToken!]
    }
  }
}
