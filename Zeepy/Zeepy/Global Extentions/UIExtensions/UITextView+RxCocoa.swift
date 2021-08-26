//
//  UITextView+RxCocoa.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/04.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
extension UITextView{
  func setPlaceholder(placeholder : String , disposeBag: DisposeBag){
    self.text = placeholder
    self.rx.didBeginEditing
      .bind{
        if self.text == placeholder{
          self.text = ""
        }
      }.disposed(by: disposeBag)
    self.rx.text
      .orEmpty.bind{text in
        if text == placeholder {
          self.textColor =  .grayText
        }
        else {
          self.textColor = .blackText
        }
      }.disposed(by: disposeBag)
    self.rx.didEndEditing
      .bind{
        if self.text.isEmpty{
          self.textColor =  .grayText
          self.text = placeholder
        }
      }.disposed(by: disposeBag)
  }
}
