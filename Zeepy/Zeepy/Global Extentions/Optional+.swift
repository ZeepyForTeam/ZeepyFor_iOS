//
//  Optional+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/23.
//

import Foundation

extension Optional {
  public var isNil: Bool {
    switch self {
    case .some:
      return false
    case .none:
      return true
    }
  }

  public var isNotNil: Bool {
    return !isNil
  }
}
