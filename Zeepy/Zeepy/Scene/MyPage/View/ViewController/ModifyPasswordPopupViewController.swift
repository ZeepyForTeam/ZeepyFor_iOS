//
//  ModifyPasswordPopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/24.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - ModifyPasswordPopupViewController
class ModifyPasswordPopupViewController: BaseViewController {
  
  // MARK: - Components
  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let closeButton = UIButton()
  private let modifyButton = UIButton()
  
  // MARK: - Variables
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  var passwordModel = RequestModifyPassword(password: " ")
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension ModifyPasswordPopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.view.backgroundColor = .popupBackground
    layoutContainerView()
    layoutTitleLabel()
    layoutCloseButton()
    layoutModifyButton()
  }
  
  private func layoutContainerView() {
    view.add(containerView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: 10)
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 286/375)
        $0.height.equalTo(self.view.frame.width * 178/375)
      }
    }
  }
  
  private func layoutTitleLabel() {
    containerView.add(titleLabel) {
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(self.containerView.snp.centerY).offset(-20)
      }
    }
  }
  private func layoutCloseButton() {
    containerView.add(closeButton) {
      $0.addTarget(self,
                   action: #selector(self.closeButtonClicked),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.bottom.equalTo(self.containerView.snp.bottom).offset(-12)
        $0.trailing.equalTo(self.containerView.snp.centerX).offset(-5)
        $0.leading.equalTo(self.containerView.snp.leading).offset(12)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  private func layoutModifyButton() {
    containerView.add(modifyButton) {
      $0.addTarget(self,
                   action: #selector(self.modifyButtonClicked),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.bottom.equalTo(self.containerView.snp.bottom).offset(-12)
        $0.leading.equalTo(self.containerView.snp.centerX).offset(5)
        $0.trailing.equalTo(self.containerView.snp.trailing).offset(-12)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    titleLabel.setupLabel(text: "새로운 비밀번호로 변경합니다",
                          color: .blackText,
                          font: .nanumRoundExtraBold(fontSize: 16))
    
    closeButton.setupButton(title: "취소",
                             color: .pointYellow,
                             font: .nanumRoundExtraBold(fontSize: 16),
                             backgroundColor: .gray244,
                             state: .normal,
                             radius: 8)
    
    modifyButton.setupButton(title: "비밀번호 변경",
                             color: .white,
                             font: .nanumRoundExtraBold(fontSize: 16),
                             backgroundColor: .pointYellow,
                             state: .normal,
                             radius: 8)
  }
  
  private func modifyPassword() {
    userService.modifyPassword(param: passwordModel)
      .subscribe(onNext: {[weak self] response in
        if (200...300).contains(response.statusCode) {
          do {
            print("success")
            self?.dismiss(animated: true, completion: nil)
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  // MARK: - Action Helpers
  @objc
  private func closeButtonClicked() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func modifyButtonClicked() {
    modifyPassword()
  }
}
