//
//  LookAroundViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
final class LookAroundViewController: BaseViewController {
  private let headerView: UIView = {
    let v = UIView()
    v.backgroundColor = .white
    return v
  }()
  private let currentLocation = UILabel()
  private let locationDropDown = UIButton()
  private let filterButton = UIButton()
  private let mapButton = UIButton()
  private var tableViewHeader: UICollectionView!
  private let tableView = UITableView()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    layout()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpNavigation()
  }
}
extension LookAroundViewController {
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.minimumLineSpacing = 4
    self.tableViewHeader = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.tableViewHeader.register(tableViewHeaderCollectionViewCell.self,
                                  forCellWithReuseIdentifier: tableViewHeaderCollectionViewCell.identifier)
    self.tableViewHeader.backgroundColor = .white
  }
  private func setupTableView() {
    self.tableView.backgroundColor = .white
  }
  private func layout() {
    self.view.adds([headerView,tableViewHeader,tableView])
    
    headerView.snp.makeConstraints{
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(60)
    }
    tableViewHeader.snp.makeConstraints{
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(44)
    }
    tableView.snp.makeConstraints{
      $0.top.equalTo(tableViewHeader.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    headerView.adds([currentLocation,
                     locationDropDown,
                     filterButton,
                     mapButton])
    currentLocation.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    locationDropDown.snp.makeConstraints{
      $0.height.width.equalTo(24)
      $0.leading.equalTo(currentLocation.snp.trailing)
      $0.centerY.equalTo(currentLocation)
    }
    mapButton.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16)
      $0.width.height.equalTo(24)
    }
    filterButton.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(mapButton.snp.leading).offset(-4)
      $0.width.height.equalTo(24)
    }
  }
}
extension LookAroundViewController {
  func setUpNavigation() {
    guard let navigationBar = navigationController?.navigationBar else { return }
    let title = UILabel().then {
      $0.adjustsFontSizeToFitWidth = true
      $0.font = .nanumRoundExtraBold(fontSize: 20)
      $0.text = "둘러보기"
      $0.textColor = .blackText
      
    }
    let customV = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: navigationBar.bounds.width - 60.0 * 2.0, height: navigationBar.bounds.height)))
    
    self.tabBarController?.navigationItem.titleView = title
  }
}
