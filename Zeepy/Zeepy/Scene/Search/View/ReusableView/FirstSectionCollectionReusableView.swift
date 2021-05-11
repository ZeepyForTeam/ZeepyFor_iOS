//
//  FirstSectionCollectionReusableView.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/11.
//

import UIKit

class FirstSectionCollectionReusableView: UICollectionReusableView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
  
  let titleLabelNumberOfLine = 2
  let identifier = "FirstSectionCollectionReusableView"
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
}

extension FirstSectionCollectionReusableView {
  func layoutTitleLabel() {
    self.add(titleLabel) {
      $0.attributedText = self.setUpTitleLabel()
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.top.equalTo(self.snp.top).offset(16)
        $0.leading.equalTo(self.snp.leading)
      }
    }
  }
  func layoutSubtitleLabel() {
    self.add(subtitleLabel) {
      $0.setupLabel(text: "방의 개수는 몇 개인가요?", color: .blueText, font: .nanumRoundExtraBold(fontSize: 14))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(36)
        $0.leading.equalTo(self.titleLabel.snp.leading)
      }
    }
  }
  func layout() {
    layoutTitleLabel()
    layoutSubtitleLabel()
  }
  func setUpTitleLabel() -> NSMutableAttributedString {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "집에 대한 정보를\n조금 더 알려주세요!",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 1))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 15, length: 6))
    return titleText
  }
}
