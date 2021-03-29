//
//  UITextView+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/07.
//

import Foundation
import UIKit
extension UITextView{
  static var placeHolder : String?
  func setPlaceholder(_ placeholder : String) {
    if self.text == "" {
      self.text = placeholder
      self.textColor = UIColor.gray
    }
    else {
      self.textColor == UIColor.black
    }
    
  }
}
