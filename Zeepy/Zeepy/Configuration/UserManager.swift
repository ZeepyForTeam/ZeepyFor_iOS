//
//  UserManager.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/02.
//

import Foundation
import UIKit
import RxSwift
import Moya

class UserManager: NSObject {
  static let shared = UserManager()
  var address = [Addresses]()
  var currentAddress: Addresses? {
    didSet {
      print(currentAddress)
      NotificationCenter.default.post(name: NSNotification.Name("address"), object: nil)
    }
  }
  let disposeBag = DisposeBag()
  override private init() { }
  func fetchUserAddress() {
    let service = UserService(provider: MoyaProvider<UserRouter>(plugins:[NetworkLoggerPlugin()]))
    service.getAddress()
      .map(ResponseGetAddress.self)
      .map{$0.addresses}
      .bind{[weak self] in
        self?.address = $0
      }
      .disposed(by: disposeBag)
   service.getAddress()
      .map(ResponseGetAddress.self)
      .map{$0.addresses}
      .map{
      $0.first(where: {$0.isAddressCheck})
    }.bind{[weak self] in
        self?.currentAddress = $0
      }
    .disposed(by: disposeBag)
  }
  func changeCurrent(by new : Addresses) {
    self.currentAddress = new
    self.currentAddress?.isAddressCheck = true
    for i in 0..<self.address.count {
      self.address[i].isAddressCheck = self.address[i] == new
    }
  }
}
