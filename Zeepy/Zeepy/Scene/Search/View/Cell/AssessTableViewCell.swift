//
//  AssessTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/26.
//

import UIKit

class AssessTableViewCell: UITableViewCell {
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
  
  // MARK: - Components
  let containerView = UIView()
  let assessLabel = UILabel()
  
}
// MARK: - Extensions
extension AssessTableViewCell {
  func layout() {
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
    layoutContainerView()
    layoutAssessLabel()
  }
  func layoutContainerView() {
    contentView.add(containerView) {
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        $0.edges.equalToSuperview().inset(inset)
      }
    }
  }
  func layoutAssessLabel() {
    containerView.add(assessLabel) {
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
      }
    }
  }
}
