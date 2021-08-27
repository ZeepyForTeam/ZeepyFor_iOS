//
//  ThirdOnboardingCollectionViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/26.
//

import UIKit

import SnapKit
import Then

// MARK: - ThridOnboardingCollectionViewCell

class ThirdOnboardingCollectionViewCell: UICollectionViewCell {
    
  // MARK: - Components
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    return label
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "characters")
    return imageView
  }()
  
  lazy var joinButton: UIButton = {
    let button = UIButton()
    button.setupButton(title: "리뷰 작성하고 세상을 이롭게 하기",
                       color: .white,
                       font: .nanumRoundExtraBold(fontSize: 16),
                       backgroundColor: .mainBlue,
                       state: .normal,
                       radius: 8)
    button.addTarget(self, action: #selector(self.clickedJoinButton), for: .touchUpInside)
    return button
  }()
  
  lazy var lookAroundButton: UIButton = {
    let button = UIButton()
    button.setupButton(title: "그냥 둘러볼래요",
                       color: .grayText,
                       font: .nanumRoundExtraBold(fontSize: 12),
                       backgroundColor: .clear,
                       state: .normal,
                       radius: 0)
    button.addTarget(self, action: #selector(self.clickedLookAroundButton), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Variables
  
  var rootViewController: UIViewController?
    
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

extension ThirdOnboardingCollectionViewCell {
  
  // MARK: - Layout Helpers
  
  private func layout() {
    layoutTitleLabel()
    layoutImageView()
    layoutJoinButton()
    layoutLookAroundButton()
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
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(102)
        $0.centerX.equalToSuperview()
        $0.width.equalTo(self.contentView.frame.width * 243/375)
        $0.height.equalTo(self.contentView.frame.width * 231/375)
      }
    }
  }
  
  private func layoutJoinButton() {
    contentView.add(joinButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.imageView.snp.bottom).offset(42)
        $0.centerX.equalToSuperview()
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.height.equalTo(64)
      }
    }
  }
  
  private func layoutLookAroundButton() {
    contentView.add(lookAroundButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.joinButton.snp.bottom).offset(16)
        $0.centerX.equalToSuperview()
        $0.height.equalTo(14)
        $0.width.equalTo(80)
      }
    }
  }
  
  // MARK: - General Helpers
  
  private func configTitle() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(
      string: "우리 손으로 만드는\n집단 지성!",
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 32),
                   .foregroundColor: UIColor.blackText])
    
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundExtraBold(fontSize: 32),
                           range: NSRange(location: 11,
                                          length: 6))
    
    titleText.addAttribute(NSAttributedString.Key.foregroundColor,
                           value: UIColor.mainBlue,
                           range: NSRange(location: 11,
                                          length: 6))
    
    self.titleLabel.attributedText = titleText
  }
  
  // MARK: - Action Helpers
  @objc
  private func clickedJoinButton() {
    if let rootVC = self.rootViewController as? OnboardingViewController {
      rootVC.joinButtonClicked()
    }
  }
  
  @objc
  private func clickedLookAroundButton() {
    if let rootVC = self.rootViewController as? OnboardingViewController {
      rootVC.lookAroundButtonClicked()
    }
  }
  
}


