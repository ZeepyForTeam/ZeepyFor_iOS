//
//  CalendarService.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import Foundation
import UIKit

final class CalendarService {
  static let shared = CalendarService()

  lazy var calendarLocale: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .init(identifier: "en_US_POSIX")
    calendar.timeZone = .autoupdatingCurrent
    return calendar
  }()

  lazy var calendarUTC: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .init(identifier: "en_US_POSIX")
    calendar.timeZone = TimeZone(identifier: "UTC")!
    return calendar
  }()

  lazy var calendarKST: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .init(identifier: "en_US_POSIX")
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    return calendar
  }()

  lazy var timeZoneLocale: TimeZone = { .autoupdatingCurrent }()
  lazy var timeZoneUTC: TimeZone = { TimeZone(identifier: "UTC")! }()
  lazy var timeZoneKST: TimeZone = { TimeZone(identifier: "Asia/Seoul")! }()

  private init() {}
}

extension CalendarService {
  func generateDateRange(_ calendar: Calendar = CalendarService.shared.calendarKST, from startDate: Date, to endDate: Date) -> [Date] {
    if startDate > endDate { return [] }
    var returnDates: [Date] = []
    var currentDate = startDate
    repeat {
      returnDates.append(currentDate)
      currentDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
    } while currentDate <= endDate
    return returnDates
  }
}
