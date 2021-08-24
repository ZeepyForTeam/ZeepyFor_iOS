//
//  ReportTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ReportTableViewCell
class ReportTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let containerView = UIView()
  let reasonLabel = UILabel()
  private let separatorView = UIView()

  // MARK: - Variables
  
  
  // MARK: - Life Cycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
}

// MARK: - Extensions
extension ReportTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.selectionStyle = .none
    layoutContainerView()
    layoutReasonLabel()
    layoutSeparatorView()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
  
  private func layoutReasonLabel() {
    containerView.add(reasonLabel) {
      $0.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.top.equalTo(self.containerView.snp.top).offset(12)
        $0.leading.equalTo(self.containerView.snp.leading).offset(24)
      }
    }
  }
  
  private func layoutSeparatorView() {
    containerView.add(separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.bottom.leading.trailing.equalToSuperview()
        $0.height.equalTo(1)
      }
    }
  }
}
