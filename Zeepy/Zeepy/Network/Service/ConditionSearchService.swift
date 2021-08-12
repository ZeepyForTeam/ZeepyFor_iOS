//
//  ConditionSearchService.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/08/11.
//

import Foundation
import Moya
import RxSwift

class ConditionSearchService {
  private let provider: MoyaProvider<ReviewRouter>
  init(provider: MoyaProvider<ReviewRouter>) {
    self.provider = provider
  }
}

extension ReviewService {
  func addReview(param: ReviewModel) -> Observable<Response> {
    provider.rx.request(.addReview(param: param))
      .asObservable()
  }
  func fetchReviewByAddress(address: String) -> Observable<Response> {
    provider.rx.request(.fetchReviewByAddress(address: address))
      .asObservable()
  }
  func deleteReview(id: Int) -> Observable<Response> {
    provider.rx.request(.deleteReview(id: id))
      .asObservable()
  }
}
