//
//  LastTableViewCell.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/24.
//

import UIKit
import SnapKit
import Then

class LastTableViewCell: UITableViewCell {
    var deleteTableViewCellLabel = UILabel().then{
        $0.text = "최근 검색 목록 삭제"
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 8)
        $0.textColor = .grayText
    }
    
    func addConstraints(){
        self.backgroundColor = .whiteGray
        self.addSubview(deleteTableViewCellLabel)
      self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
      self.layer.cornerRadius = 16
      contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
      contentView.layer.cornerRadius = 16
        deleteTableViewCellLabel.snp.makeConstraints{
          $0.top.equalToSuperview().offset(4)
          $0.bottom.equalToSuperview().offset(-8)
          $0.centerX.equalToSuperview()
        }
    }
}
