//
//  AddressLimitPopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/09.
//

import UIKit

import SnapKit
import Then

// MARK: - AddressLimitPopupViewController
class AddressLimitPopupViewController: UIViewController {
  
  // MARK: - Components
  private let cardView = UIView()
  private let messageLabel = UILabel()
  private let confirmButton = UIButton()
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
}

// MARK: - Extensions
extension AddressLimitPopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.view.backgroundColor = .popupBackground
    layoutCardView()
    layoutMessageLabel()
    layoutConfirmButton()
  }
  
  private func layoutCardView() {
    view.add(cardView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: 10)
      $0.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.centerX.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 288/375)
        $0.height.equalTo(self.view.frame.width * 186/375)
      }
    }
  }
  private func layoutMessageLabel() {
    cardView.add(messageLabel) {
      $0.numberOfLines = 2
      $0.setupLabel(text: "최대 3개의 주소까지만\n 등록이 가능해요!", color: .blackText, font: .nanumRoundExtraBold(fontSize: 16))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(46)
      }
    }
  }
  
  private func layoutConfirmButton() {
    cardView.add(confirmButton) {
      $0.setupButton(title: "확인", color: .white, font: .nanumRoundExtraBold(fontSize: 16), backgroundColor: .mainBlue, state: .normal, radius: 8)
      $0.addTarget(self, action: #selector(self.clickedConfirmButton), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalToSuperview().offset(-16)
        $0.width.equalTo(self.view.frame.width * 256/375)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func clickedConfirmButton() {
    self.dismiss(animated: true, completion: nil)
  }
}
