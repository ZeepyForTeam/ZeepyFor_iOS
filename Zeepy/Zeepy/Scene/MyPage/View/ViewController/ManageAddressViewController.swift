//
//  ManageAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ManageAddressViewController
class ManageAddressViewController: UIViewController {
  
  // MARK: - Lazy Components
  
  // MARK: - Components
  private let addressTitleLabel = UILabel()
  private let addressTableView = UITableView()
  
  // MARK: - Variables
  private var tableViewRowHeight: CGFloat = 94
  private var tableViewRowCount = 1
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
    register()
    setupNavigation()
  }
}

// MARK: - Extensions
extension ManageAddressViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutAddressTitleLabel()
    layoutAddressTableView()
  }
  
  private func layoutAddressTitleLabel() {
    view.add(addressTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
      }
    }
  }
  
  private func layoutAddressTableView() {
    view.add(addressTableView) {
      $0.backgroundColor = .clear
      $0.setRounded(radius: 8)
      $0.separatorStyle = .none
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

  
  // MARK: - General Helpers
  private func register() {
    addressTableView.register(EmptyManageAddressTableViewCell.self,
                              forCellReuseIdentifier: EmptyManageAddressTableViewCell.identifier)
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
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "주소관리")
  }
  func reloadTableView() {
    addressTableView.reloadData()
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
    return self.tableViewRowCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let emptyCell = tableView.dequeueReusableCell(
            withIdentifier: EmptyManageAddressTableViewCell.identifier,
            for: indexPath) as? EmptyManageAddressTableViewCell else {
      return UITableViewCell()
    }
    emptyCell.awakeFromNib()
    return emptyCell
  }
  
  
}
