//
//  ReviewService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/01.
//

import Foundation
import Moya
import RxSwift

class ReviewService {
  private let provider: MoyaProvider<ReviewRouter>
  init(provider: MoyaProvider<ReviewRouter>) {
    self.provider = provider
  }
}

extension ReviewService {
  func addReview(param: ReviewModel) -> Observable<Response> {
    provider.rx.request(.addReview(param: param))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func fetchReviewByAddress(address: String) -> Observable<Response> {
    provider.rx.request(.fetchReviewByAddress(address: address))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func deleteReview(id: Int) -> Observable<Response> {
    provider.rx.request(.deleteReview(id: id))
      .retryWithAuthIfNeeded()
      .asObservable()
  }
  func getUserReviews() -> Observable<Response> {
    provider.rx.request(.getUserReviews)
      .asObservable()
  }
}
