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
    @nonobjc class var mainYellow2: UIColor {
      return UIColor(red: 238.0 / 255.0, green: 187.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var blackText: UIColor {
      return UIColor(white: 59.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var grayText: UIColor {
      return UIColor(red: 154.0 / 255.0, green: 159.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var softBlue: UIColor {
      return UIColor(red: 89.0 / 255.0, green: 128.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var communityGreen: UIColor {
      return UIColor(red: 51.0 / 255.0, green: 212.0 / 255.0, blue: 159.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray249: UIColor {
        return UIColor(white: 249.0 / 255.0, alpha: 1.0)
      }
    @nonobjc class var blueText: UIColor {
      return UIColor(red: 117.0 / 255.0, green: 152.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var pointYellow: UIColor {
       return UIColor(red: 238.0 / 255.0, green: 187.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
     }
    @nonobjc class var whiteTextField: UIColor {
       return UIColor(white: 247.0 / 255.0, alpha: 1.0)
     }
    @nonobjc class var pale: UIColor {
        return UIColor(red: 1.0, green: 244.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0)
      }
    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 168.0 / 255.0, alpha: 1.0)
      }
    @nonobjc class var orangeyYellow: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 180.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0)
      }
    @nonobjc class var addressGray: UIColor {
      return UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
      }
    @nonobjc class var popupBackground: UIColor {
      return UIColor(white: 0, alpha: 0.6)
      }
    @nonobjc class var whiteGray: UIColor {
        return UIColor(white: 247.0 / 255.0, alpha: 1.0)
      }
    @nonobjc class var pastelYellow: UIColor {
        return UIColor(red: 1.0, green: 221.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
      }
  }
