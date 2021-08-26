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
    bind()
  }
  init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, reviews: [ReviewResponses]) {
    self.models = reviews
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private var models: [ReviewResponses]!
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
  private func bind() {
    Observable.just(models)
      .bind(to: tableView.rx.items(cellIdentifier: SimpleReviewView.identifier,
                                     cellType: SimpleReviewView.self)) {[weak self] row, data, cell in
      cell.bind(model: data)
        cell.reportBtn.rx.tap
          .takeUntil(cell.rx.methodInvoked(#selector(UITableViewCell.prepareForReuse)))
          .bind{[weak self] in
          let vc = ReportViewController()
          guard
            let userid = UserDefaultHandler.userId
          else {return}

          vc.reportModel.reportUser = userid
          self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by:cell.disposeBag)
        cell.content.reviewDirectBtn.rx.tap
          .takeUntil(cell.rx.methodInvoked(#selector(UITableViewCell.prepareForReuse)))
          .bind{[weak self] in
          let vc = SelectAddressViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
          }.disposed(by: cell.disposeBag)
    }.disposed(by: disposeBag)
    tableView.rx.modelSelected(ReviewResponses.self).bind{[weak self] model in
      guard let vc = DetailReviewViewContoller(nibName: nil, bundle: nil, reviewId: model.id) else {return}
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
  }
}
