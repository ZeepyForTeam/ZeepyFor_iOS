//
//  FirstOnboardingCollectionViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/26.
//

import UIKit

import SnapKit
import Then

// MARK: - FirstOnboardingCollectionViewCell

final class FirstOnboardingCollectionViewCell: UICollectionViewCell {

  // MARK: - Const
  struct Const {
    static func addTitleAttribute() -> [NSAttributedString.Key: Any] {
      let attribute: [NSAttributedString.Key: Any] =
        [.font: UIFont.nanumRoundExtraBold(fontSize: 32),
         .foregroundColor: UIColor.blackText]
      return attribute
    }
  }
  
  // MARK: - Components
  
  private lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.setupLabel(text: "직접 뛰는 발품팔기 No!",
                     color: .brownishGrey,
                     font: .nanumRoundExtraBold(fontSize: 16))
    return label
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.attributedText = NSAttributedString(
      string: "살아본 사람들의\n리얼후기 yes!",
      attributes: Const.addTitleAttribute())
    return label
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "firstExample")
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

extension FirstOnboardingCollectionViewCell {
  
  // MARK: - Layout Helpers
  
  private func layout() {
    layoutSubtitleLabel()
    layoutTitleLabel()
    layoutImageView()
  }
  
  private func layoutSubtitleLabel() {
    contentView.add(subtitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(98)
        $0.leading.equalTo(self.contentView.snp.leading).offset(24)
      }
    }
  }
  
  private func layoutTitleLabel() {
    contentView.add(titleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(25)
        $0.leading.equalTo(self.subtitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutImageView() {
    contentView.add(imageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(127)
        $0.centerX.equalToSuperview()
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.height.equalTo(self.contentView.frame.width * 281/375)
      }
    }
  }
  
  // MARK: - General Helpers
  
  private func configTitle() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(
      string: "살아본 사람들의\n리얼후기 yes!",
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 32),
                   .foregroundColor: UIColor.blackText])
    
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundExtraBold(fontSize: 32),
                           range: NSRange(location: 9,
                                          length: 4))
    titleText.addAttribute(NSAttributedString.Key.foregroundColor,
                           value: UIColor.mainBlue,
                           range: NSRange(location: 9,
                                          length: 4))
    
    self.titleLabel.attributedText = titleText
  }
  
}
