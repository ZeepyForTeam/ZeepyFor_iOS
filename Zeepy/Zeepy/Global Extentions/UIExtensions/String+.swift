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
extension String {
  var tagTypes : TagType {
    switch self {
    case "ONE":
      return .one
    case "TWO":
      return .two
    case "TRHEEORMORE":
      return .three
    case "OFFICETEL":
      return .officetel
    case "ROWHOUSE":
      return .rawhouse
    case "UNKNOWN":
      return .unknown
    default :
      return .unknown
    }
  }
  var dealTypes: String {
    switch self {
    case "JEONSE" :
      return "전세"
    case "MONTHLY" :
      return "월세"
    case "DEAL" :
      return "자가"
    default :
      return "기타"
    }
  }
  var validateType: ValidateType {
    switch self {
    case "BUSINESS" :
      return ValidateType.business
    case "KIND" :
      return .kind
    case "GRAZE" :
      return .free
    case "SOFTY" :
      return .cute
    default :
      return ValidateType.bad
    }
  }
  var furnitures: String {
    switch self {
    case "AIRCONDITIONAL":
      return "에어컨"
    case "WASHINGMACHINE":
      return "세탁기"
    case "BED":
      return "침대"
    case "CLOSET":
      return "옷장"
    case "DESK":
      return "책상"
    case "REFRIDGERATOR":
      return "냉장고"
    case "INDUCTION":
      return "인덕션"
    case "BURNER":
      return "가스레인지"
    case "MICROWAVE":
      return "전자레인지"
    default :
      return self
    }
  }
  var HouseValidate: String {
    switch self {
    case "GOOD":
      return "좋아요"
    case "PROPER" :
      return "적당해요"
    case "SOSO" :
      return "적당해요"
    case "BAD":
      return "별로에요"
    default :
      return self
    }
  }
  var HouseValidateImg: UIImage {
    switch self {
    case "GOOD":
      return UIImage(named: "iconSmile")!
    case "PROPER" :
      return UIImage(named: "iconSoso")!
    case "SOSO" :
      return UIImage(named: "iconSoso")!
    case "BAD":
      return UIImage(named: "iconAngry")!
    default :
      return UIImage()
    }
  }
  var AgeTranslate: String {
    switch self {
    case "TEN":
      return "10대"
    case "TWENTY":
      return "20대"
    case "THIRTY":
      return "30대"
    case "FOURTY":
      return "40대"
    case "FIFTY":
      return "50대"
    case "SIXTY":
      return "60대 이상"
    case "UNKNOWN":
    return "알 수 없는 나이의"
    default :
      return self
    }
  }
  var GenderTranslate: String {
    switch self {
    case "MALE":
      return "남자"
    case "FEMAIL":
      return "여자"
    default :
      return self
    }
  }
}
