//
//  ManageReviewViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ManageReviewViewController
class ManageReviewViewController: UIViewController {

  // MARK: - Components
  private let addressTitleLabel = UILabel()
  private let reviewTableView = UITableView()
  
  // MARK: - Variables
  private var tableViewRowHeight: CGFloat = 116
  private var tableViewRowCount = 3
  
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
    register()
    setupNavigation()
  }
  
  override func viewWillLayoutSubviews() {
    super.updateViewConstraints()
    reviewTableView.snp.updateConstraints {
      $0.height.equalTo(self.reviewTableView.contentSize.height)
    }
  }
}

// MARK: - Extensions
extension ManageReviewViewController {
  
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
    view.add(reviewTableView) {
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
    reviewTableView.register(ManageReviewTableViewCell.self,
                              forCellReuseIdentifier: ManageReviewTableViewCell.identifier)
    reviewTableView.delegate = self
    reviewTableView.dataSource = self
  }
  
  private func configData() {
    self.addressTitleLabel.setupLabel(text: "현재 등록된 주소",
                                      color: .blackText,
                                      font: .nanumRoundExtraBold(fontSize: 16),
                                      align: .left)
  }
  
  private func setupNavigation() {
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "리뷰 관리")
  }
  
  func reloadTableView() {
    reviewTableView.reloadData()
  }
}

// MARK: - reviewTableView Delegate
extension ManageReviewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - reviewTableView DataSource
extension ManageReviewViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableViewRowCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let reviewCell = tableView.dequeueReusableCell(
            withIdentifier: ManageReviewTableViewCell.identifier,
            for: indexPath) as? ManageReviewTableViewCell else {
      return UITableViewCell()
    }
    reviewCell.awakeFromNib()
    return reviewCell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    self.viewWillLayoutSubviews()
  }
  
}
