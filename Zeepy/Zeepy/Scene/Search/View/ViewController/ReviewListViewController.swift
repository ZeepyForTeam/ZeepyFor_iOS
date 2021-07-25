//
//  ReviewListViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReviewListViewController : BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    layout()
    dummy()
  }
  
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "건물리뷰")
  }
  private let tableView = UITableView()
}
extension ReviewListViewController {
  private func setupTableView() {
    self.tableView.backgroundColor = .white
    self.tableView.separatorStyle = .none
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 281
    
    self.tableView.register(SimpleReviewView.self,
                            forCellReuseIdentifier: SimpleReviewView.identifier)
  }
  private func layout() {
    self.view.adds([naviView, tableView])
    naviView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    tableView.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-16)
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(naviView.snp.bottom).offset(16)
    }
  }
  private func dummy() {
    let temp = Observable.just([0,1,2,3,4,5])
    temp.bind(to: tableView.rx.items(cellIdentifier: SimpleReviewView.identifier,
                                     cellType: SimpleReviewView.self)) {row, data, cell in
      cell.dummy()
    }.disposed(by: disposeBag)
    tableView.rx.modelSelected(Int.self).bind{[weak self] _ in
      let vc = DetailReviewViewContoller()
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
  }
}
