//
//  CommunicationTendencyViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/03.
//

import SnapKit
import Then
import UIKit

class CommunicationTendencyViewController: BaseViewController {
  // MARK: - Constants
  let titleLabelNumberOfLine = 2
  
  // MARK: - Components
  let titleLabel = UILabel()
  let tendencyTableContainerView = UIView()
  let tendencyTableView = UITableView()
  let nextButton = UIButton()
  let seperatorView = UIView()
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
  }
  
}
// MARK: - Extensions
extension CommunicationTendencyViewController {
  // MARK: - Helpers
  func layoutTitleLabel() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "임대인의 소통성향은 \n어땠나요?",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 3, length: 1))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 8))
    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  func layoutTendencyTableContainerView() {
    self.view.add(self.tendencyTableContainerView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(100)
        $0.centerX.equalTo(self.view.snp.centerX)
      }
    }
  }
  func layoutTendencyTableView() {
    self.tendencyTableContainerView.add(self.tendencyTableView) {
      $0.estimatedRowHeight = UITableView.automaticDimension
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.tendencyTableContainerView.snp.leading)
        $0.trailing.equalTo(self.tendencyTableContainerView.snp.trailing)
        $0.top.equalTo(self.tendencyTableContainerView.snp.top)
      }
    }
  }
  func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.backgroundColor = .gray244
      $0.setTitle("다음으로", for: .normal)
      $0.setTitleColor(.grayText, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.tendencyTableContainerView.snp.leading)
        $0.trailing.equalTo(self.tendencyTableContainerView.snp.trailing)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38-(self.tabBarController?.tabBar.frame.height ?? 44))
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  func layoutSeperatorView() {
    self.view.add(self.seperatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  func layout() {
    layoutTitleLabel()
    layoutTendencyTableContainerView()
    layoutTendencyTableView()
    layoutNextButton()
    layoutSeperatorView()
  }
}

