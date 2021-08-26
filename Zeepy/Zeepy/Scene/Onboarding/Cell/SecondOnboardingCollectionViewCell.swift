//
//  SecondOnboardingCollectionViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/26.
//

import UIKit

import SnapKit
import Then

// MARK: - SecondOnboardingCollectionViewCell

class SecondOnboardingCollectionViewCell: UICollectionViewCell {
    
  // MARK: - Components
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 4
    return label
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "secondExample")
    return imageView
  }()
  
  
  // MARK: - Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configTitle()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Extensions

extension SecondOnboardingCollectionViewCell {
  
  // MARK: - Layout Helpers
  
  private func layout() {
    layoutTitleLabel()
    layoutImageView()
  }

  private func layoutTitleLabel() {
    contentView.add(titleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(141)
        $0.leading.equalTo(self.contentView.snp.leading).offset(25)
      }
    }
  }
  
  private func layoutImageView() {
    contentView.add(imageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(81)
        $0.centerX.equalToSuperview()
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.height.equalTo(self.contentView.frame.width * 204/375)
      }
    }
  }
  
  // MARK: - General Helpers
  
  private func configTitle() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(
      string: "내가 남긴\n자취방 후기는\n500만 자취생에게\n도움이 될거에요.",
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 32),
                   .foregroundColor: UIColor.blackText])
    
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundExtraBold(fontSize: 32),
                           range: NSRange(location: 6,
                                          length: 6))
    titleText.addAttribute(NSAttributedString.Key.foregroundColor,
                           value: UIColor.mainBlue,
                           range: NSRange(location: 6,
                                          length: 6))
    
    self.titleLabel.attributedText = titleText
  }
  
}

