//
//  MypageTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import SnapKit
import Then

// MARK: - MypageTableViewCell
class MypageTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let titleLabel = UILabel()
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
}

// MARK: - Extensions
extension MypageTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    contentView.add(titleLabel) {
      $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 14), align: .left)
      $0.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.leading.equalToSuperview().offset(24)
      }
    }
  }
  
  // MARK: - General Helpers
  func configData(title: String) {
    titleLabel.text = title
  }
}
