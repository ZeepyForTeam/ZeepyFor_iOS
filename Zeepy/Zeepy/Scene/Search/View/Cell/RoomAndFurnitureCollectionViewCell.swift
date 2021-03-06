//
//  RoomAndFurnitureCollectionViewCell.swift
//  Zeepy
//
//  Created by λΈνμ on 2021/05/11.
//

import SnapKit
import Then
import UIKit

class RoomAndFurnitureCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Components
  let containerView = UIView()
  let titleLabel = UILabel()
  
  // MARK: - Variables
  let identifier = "RoomAndFurnitureCollectionViewCell"
  var index: Int?
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.backgroundColor = .clear
    layout()
  }
  
}

extension RoomAndFurnitureCollectionViewCell {
  func layout() {
    self.contentView.add(containerView) {
      $0.setRounded(radius: 8)
      $0.backgroundColor = .whiteGray
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
