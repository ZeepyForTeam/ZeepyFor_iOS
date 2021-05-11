//
//  ThirdSectionCollectionReusableView.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/12.
//

import UIKit

class ThirdSectionCollectionReusableView: UICollectionReusableView {
  override func awakeFromNib() {
    super.awakeFromNib()
    layoutTitleLabel()
  }
  
  let identifier = "ThirdSectionCollectionReusableView"
  let titleLabel = UILabel()
}

extension ThirdSectionCollectionReusableView {
  func layoutTitleLabel() {
    self.add(titleLabel) {
      $0.setupLabel(text: "가구 옵션", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.snp.top).offset(64)
        $0.leading.equalTo(self.snp.leading)
      }
    }
  }
}
