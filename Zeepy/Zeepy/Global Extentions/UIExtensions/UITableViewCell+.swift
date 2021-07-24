//
//  UITableViewCell+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/24.
//

import Foundation
import RxSwift
extension UITableViewCell {
  func itemInterSize(as offset: CGFloat? = 10) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: offset ?? 10))
    self.addSubview(paddingView)
    paddingView.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.snp.bottom)
    }
  }
}
