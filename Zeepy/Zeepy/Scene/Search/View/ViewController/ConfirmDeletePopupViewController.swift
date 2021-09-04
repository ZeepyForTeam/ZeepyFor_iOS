//
//  ConfirmDeletePopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/09.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - ConfirmDeletePopupViewController
class ConfirmDeletePopupViewController: BaseViewController {
  
  // MARK: - Components
  private let cardView = UIView()
  private let messageLabel = UILabel()
  private let deleteButton = UIButton()
  private let cancelButton = UIButton()
  
  // MARK: - Variables
  var selectedIndex = 100
  var addressModel: ResponseGetAddress?
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  var resultClosure: ((Bool) -> ())?
  private var registerResult: Bool = false
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
}

// MARK: - Extensions
extension ConfirmDeletePopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.view.backgroundColor = .popupBackground
    layoutCardView()
    layoutMessageLabel()
    layoutDeleteButton()
    layoutCancelButton()
  }
  
  private func layoutCardView() {
    view.add(cardView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: 10)
      $0.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.centerX.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 288/375)
        $0.height.equalTo(self.view.frame.width * 171/375)
      }
    }
  }
  
  private func layoutMessageLabel() {
    cardView.add(messageLabel) {
      $0.setupLabel(text: "정말 삭제하시겠습니까?", color: .blackText, font: .nanumRoundExtraBold(fontSize: 16))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(46)
      }
    }
  }
  
  private func layoutDeleteButton() {
    cardView.add(deleteButton) {
      $0.setupButton(title: "삭제", color: .mainBlue, font: .nanumRoundExtraBold(fontSize: 14), backgroundColor: .gray249, state: .normal, radius: 8)
      $0.addTarget(self, action: #selector(self.clickedDeleteButton), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.trailing.equalTo(self.cardView.snp.centerX).offset(-5)
        $0.leading.equalToSuperview().offset(16)
        $0.bottom.equalToSuperview().offset(-16)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }

  private func layoutCancelButton() {
    cardView.add(cancelButton) {
      $0.setupButton(title: "취소", color: .white, font: .nanumRoundExtraBold(fontSize: 14), backgroundColor: .mainBlue, state: .normal, radius: 8)
      $0.addTarget(self, action: #selector(self.clickedCancelButton), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.cardView.snp.centerX).offset(5)
        $0.trailing.equalToSuperview().offset(-16)
        $0.bottom.equalToSuperview().offset(-16)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  private func addAddress() {
    userService.addAddress(param: self.addressModel ?? ResponseGetAddress(addresses: []))
      .subscribe(onNext: { [weak self] result in
        if result {
          do {
            UserManager.shared.fetchUserAddress()

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
  private func clickedDeleteButton() {
    addressModel?.addresses.remove(at: selectedIndex)
    addAddress()
  }
  
  @objc
  private func clickedCancelButton() {
    self.dismiss(animated: true, completion: nil)
  }
}
