//
//  SelectAddressEmptyTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/10.
//

import UIKit

import SnapKit
import Then

// MARK: - SelectAddressEmptyTableViewCell
class SelectAddressEmptyTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let containerView = UIView()
  private let contextLabel = UILabel()
  private let registerButton = UIButton()
  
  // MARK: - Variables
  var rootViewController: UIViewController?
  
  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    layout()
  }
}

// MARK: - Extensions
extension SelectAddressEmptyTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutContainerView()
    layoutContextLabel()
    layoutRegisterButton()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.backgroundColor = .whiteGray
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
  
  private func layoutContextLabel() {
    containerView.add(contextLabel) {
      $0.setupLabel(text: "아직 등록한 주소가 없어요. :(",
                    color: .grayText,
                    font: .nanumRoundExtraBold(fontSize: 12))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.containerView.snp.top).offset(22)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  private func layoutRegisterButton() {
    containerView.add(registerButton) {
      $0.setupButton(title: "직접 등록하기",
                     color: .mainBlue,
                     font: .nanumRoundExtraBold(fontSize: 12),
                     backgroundColor: .clear,
                     state: .normal,
                     radius: 0)
      $0.sizeToFit()
      $0.addTarget(self, action: #selector(self.clickedRegisterButton), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contextLabel.snp.bottom).offset(14)
        $0.centerX.equalToSuperview()
        $0.width.equalTo(69)
        $0.height.equalTo(14)
      }
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func clickedRegisterButton() {
    if let rootVC = rootViewController as? SelectAddressViewController {
      rootVC.registerButtonClicked()
    }
  }
}
