//
//  RoomTagCollectionViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/18.
//

import UIKit

import SnapKit
import Then

// MARK: - RoomTagCollectionViewCell
class RoomTagCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Components
  private let containerView = UIView()
  let tagLabel = UILabel()
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: .zero)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Extensions
extension RoomTagCollectionViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutContainerView()
    layoutTagLabel()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.backgroundColor = .gray228
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
  
  private func layoutTagLabel() {
    containerView.add(tagLabel) {
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
      }
    }
  }
}
