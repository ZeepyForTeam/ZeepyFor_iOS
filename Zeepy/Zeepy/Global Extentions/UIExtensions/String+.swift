//
//  String+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import Foundation
import UIKit
extension NumberFormatter {
    func makeDecimalFormat(_ number: Int) -> String {
        let formmater = self
        formmater.numberStyle = .decimal

        return formmater.string(from: NSNumber(value: number)) ?? "0"
    }
}

enum ValidationRegex: String{
  case email = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
  case phone = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
  case password = #"^[0-9a-zA-Z!@#$%^&*()?+-_~=/]{6,40}$"#
  case name = #"^[a-zA-Z가-힣](?!.*?\s{2})[a-zA-Z가-힣 ]{0,28}[a-zA-Z가-힣]$"#
  case nickname = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|\\*]{2,}+$"
  case phoneAuthCode = "^[0-9]{6}$"
}

extension String {
  func validate(with regex: String) -> Bool {
    return NSPredicate(format: "SELF MATCHES %@" , regex.trimmingCharacters(in: .whitespaces)).evaluate(with: self)
  }

  func validate(with regex: ValidationRegex) -> Bool {
    return validate(with: regex.rawValue)
  }
}

extension String {
  var splitWithConsonant: String{
    let consonants = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    return self.reduce(""){ (results, character) in
      let code = Int(String(character).unicodeScalars.reduce(0){ $0 + $1.value }) - 44032
      if code > -1 && code < 11172{
        let consonant = code / 21 / 28
        return results + consonants[consonant]
      }else{
        return results + String(character)
      }
    }
  }
  
  var insertPhoneHyphen: String {
    if self.count == 11 {
      let i = self.index(self.startIndex, offsetBy: 3)
      let j = self.index(self.startIndex, offsetBy: 8)
      var str = self
      str.insert("-", at: i)
      str.insert("-", at: j)
      return str
    }
    else if self.count == 10 {
      let i = self.index(self.startIndex, offsetBy: 3)
      let j = self.index(self.startIndex, offsetBy: 7)
      var str = self
      str.insert("-", at: i)
      str.insert("-", at: j)
      return str
    }else if self.count == 9 {
      let i = self.index(self.startIndex, offsetBy: 2)
      let j = self.index(self.startIndex, offsetBy: 6)
      var str = self
      str.insert("-", at: i)
      str.insert("-", at: j)
      return str
    }
    return self
  }

  var removePhoneHyphen: String {
    return self.filter(("0"..."9").contains)
  }
  
  var localized: String{
    return getLocalizedString(for: self)
  }
  
  var firstUppercased: String{
    guard let first = first else{ return "" }
    return String(first).uppercased() + dropFirst()
  }
  
  func getLocalizedString(for key: String, with comment: String = "") -> String{
    return NSLocalizedString(key, comment: comment)
  }
  
  func asUIImage() -> UIImage?{
    let data = Data(base64Encoded: self)
    return UIImage(data: data!)
  }
  
  func count(word: String) -> Int{
    return split(separator: " ").reduce(0) { (result, text) in
      guard text == word else{ return result }
      return result + 1
    }
  }
}

extension Hashable {
  func formattedDecimalString() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: (self as! NSNumber))!
  }
  
  func formattedDecimalString(floatingPoint: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.roundingMode = .floor
    formatter.maximumFractionDigits = floatingPoint
    formatter.minimumFractionDigits = floatingPoint
    return formatter.string(from: (self as! NSNumber))!
  }
}

extension Int {
  func secondToShowable() -> String {
    let minute = self / 60
    let second = self % 60
    
    let minuteString: String
    if minute < 10 {
      minuteString = "0\(minute)"
    }else {
      minuteString = "\(minute)"
    }
    
    let secondsString: String
    if second < 10 {
      secondsString = "0\(second)"
    }else {
      secondsString = "\(second)"
    }
    return "\(minuteString):\(secondsString)"
  }
}
