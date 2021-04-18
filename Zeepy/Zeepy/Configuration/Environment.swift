//
//  Environment.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/15.
//

import Foundation
struct Environment {
    static let baseUrl = (Bundle.main.infoDictionary?["BASE_URL"] as! String).replacingOccurrences(of: " ", with: "")
}