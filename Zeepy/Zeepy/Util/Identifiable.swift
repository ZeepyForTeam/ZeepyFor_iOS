//
//  Identifiable.swift
//  Zeepy
//
//  Created by κΉνν on 2021/04/18.
//

import Foundation
import UIKit

protocol Identiifiable {
  static var identifier: String { get }
}

extension Identifiable {
  static var identifier: String {
    return String(describing: self)
  }
}
extension UITableViewCell: Identifiable {}
extension UICollectionViewCell: Identifiable {}
extension UIViewController: Identifiable {}
extension UICollectionReusableView: Identifiable {}
