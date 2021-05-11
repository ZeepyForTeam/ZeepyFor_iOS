//
//  ReviewCollectionViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/11.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
  let identifier = "ReviewCollectionViewCell"
  let titleLabel = UILabel()
  let containerView = UIView()
  let containerBackgroundImageView = UIImageView()
  let containerContentLabel = UILabel()
}

extension ReviewCollectionViewCell {
  func layoutTitleLabel() {
    self.contentView.add(titleLabel) {
      $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 12))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top)
        $0.leading.equalTo(self.contentView.snp.leading)
      }
    }
  }
  func layoutContainerView() {
    self.contentView.add(containerView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.trailing.equalTo(self.contentView.snp.trailing)
        $0.bottom.equalTo(self.contentView.snp.bottom)
      }
    }
  }
  func layoutContainerBackgroundImageView() {
    self.containerView.add(containerBackgroundImageView) {
      $0.image = UIImage(named: "btnGoodReviewUnselected")
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.containerView.snp.edges)
      }
    }
  }
  func layoutContainerContentLabel() {
    self.containerView.add(containerContentLabel) {
      $0.setupLabel(text: "", color: .grayText, font: .nanumRoundExtraBold(fontSize: 14))
      $0.snp.makeConstraints {
        $0.centerX.equalTo(self.containerView.snp.centerX)
        $0.centerY.equalTo(self.containerView.snp.centerY)
      }
    }
  }
  func layout() {
    layoutTitleLabel()
    layoutContainerView()
    layoutContainerBackgroundImageView()
    layoutContainerContentLabel()
  }
}
