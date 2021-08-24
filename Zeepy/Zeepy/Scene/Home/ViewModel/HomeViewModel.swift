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

class HomeViewModel : Services{
  struct Input {
    let resetAddress: Observable<[Addresses]>
    let writeReview: Observable<Void>
  }
  struct Output {
    let resetResult : Observable<Bool>
    let writeVC : Observable<SelectAddressViewController>

  }
}
extension HomeViewModel {
  func transform(inputs: Input) -> Output {
    weak var `self` = self
    let reviewVC = inputs.writeReview.map{ _ in
      SelectAddressViewController()
    }
    let result = inputs.resetAddress.flatMapLatest{ address in
      self?.userService.addAddress(param: .init(addresses: address)) ?? .empty()
    }
    return .init(resetResult: result,
                 writeVC: reviewVC)
  }
}
