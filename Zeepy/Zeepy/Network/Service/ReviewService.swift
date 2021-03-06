//
//  ReviewService.swift
//  Zeepy
//
//  Created by κΉνν on 2021/08/01.
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
  func addReview(param: ReviewModel) -> Observable<Bool> {
    provider.rx.request(.addReview(param: param))
      .retryWithAuthIfNeeded()
      .successFlag()
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
  func fetchReviewDetail(id: Int) -> Observable<ReviewResponses> {
    provider.rx.request(.fetchReviewDetail(review: id))
      .retryWithAuthIfNeeded()
      .filterError()
      .map(ReviewResponses.self)
  }
  func getUserReviews() -> Observable<Response> {
    provider.rx.request(.getUserReviews)
      .asObservable()
  }
}
