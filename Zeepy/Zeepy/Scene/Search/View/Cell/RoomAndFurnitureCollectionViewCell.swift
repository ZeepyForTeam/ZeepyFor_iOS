//
//  RoomAndFurnitureCollectionViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/11.
//

import SnapKit
import Then
import UIKit

class RoomAndFurnitureCollectionViewCell: UICollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.backgroundColor = .clear
    layout()
  }
  
  let identifier = "RoomAndFurnitureCollectionViewCell"
  
  let containerView = UIView()
  let titleLabel = UILabel()
  
}

extension RoomAndFurnitureCollectionViewCell {
  func layout() {
    self.contentView.add(containerView) {
      $0.setRounded(radius: 8)
      $0.backgroundColor = .mainYellow
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.contentView.snp.edges)
      }
    }
    self.containerView.add(titleLabel) {
      $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 16), align: .center)
      $0.snp.makeConstraints {
        $0.centerX.equalTo(self.containerView.snp.centerX)
        $0.centerY.equalTo(self.containerView.snp.centerY)
      }
    }
  }
}
