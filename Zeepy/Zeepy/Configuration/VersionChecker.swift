//
//  VersionChecker.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/24.
//

import Foundation
import UIKit
class VersionChecker : NSObject {
    static let shared = VersionChecker()
    override private init() { }
}
extension VersionChecker {
    func versionChecker() -> (Version, Version){
        guard
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "https://itunes.apple.com/kr/lookup?bundleId=zeepy.com.zeepy"),
            let data = try? Data(contentsOf: url),
            let json = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]) as [String : Any]??),
            let results = json?["results"] as? [[String: Any]],
            !results.isEmpty,
            let appStoreVersion = results[0]["version"] as? String

        else {
            return (.init(version: "0.0.0"),.init(version: "0.0.0"))
        }
        let current = Version(version: currentVersion)
        let appstore = Version(version: appStoreVersion)

        return (current, appstore)
    }

}
struct Version : Comparable{
    static func < (lhs: Version, rhs: Version) -> Bool {
        let lhsVersions = lhs.version.split(separator: ".").map{Int($0)}
        let rhsVersions = rhs.version.split(separator: ".").map{Int($0)}
        if lhsVersions[0]! < rhsVersions[0]! {
            return true
        }
        else if lhsVersions[1]! < rhsVersions[1]! {
            return true
        }
        else if lhsVersions[2]! < rhsVersions[2]! {
            return true
        }
        else {
            return false
        }
    }

    let version: String
}
