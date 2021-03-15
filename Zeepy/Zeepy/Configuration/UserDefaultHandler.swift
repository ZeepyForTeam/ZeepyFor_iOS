//
//  UserDefaultHandler.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/15.
//

import Foundation
class UserDefaultHandler {
    static var accessToken: String? {
        return UserDefaultHelper<String>.value(forKey: .accessToken)
    }

    static var refreshToken: String? {
        return UserDefaultHelper<String>.value(forKey: .refreshToken)
    }

    static var userId: Int? {
        return UserDefaultHelper<Int>.value(forKey: .userId)
    }
}

class UserDefaultHelper<T> {
    class func value(forKey key: DataKeys) -> T? {
        if let data = UserDefaults.standard.value(forKey : key.rawValue) as? T {
            return data
        }
        else {
            return nil
        }
    }

    class func set(_ value: T, forKey key: DataKeys) {
        UserDefaults.standard.set(value, forKey : key.rawValue)
    }

    class func clearAll() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

enum DataKeys: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case userId = "userId"
}
