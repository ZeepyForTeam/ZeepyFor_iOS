//
//  UIViewController+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/07.
//

import Foundation
import UIKit
import RxSwift
extension UIViewController {
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}


