//
//  Optional+.swift
//  Zeepy
//
//  Created by κΉνν on 2021/07/23.
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
