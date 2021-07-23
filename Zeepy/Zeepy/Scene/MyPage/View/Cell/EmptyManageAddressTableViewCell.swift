//
//  ManageAddressTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import SnapKit
import Then

// MARK: - EmptyManageAddressTableViewCell
class EmptyManageAddressTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let contextLabel = UILabel()
  private let registerButton = UIButton()
  
  // MARK: - Variables
  private final let context = "아직 등록된 주소가 없어요. :("
  private final let registerButtonTitle = "직접 등록하기"
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension EmptyManageAddressTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    contentView.backgroundColor = .whiteTextField
    layoutContextLabel()
    layoutRegisterButton()
  }
  
  private func layoutContextLabel() {
    contentView.add(contextLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(24)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  private func layoutRegisterButton() {
    contentView.add(registerButton) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contextLabel.snp.bottom).offset(12)
        $0.centerX.equalToSuperview()
        $0.width.equalTo(80)
        $0.height.equalTo(16)
        $0.bottom.equalTo(self.contentView.snp.bottom).offset(-26)
      }
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    contextLabel.setupLabel(text: context,
                            color: .grayText,
                            font: .nanumRoundExtraBold(fontSize: 14))
    registerButton.setupButton(title: registerButtonTitle,
                               color: .orangeyYellow,
                               font: .nanumRoundExtraBold(fontSize: 14),
                               backgroundColor: .clear,
                               state: .normal,
                               radius: 0)
  }
}
