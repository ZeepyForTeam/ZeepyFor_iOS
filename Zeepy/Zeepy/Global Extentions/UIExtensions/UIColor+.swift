//
//  UIColor+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/06.
//

import Foundation
import UIKit

extension UIColor {
  
  
  static func rgb(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
  }
}

extension UIColor {

  @nonobjc class var white: UIColor {
    return UIColor(white: 1.0, alpha: 1.0)
  }

  @nonobjc class var mainBlue: UIColor {
    return UIColor(red: 95.0 / 255.0, green: 134.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var gray244: UIColor {
    return UIColor(white: 244.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var gray196: UIColor {
    return UIColor(white: 196.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var gray228: UIColor {
    return UIColor(white: 228.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var heartColor: UIColor {
    return UIColor(red: 242.0 / 255.0, green: 119.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var mainYellow: UIColor {
    return UIColor(red: 1.0, green: 245.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var blackText: UIColor {
    return UIColor(white: 59.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var grayText: UIColor {
    return UIColor(red: 154.0 / 255.0, green: 159.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var blueText: UIColor {
    return UIColor(red: 117.0 / 255.0, green: 152.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
  }

}
