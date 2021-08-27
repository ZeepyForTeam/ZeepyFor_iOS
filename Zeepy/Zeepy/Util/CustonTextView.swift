//
//  CustonTextView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CustomTextView: UITextView {

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame,textContainer: textContainer)
    self.borderWidth = 1
    self.borderColor = .grayText
    self.setRounded(radius: 8)
    self.font = .nanumRoundRegular(fontSize: 14)
    self.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
    self.enablesReturnKeyAutomatically = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
