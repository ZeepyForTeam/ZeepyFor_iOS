//
//  ManageAddressTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/12.
//

import UIKit

import SnapKit
import Then

// MARK: - ManageAddressTableViewCell
class ManageAddressTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let containerView = UIView()
  let addressLabel = UILabel()
  private let deleteButton = UIButton()
  
  // MARK: - Variables
  var rootViewController: UIViewController?
  var index = 100
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
}

// MARK: - Extensions
extension ManageAddressTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.selectionStyle = .none
    layoutContainerView()
    layoutAddressLabel()
    layoutDeleteButton()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(4)
        $0.bottom.equalTo(self.contentView.snp.bottom).offset(-4)
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(48)
      }
    }
  }
  
  private func layoutAddressLabel() {
    containerView.add(addressLabel) {
      $0.setupLabel(text: " ", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.containerView.snp.leading).offset(12)
        $0.centerY.equalToSuperview()
      }
    }
  }
  
  private func layoutDeleteButton() {
    containerView.add(deleteButton) {
      $0.setBackgroundImage(UIImage(named: "btnCloseYel"), for: .normal)
      $0.addTarget(self, action: #selector(self.clickedDeleteButton), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-8)
        $0.centerY.equalToSuperview()
        $0.width.height.equalTo(24)
      }
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func clickedDeleteButton() {
    let rootVC = self.rootViewController as? ManageAddressViewController
    rootVC?.selectedIndex = index
    rootVC?.modalPopupView()
  }
}
