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
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 12)
        $0.textColor = .grayText
    }
    
    func addConstraints(){
        self.backgroundColor = .gray228
        self.addSubview(deleteTableViewCellLabel)
        deleteTableViewCellLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}
