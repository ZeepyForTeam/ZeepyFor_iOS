//
//  CustomNavigationBar.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/12.
//

import Foundation
import UIKit
class CustomNavigationBar : UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpNavi()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  let backBtn = UIButton().then {
    $0.setImage(UIImage(named:"btnBack"), for: .normal)
  }
  let naviTitle = UILabel().then{
    $0.font = .nanumRoundExtraBold(fontSize: 20)
  }
  private func setUpNavi() {
    self.backgroundColor = .white
    self.addUnderBar()
    self.adds([naviTitle,backBtn])
    naviTitle.snp.makeConstraints{
      $0.bottom.equalToSuperview().offset(-20)
      $0.centerX.equalToSuperview()
    }
    backBtn.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(44)
      $0.leading.equalToSuperview()
    }
  }
  func setUp(title: String,
             font: UIFont = .nanumRoundExtraBold(fontSize: 20),
             titleColor: UIColor = .blackText,
             leftBtn: UIButton? = nil,
             rightBtn : UIButton? = nil) {
    self.naviTitle.text = title
    self.naviTitle.font = font
    self.naviTitle.textColor = titleColor
    if let left = leftBtn {
      self.backBtn.removeFromSuperview()
      self.add(left)
      left.snp.makeConstraints{
        $0.centerY.equalToSuperview()
        $0.width.height.equalTo(44)
        $0.leading.equalToSuperview()
      }
    }
    if let right = rightBtn {
      self.add(right)
      right.snp.makeConstraints{
        $0.centerY.equalToSuperview()
        $0.width.height.equalTo(44)
        $0.trailing.equalToSuperview()
      }
    }
  }
}
