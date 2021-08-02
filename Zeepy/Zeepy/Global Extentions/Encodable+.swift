//
//  Encodable+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/30.
//

import Foundation

extension Encodable {
  func asParameter() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
