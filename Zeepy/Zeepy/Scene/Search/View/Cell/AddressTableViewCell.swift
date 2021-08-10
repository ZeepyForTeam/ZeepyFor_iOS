//
//  AddressTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/30.
//

import UIKit

import SnapKit
import Then

// MARK: - AddressTableViewCell
class AddressTableViewCell: UITableViewCell {
  
  // MARK: - Components
  let AddressLabel = UILabel()
  let RoadAddressLabel = UILabel()
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
}

// MARK: - Extensions
extension AddressTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutAddressLabel()
    layoutRoadAddressLabel()
  }
  
  private func layoutAddressLabel() {
    contentView.add(AddressLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(20)
        $0.leading.equalTo(self.contentView.snp.leading).offset(29)
      }
    }
  }
  
  private func layoutRoadAddressLabel() {
    contentView.add(RoadAddressLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.AddressLabel.snp.bottom).offset(6)
        $0.leading.equalTo(self.AddressLabel.snp.leading)
      }
    }
  }
}
