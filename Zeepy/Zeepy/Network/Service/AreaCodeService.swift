//
//  AreaCodeService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation
import RxSwift
import Moya

class AreaCodeService {
  private let provider: MoyaProvider<AreaCodeRouter>
  init(provider: MoyaProvider<AreaCodeRouter>) {
    self.provider = provider
  }
}
extension AreaCodeService {
  func postAreaCode(param: AreaCodeRequest) -> Observable<Response> {
    provider.rx.request(.uploadAreaCode(param: param))
      .asObservable()
  }
  func modifyAreaCode(id: Int, param : AreaCodeRequest) -> Observable<Response> {
    provider.rx.request(.updateAreaCode(id: id, param: param))
      .asObservable()
  }
  func deleteAreaCode(id: Int) -> Observable<Response> {
    provider.rx.request(.deleteAreaCode(id: id))
      .asObservable()
  }
  
}
