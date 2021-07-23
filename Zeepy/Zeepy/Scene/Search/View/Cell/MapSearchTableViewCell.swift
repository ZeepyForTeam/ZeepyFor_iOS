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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    addconstraints()
//    self.backgroundColor = .clear
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.snp.makeConstraints{
        $0.height.equalTo(20)
    }
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 0))
    
  }
    
//    var cellBackgroundView = UIView().then{
//        $0.backgroundColor = .white
//    }
    var clockImageView = UIImageView().then{
        $0.image = UIImage(named: "vector")
    }
    var searchRecordLabel = UILabel()
}

extension MapSearchTableViewCell {
    func addconstraints(){
        self.contentView.snp.makeConstraints{
            $0.leading.trailing.bottom.top.equalToSuperview()
        }
        self.contentView.add(clockImageView) {
          $0.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView.snp.centerY)
            $0.leading.equalTo(self.contentView.snp.leading).offset(10)
            $0.width.height.equalTo(24)
          }
        }
        
        self.contentView.add(searchRecordLabel) {
          $0.snp.makeConstraints {
            $0.leading.equalTo(self.clockImageView.snp.trailing)
            $0.trailing.equalTo(self.contentView.snp.trailing)
            $0.centerY.equalTo(self.contentView.snp.centerY)
            $0.centerX.equalTo(self.contentView.snp.centerX)
            $0.top.bottom.equalTo(self.contentView)
          }
        }
    }
}
