//
//  SettingsViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/24.
//

import UIKit

import SnapKit
import Then

// MARK - SettingsViewController
class SettingsViewController: UIViewController {
  
  // MARK: - Components
  private let notificationTitleLabel = UILabel()
  private let notificationDescriptionLabel = UILabel()
  private let modifyButton = UIButton()
  private let separatorView = UIView()
  private let marketingTitleLabel = UILabel()
  private let marketingDescriptionLabel = UILabel()
  private let agreeView = UIView()
  private let agreeLabel = UILabel()
  private let agreeSwitch = UISwitch()
  
  
  // MARK: - Variables
  private final let notificationTitle = "알림설정"
  private final let notificationDescription = "알림을 설정하려면 설정을 변경해주세요."
  private final let modifyButtonText = "변경하기"
  private final let marketingTitle = "마케팅 정보 수신 동의"
  private final let marketingDescription = "ZEEPY의 소식을 가장 먼저 만나보실 수 있어요."
  private final let agreeTitle = "메일 수신동의"
  
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension SettingsViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNotificationTitleLabel()
    layoutNotificationDescriptionLabel()
    layoutModifyButton()
    layoutSeparatorView()
    layoutMarketingTitleLabel()
    layoutMarketingDescriptionLabel()
    layoutAgreeView()
    layoutAgreeLabel()
    layoutAgreeSwitch()
  }
  
  private func layoutNotificationTitleLabel() {
    view.add(notificationTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
        $0.leading.equalTo(self.view.snp.leading).offset(23)
      }
    }
  }
  
  private func layoutNotificationDescriptionLabel() {
    view.add(notificationDescriptionLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.notificationTitleLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.notificationTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutModifyButton() {
    view.add(modifyButton) {
      $0.snp.makeConstraints {
        $0.trailing.equalTo(self.view.snp.trailing).offset(-24)
        $0.centerY.equalTo(self.notificationDescriptionLabel.snp.centerY)
        $0.width.equalTo(44)
        $0.height.equalTo(14)
      }
    }
  }
  
  private func layoutSeparatorView() {
    view.add(separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.top.equalTo(self.notificationDescriptionLabel.snp.bottom).offset(27)
        $0.leading.equalTo(self.view.snp.leading).offset(7)
        $0.centerX.equalToSuperview()
        $0.height.equalTo(1)
      }
    }
  }
  
  private func layoutMarketingTitleLabel() {
    view.add(marketingTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.separatorView.snp.bottom).offset(20)
        $0.leading.equalTo(self.notificationTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutMarketingDescriptionLabel() {
    view.add(marketingDescriptionLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.marketingTitleLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.notificationTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutAgreeView() {
    view.add(agreeView) {
      $0.backgroundColor = .whiteTextField
      $0.snp.makeConstraints {
        $0.top.equalTo(self.marketingDescriptionLabel.snp.bottom).offset(16)
        $0.centerX.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 328/375)
        $0.height.equalTo(self.view.frame.width * 46/375)
      }
    }
  }
  
  private func layoutAgreeLabel() {
    agreeView.add(agreeLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.agreeView.snp.leading).offset(16)
        $0.centerY.equalToSuperview()
      }
    }
  }
  
  private func layoutAgreeSwitch() {
    agreeView.add(agreeSwitch) {
      $0.sizeToFit()
      $0.onTintColor = .orangeyYellow
      $0.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//      $0.onImage = UIImage(named: "toggleOn")
//      $0.offImage = UIImage(named: "toggleOff")
      $0.snp.makeConstraints {
        $0.trailing.equalTo(self.agreeView.snp.trailing).offset(-30)
        $0.centerY.equalToSuperview()
        $0.width.equalTo(26)
        $0.height.equalTo(13)
      }
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    notificationTitleLabel.setupLabel(text: notificationTitle, color: .blackText, font: .nanumRoundExtraBold(fontSize: 16))
    notificationDescriptionLabel.setupLabel(text: notificationDescription, color: .blackText, font: .nanumRoundRegular(fontSize: 12))
    modifyButton.setupButton(title: modifyButtonText, color: .orangeyYellow, font: .nanumRoundExtraBold(fontSize: 12), backgroundColor: .clear, state: .normal, radius: 0)
    marketingTitleLabel.setupLabel(text: marketingTitle, color: .blackText, font: .nanumRoundExtraBold(fontSize: 16))
    marketingDescriptionLabel.setupLabel(text: marketingDescription, color: .blackText, font: .nanumRoundRegular(fontSize: 12))
    agreeLabel.setupLabel(text: agreeTitle, color: .blackText, font: .nanumRoundBold(fontSize: 12))
  }
}
