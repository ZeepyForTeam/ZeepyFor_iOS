//
//  LessorAgePopupViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/14.
//

import UIKit

import SnapKit
import Then

// MARK: - LessorAgePopupViewController
class LessorAgePopupViewController: BaseViewController {
  
  // MARK: - Components
  private lazy var ageTableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  // MARK: - Components
  private let containerView = UIView()
  var resultClosure: ((String, String) -> ())?
  private var registerResult: (String, String)?
  
  // MARK: - Variables
  private let ages = [("20대", "TWENTY", "20"),
                      ("30대", "THIRTY", "30"),
                      ("40대", "FOURTY", "40"),
                      ("50대", "FIFTY", "50"),
                      ("60대 이상", "SIXTY", "60+"),
                      ("알 수 없음", "UNKNOWN", "-")]
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    register()
  }
}

// MARK: - Extensions
extension LessorAgePopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.view.backgroundColor = .popupBackground
    layoutContainerView()
    layoutAgeTableView()
  }
  
  private func layoutContainerView() {
    view.add(containerView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: 16)
      $0.snp.makeConstraints {
        $0.bottom.trailing.leading.equalToSuperview()
        $0.height.equalTo(self.ages.count * 38 + 12 + 34)
      }
    }
  }
  
  private func layoutAgeTableView() {
    containerView.add(ageTableView) {
      $0.backgroundColor = .white
      $0.isScrollEnabled = false
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(self.containerView.snp.bottom).offset(-34)
        $0.top.equalTo(self.containerView.snp.top).offset(12)
      }
    }
  }
  
  // MARK: - General Helpers
  private func register() {
    ageTableView.register(LessorAgeTableViewCell.self,
                          forCellReuseIdentifier: LessorAgeTableViewCell.identifier)
    
    ageTableView.delegate = self
    ageTableView.dataSource = self
  }
}

// MARK: - ageTableView Delegate
extension LessorAgePopupViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 38
  }
}

// MARK: - ageTableView DataSource
extension LessorAgePopupViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let ageCell = tableView.dequeueReusableCell(
            withIdentifier: LessorAgeTableViewCell.identifier,
            for: indexPath) as? LessorAgeTableViewCell else {
      return UITableViewCell()}
    ageCell.awakeFromNib()
    ageCell.dataBind(age: self.ages[indexPath.row].0)
    return ageCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.dismiss(animated: true, completion: {
      self.registerResult = (self.ages[indexPath.row].2, self.ages[indexPath.row].1)
      if let closure = self.resultClosure {
        guard let result = self.registerResult else { return }
        closure(result.0,result.1)
      }
    })
  }
}
