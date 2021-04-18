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
  
  private let currentLocation = UILabel().then{
    $0.adjustsFontSizeToFitWidth = true
    $0.font = .nanumRoundExtraBold(fontSize: 20)
    $0.text = "한강로동 2가"
    $0.textColor = .blackText
  }
  private let locationDropDown = UIButton().then{
    $0.setImage(UIImage(named: ""), for: .normal)
  }
  private let filterButton = UIButton().then{
    $0.setNormalImage(name: "iconFilter")
  }
  private let mapButton = UIButton().then{
    $0.setNormalImage(name: "iconMap")
  }
  private var tableViewHeader: UICollectionView!
  private let tableView = UITableView()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    setupCollectionView()
    layout()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.navigationController?.isNavigationBarHidden = false


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
      $0.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
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
}
