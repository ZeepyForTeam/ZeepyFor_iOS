//
//  HomeViewModel.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/04.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class HomeViewModel {
  struct Input {
    let writeReview: Observable<Void>
  }
  struct Output {
    let writeVC : Observable<SelectAddressViewController>

  }
}
extension HomeViewModel {
  func transform(inputs: Input) -> Output {
    let reviewVC = inputs.writeReview.map{ _ in
      SelectAddressViewController()
    }
    return .init(writeVC: reviewVC)
  }
}
