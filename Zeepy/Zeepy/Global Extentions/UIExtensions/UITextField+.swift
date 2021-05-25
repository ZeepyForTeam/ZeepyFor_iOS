//
//  File.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/15.
//

import Foundation
import UIKit
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
  class func textFieldWithInsets(insets: UIEdgeInsets) -> UITextField {
    return fourInsetTextField(insets: insets)
  }
  func configureTextField(textColor: UIColor, font: UIFont, placeholder: String? = "") {
    self.autocorrectionType = .no
    self.autocapitalizationType = .none
    self.textColor = textColor
    self.font = font
    self.placeholder = placeholder ?? ""
  }
}
class fourInsetTextField: UITextField {
  var insets: UIEdgeInsets
  
  init(insets: UIEdgeInsets) {
    self.insets = insets
    super.init(frame: .zero)
    self.autocorrectionType = .no
    self.autocapitalizationType = .none
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("not intended for use from a NIB")
  }
  
  // placeholder position
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return super.textRect(forBounds: bounds.inset(by: insets))
  }
  
  // text position
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return super.editingRect(forBounds: bounds.inset(by: insets))
  }
  
}

