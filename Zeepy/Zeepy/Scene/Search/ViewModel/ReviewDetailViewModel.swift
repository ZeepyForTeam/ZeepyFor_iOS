//
//  ReviewDetailViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/26.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
class ReviewDetailViewModel : Services, ViewModelType {
  struct Input {
    let loadView: Observable<Int>
  }
  
  struct Output {
    let reviewInfo : Observable<ReviewResponses>
  }
  
  func transform(input: Input) -> Output {
    weak var `self` = self
    let result = input.loadView.flatMapLatest{ id in
      self?.reviewService.fetchReviewDetail(id: id) ?? .empty()
    }
    return .init(reviewInfo: result)
  }
  
  
}
