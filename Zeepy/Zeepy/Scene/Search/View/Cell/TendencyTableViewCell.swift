//
//  TendencyTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/25.
//

import UIKit

class TendencyTableViewCell: UITableViewCell {
  
  let identifier = "TendencyTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
    self.backgroundColor = .clear
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 0))
    
  }
  
  let iconImageView = UIImageView()
  let tendencyContainerView = UIView()
  let tendencyLabel = UILabel()
}

extension TendencyTableViewCell {
  func layout() {
    self.contentView.backgroundColor = .clear
    layoutIconImageView()
    layoutTendencyContainerView()
    layoutTendencyLabel()
  }
  func layoutIconImageView() {
    self.contentView.add(iconImageView) {
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.contentView.snp.centerY)
        $0.leading.equalTo(self.contentView.snp.leading)
        $0.width.height.equalTo(24)
      }
    }
  }
  func layoutTendencyContainerView() {
    self.contentView.add(tendencyContainerView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: self.contentView.frame.height/2)
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.leading.equalTo(self.iconImageView.snp.trailing).offset(16)
        $0.width.equalTo(201)
      }
    }
  }
  func layoutTendencyLabel() {
    self.tendencyContainerView.add(tendencyLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.tendencyContainerView.snp.leading).offset(12)
        $0.centerY.equalTo(self.tendencyContainerView.snp.centerY)
      }
    }
    self.tendencyContainerView.snp.remakeConstraints {
      $0.leading.equalTo(self.iconImageView.snp.trailing).offset(16)
      $0.trailing.equalTo(self.tendencyLabel.snp.trailing).offset(12)
      $0.top.bottom.equalToSuperview()
    }
  }
}
