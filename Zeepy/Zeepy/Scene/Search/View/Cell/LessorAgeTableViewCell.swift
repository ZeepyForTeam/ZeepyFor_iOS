//
//  LessorAgeTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/14.
//

import UIKit

import SnapKit
import Then

// MARK: - LessorAgeTableViewCell
class LessorAgeTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let containerView = UIView()
  let ageLabel = UILabel()
  
  // MARK: - Life Cycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
    selectionSetting()
  }
}

// MARK: - Extensions
extension LessorAgeTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutContainerView()
    layoutAgeLabel()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.backgroundColor = .white
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
  
  private func layoutAgeLabel() {
    containerView.add(ageLabel) {
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
      }
    }
  }
  
  // MARK: - General Helpers
  func dataBind(age: String) {
    ageLabel.setupLabel(text: age, color: .blackText, font: .nanumRoundBold(fontSize: 16))
  }
  
  private func selectionSetting() {
    self.selectionStyle = .blue
  }
}
