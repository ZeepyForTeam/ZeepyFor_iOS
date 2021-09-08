//
//  ViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/20.
//

import Foundation
import RxSwift
import Moya
protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}
class Services {
  public let userService = UserService(provider: MoyaProvider<UserRouter>(plugins:[NetworkLoggerPlugin()]))
  public let areaService = AreaCodeService(provider: MoyaProvider<AreaCodeRouter>(plugins:[NetworkLoggerPlugin()]))
  public let buildingService = BuildingService(provider: MoyaProvider<BuildingRouter>(plugins:[NetworkLoggerPlugin()]))
  public let communityService = CommunityService(provider: MoyaProvider<CommunityRouter>(plugins:[NetworkLoggerPlugin()]))
  public let reviewService = ReviewService(provider: MoyaProvider<ReviewRouter>(plugins:[NetworkLoggerPlugin()]))
  public let s3Service = S3Service(provider: MoyaProvider<S3Router>(plugins:[NetworkLoggerPlugin()]))
}
