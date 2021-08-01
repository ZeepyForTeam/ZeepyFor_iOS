//
//  MapSearchTableViewCell.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/21.
//

import UIKit
import SnapKit
import Then

class MapSearchTableViewCell: UITableViewCell {
    
    let identifier = "MapSearchTableViewCell"
    
    var cellContentView = UIButton().then{
        $0.backgroundColor = .gray228
    }
    var clockImageView = UIImageView().then{
        $0.image = UIImage(named: "vector")
    }
    
    var searchRecordLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 12.0)
    }
    func addConstraints(){
        self.adds([cellContentView])
        cellContentView.adds([clockImageView, searchRecordLabel])
        
        cellContentView.snp.makeConstraints {
            $0.bottom.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        self.clockImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.bottom.equalToSuperview().offset(-11)
            $0.leading.equalToSuperview().offset(10)
          }
        self.searchRecordLabel.snp.makeConstraints{
            $0.leading.equalTo(self.clockImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
}
