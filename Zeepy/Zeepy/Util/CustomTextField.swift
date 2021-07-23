//
//  CustomTextField.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/22.
//

import Foundation
import UIKit

class CustomTextField : UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addLeftPadding()
    self.borderWidth = 1
    self.borderColor = .grayText
    self.setRounded(radius: 8)
    self.font = .nanumRoundRegular(fontSize: 14)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
