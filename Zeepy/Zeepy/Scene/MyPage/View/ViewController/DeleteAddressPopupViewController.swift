//
//  DeleteAddressPopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/16.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - DeleteAddressPopupViewController
class DeleteAddressPopupViewController: BaseViewController {
  
  // MARK: - Components
  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let closeButton = UIButton()
  private let deleteButton = UIButton()
  
  // MAARK: - Variables
  var addressModel: ResponseGetAddress?
  var selectedIndex = 100
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  var resultClosure: ((Bool) -> ())?
  private var registerResult: Bool = false
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension DeleteAddressPopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.view.backgroundColor = .popupBackground
    layoutContainerView()
    layoutTitleLabel()
    layoutCloseButton()
    layoutDeleteButton()
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
        $0.leading.equalTo(self.containerView.snp.centerX).offset(5)
        $0.trailing.equalTo(self.containerView.snp.leading).offset(-12)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  private func layoutDeleteButton() {
    containerView.add(deleteButton) {
      $0.addTarget(self,
                   action: #selector(self.deleteButtonClicked),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.bottom.equalTo(self.containerView.snp.bottom).offset(-12)
        $0.trailing.equalTo(self.containerView.snp.centerX).offset(-5)
        $0.leading.equalTo(self.containerView.snp.leading).offset(12)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    titleLabel.setupLabel(text: "정말 삭제하시겠습니까?",
                          color: .blackText,
                          font: .nanumRoundExtraBold(fontSize: 16))
    closeButton.setupButton(title: "취소",
                             color: .white,
                             font: .nanumRoundExtraBold(fontSize: 16),
                             backgroundColor: .pointYellow,
                             state: .normal,
                             radius: 8)
    deleteButton.setupButton(title: "삭제",
                             color: .blackText,
                             font: .nanumRoundExtraBold(fontSize: 16),
                             backgroundColor: .gray249,
                             state: .normal,
                             radius: 8)
  }
  
  private func deleteAddress() {
    addressModel?.addresses.remove(at: self.selectedIndex)
    userService.addAddress(param: self.addressModel ??
                            ResponseGetAddress(addresses: []))
      .subscribe(onNext: { [weak self] result in
        if result {
          do {
            print("delete completed")
            self?.dismiss(animated: true, completion: {
                          self?.registerResult = true
                          if let closure = self?.resultClosure {
                               closure(self?.registerResult == true)
                          }
              
            })
          }
          catch {
            print(error)
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
  private func deleteButtonClicked() {
    deleteAddress()
  }
}
