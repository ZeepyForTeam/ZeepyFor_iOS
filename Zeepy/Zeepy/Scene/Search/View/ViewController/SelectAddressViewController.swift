//
//  SelectAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/04/17.
//
import SnapKit
import Then
import UIKit

class SelectAddressViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
  
  

  let titleLabel = UILabel()
  let titleText = NSMutableAttributedString(string: "거주하고 계신 집을 \n검색하세요",
                                            attributes: [
                                              .font: UIFont.nanumRoundBold(fontSize: 24),
                                              .foregroundColor: UIColor.mainBlue])

  func layout() {
    self.view.add(self.titleLabel) {
      self.titleText.addAttribute(.font,
                                  value: UIFont.nanumRoundRegular(fontSize: 24),
                                  range: NSRange(location: 9, length: 8))
      $0.attributedText = self.titleText
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.top.equalTo(self.view.snp.top).offset(16+44)
      }
    }
  }
}
