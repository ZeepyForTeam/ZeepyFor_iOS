//
//  File.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/17.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
class LookAroundDetailViewModel {
  struct Input {
    let loadTrigger: Observable<Void>
  }
  struct Output {
    let images : Driver<[String]>
    let buildingDetailUsecase: Observable<BuildingDetailInfo>
    
  }
}
extension LookAroundDetailViewModel {
  func transForm(inputs: Input) -> Output {
    weak var weakSelf = self
    var filterOriginUsecase : [FilterModel] = []
    
    let buildingDummy = BuildingDetailInfo(buildingName: "aaaa", buildingImages: ["jfyhdgdtuky","ㅁㄴㅇㄹ","ㅁㄴㅇㄹ","ㅁㄴㅇㄹ","ㅁㄴㅇㄹ"], buildingAddress: "주소", buildingType: "타입", contractType: "월세", options: ["뭐시기","ㅋㅋㅁㅁㅁ","ㅇㅇㅇ"],
                                           ownerInfo: [.init(type: .business, count: 0),
                                                       .init(type: .kind, count: 2),
                                                       .init(type: .free, count: 0),
                                                       .init(type: .cute, count: 3),
                                                       .init(type: .bad, count: 2)], review: [], filters: ["ff","ff"])
    let buildingUsecase = inputs.loadTrigger.map{buildingDummy}.share()
    let imageUsecase = inputs.loadTrigger.map{buildingDummy.buildingImages}.share()
    
    return .init(images: imageUsecase.asDriver(onErrorDriveWith: .empty()),buildingDetailUsecase: buildingUsecase)
  }
}
