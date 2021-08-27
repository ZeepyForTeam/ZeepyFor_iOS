//
//  ManageAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - ManageAddressViewController
class ManageAddressViewController: BaseViewController {
  
  // MARK: - Lazy Components
  private lazy var addressTableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let addressTitleLabel = UILabel()
  
  // MARK: - Variables
  private let userService = UserService(provider: MoyaProvider<UserRouter>())
  
  private var tableViewRowHeight: CGFloat = 94
  private var tableViewRowCount = 1
  private var addressModel: ResponseGetAddress?
  var selectedIndex = 100
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
    register()
    setupNavigation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchAddress()
  }
}

// MARK: - Extensions
extension ManageAddressViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutAddressTitleLabel()
    layoutAddressTableView()
  }
  
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func layoutAddressTitleLabel() {
    view.add(addressTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.navigationView.snp.bottom).offset(24)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
      }
    }
  }
  
  private func layoutAddressTableView() {
    view.add(addressTableView) {
      $0.backgroundColor = .clear
      $0.setRounded(radius: 8)
      $0.separatorStyle = .none
      $0.isScrollEnabled = false
      $0.estimatedRowHeight = 94
      $0.rowHeight = UITableView.automaticDimension
      $0.snp.makeConstraints {
        $0.top.equalTo(self.addressTitleLabel.snp.bottom).offset(16)
        $0.leading.equalTo(self.addressTitleLabel.snp.leading)
        $0.centerX.equalToSuperview()
        $0.height.equalTo(Int(self.tableViewRowHeight) * self.tableViewRowCount)
      }
    }
  }
  
  private func relayoutAddressTableView() {
    addressTableView.snp.remakeConstraints {
      $0.leading.equalTo(self.addressTitleLabel.snp.leading)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.addressTitleLabel.snp.bottom).offset(16)
      $0.height.equalTo((self.addressModel?.addresses.count ?? 0) * 94)
    }
  }

  
  // MARK: - General Helpers
  private func register() {
    addressTableView.register(
      EmptyManageAddressTableViewCell.self,
      forCellReuseIdentifier: EmptyManageAddressTableViewCell.identifier)
    
    addressTableView.register(
      ManageAddressTableViewCell.self,
      forCellReuseIdentifier: ManageAddressTableViewCell.identifier)
    
    addressTableView.delegate = self
    addressTableView.dataSource = self
  }
  
  private func configData() {
    self.addressTitleLabel.setupLabel(text: "현재 등록된 주소",
                                      color: .blackText,
                                      font: .nanumRoundExtraBold(fontSize: 16),
                                      align: .left)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "주소 관리")
  }
  
  func modalPopupView() {
    let popupView = DeleteAddressPopupViewController()
    popupView.modalPresentationStyle = .overFullScreen
    popupView.selectedIndex = selectedIndex
    popupView.resultClosure = { result in
      weak var `self` = self
      if result {
        self?.fetchAddress()
      }
    }
    popupView.addressModel = addressModel
    self.present(popupView, animated: true, completion: nil)
  }
  
  func reloadTableView() {
    addressTableView.reloadData()
  }
  
  private func fetchAddress() {
    userService.getAddress()
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ResponseGetAddress.self,
                                          from: response.data)
            self.addressModel = data
            if self.addressModel?.addresses != [] {
              self.relayoutAddressTableView()
            }
            self.reloadTableView()
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
  func registerButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = SearchAddressViewController()
    nextViewController.userAddressModel =
      addressModel ?? ResponseGetAddress(addresses: [])
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: true)
  }
}

// MARK: - addressTableView Delegate
extension ManageAddressViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - addressTableView DataSource
extension ManageAddressViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: Int = 1
    if addressModel?.addresses.isEmpty == false {
      count = (addressModel?.addresses.count) ?? 0
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let emptyCell = tableView.dequeueReusableCell(
            withIdentifier: EmptyManageAddressTableViewCell.identifier,
            for: indexPath) as? EmptyManageAddressTableViewCell else {
      return UITableViewCell()
    }
    
    guard let addressCell = tableView.dequeueReusableCell(
            withIdentifier: ManageAddressTableViewCell.identifier,
            for: indexPath) as? ManageAddressTableViewCell else {
      return UITableViewCell()
    }
    if addressModel?.addresses == [] ||
        addressModel?.addresses == nil {
      emptyCell.awakeFromNib()
      emptyCell.rootViewController = self
      return emptyCell
    }
    else {
      addressCell.awakeFromNib()
      let address = addressModel?.addresses[indexPath.row]
      addressCell.addressLabel.text = "\(address?.cityDistinct ?? "") \(address?.primaryAddress ?? "")"
      addressCell.rootViewController = self
      addressCell.index = indexPath.row
      return addressCell
    }
  }
  
  
}
