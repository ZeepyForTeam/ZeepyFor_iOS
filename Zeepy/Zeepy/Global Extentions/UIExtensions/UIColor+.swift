//
//  UIColor+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/06.
//

import Foundation
import UIKit

extension UIColor {
  static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
  }
}

