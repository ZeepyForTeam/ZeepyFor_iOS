//
//  NSObject+.swift
//  Zeepy
//
//  Created by κΉνν on 2021/09/02.
//

import Foundation
extension NSObject {
  var className: String {
    return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
  }

  static var className: String {
    return String(describing: self).components(separatedBy: ".").last ?? ""
  }
}
