//
//  File.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/15.
//

import Foundation
import UIKit
extension UILabel {
  func setupLabel(text: String, color: UIColor, font: UIFont, align: NSTextAlignment? = .left) {
    self.font = font
    self.text = text
    self.textColor = color
    self.textAlignment = align ?? .left
  }
    
    func halfTextColorChange (fullText : String , changeText : Array<String> ) {
        var theText = ""
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: theText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        
        for i in 0 ..< changeText.count {
            theText = changeText[i]
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainBlue , range: range)
        }
        self.attributedText = attribute
    }
    
//    extension UILabel {
//        func halfTextColorChange (fullText : String , changeText : String ) {
//            let strNumber: NSString = fullText as NSString
//            let range = (strNumber).range(of: changeText)
//            let attribute = NSMutableAttributedString.init(string: fullText)
//            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
//            self.attributedText = attribute
//        }
}
