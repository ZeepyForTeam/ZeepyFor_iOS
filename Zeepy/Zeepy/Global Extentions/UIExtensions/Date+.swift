//
//  Date+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import Foundation
import UIKit

// MARK: - Detail Info
extension Date {
  var year: Int {
    return CalendarService.shared.calendarKST.component(.year, from: self)
  }
  var month: Int {
    return CalendarService.shared.calendarKST.component(.month, from: self)
  }
  var day: Int {
    return CalendarService.shared.calendarKST.component(.day, from: self)
  }
  var hour: Int {
    return CalendarService.shared.calendarKST.component(.hour, from: self)
  }
  var minute: Int {
    return CalendarService.shared.calendarKST.component(.minute, from: self)
  }
  var detailTime: String {
    let components = CalendarService.shared.calendarKST.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
    if components.year == 0 {
      if components.day == 0 {
        if components.hour == 0 {
          if components.minute! < 1 {
            return "몇초 전"
          } else {
            return "\(components.minute!)분 전"
          }
        } else {
          return "\(components.hour!)시간 전"
        }
      } else if components.day == 1 {
        return "어제"
        
      } else if components.day ?? 12 < 11 {
        return "\(components.day)일 전"
      }
      else {
        return self.yyyyMMdd
      }
    } else {
      return self.yyyyMMdd
    }
  }
}

// MARK: - Date Format
enum DateFormat: String {
  case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

  case EEEEMMMMddyyyy = "EEEE MMMM dd,yyyy"

  case HHmm = "HH:mm"
  case HHmmss = "HH:mm:ss"

  case MMdd = "MM/dd"
  case MMddE = "MM/dd'('E')'"
  case MMddEkr = "MM'월 'dd'일 ('E')'"


  case yyMMdd = "yy:MM:dd"
  case yyyyMMdd = "yyyy-MM-dd"
  case yyyyMMddHHmm = "yyyy-MM-dd' 'HH:mm"
  case yyyyMMddHHmmss = "yyyy-MM-dd' 'HH:mm:ss"

  case yyyyMMDot = "yyyy.MM"

  case yyyyMMddDot = "yyyy. MM. dd"
  case yyyyMMddKR = "yyyy'년 'M'월 'd'일('E')'"
}

// MARK: - Formatter
extension Date {
  var EEEEMMMMddyyyy: String {
    return self.asString(format: .EEEEMMMMddyyyy)
  }

  var HHmm: String {
    return self.asString(format: .HHmm)
  }
  var HHmmss: String {
    return self.asString(format: .HHmmss)
  }

  var MMdd: String {
    return self.asString(format: .MMdd)
  }
  var MMddE: String {
    return self.asString(format: .MMddE)
  }

  var yyMMdd: String{
    return self.asString(format: .yyMMdd)
  }
  var yyyyMMdd: String{
    return self.asString(format: .yyyyMMdd)
  }
  var yyyyMMddHHmm: String {
    return self.asString(format: .yyyyMMddHHmm)
  }
  var yyyyMMddHHmmss: String {
    return self.asString(format: .yyyyMMddHHmmss)
  }

  var yyyyMMddDot: String {
    return self.asString(format: .yyyyMMddDot)
  }
  var yyyyMMddKR: String {
    return self.asString(format: .yyyyMMddKR)
  }
}

extension Date {
  func asString(format: DateFormat) -> String {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "en_US_POSIX")
    formatter.timeZone = CalendarService.shared.timeZoneKST
    formatter.dateFormat = format.rawValue
    return formatter.string(from: self)
  }
}

extension String {
  func asDate(format: DateFormat = .iso8601, timeZone: TimeZone? = CalendarService.shared.timeZoneKST) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    formatter.dateFormat = format.rawValue
    return formatter.date(from: self)
  }
}
