//
//  ManageReviewViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/24.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - FavoriteListViewConroller
class FavoriteListViewConroller: BaseViewController {

  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let addressTitleLabel = UILabel()
  private let reviewTableView = UITableView()
  
  // MARK: - Variables
  private var tableViewRowHeight: CGFloat = 116
  private var tableViewRowCount = 3
  private var userLikeModel: BuildingUserLikeResponseModel?
  private var buildingService = BuildingService(
    provider: MoyaProvider<BuildingRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
    register()
    setupNavigation()
  }
  
//  override func viewWillLayoutSubviews() {
//    super.updateViewConstraints()
//    reviewTableView.snp.updateConstraints {
//      $0.height.equalTo(self.reviewTableView.contentSize.height)
//    }
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchBuildingsUserLike()
  }
}

// MARK: - Extensions
extension FavoriteListViewConroller {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutAddressTitleLabel()
    layoutAddressTableView()
  }
  
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self,
                           action: #selector(self.backButtonClicked),
                           for: .touchUpInside)
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
        $0.height.equalTo(20)
      }
    }
  }
  
  private func layoutAddressTableView() {
    view.add(reviewTableView) {
      $0.backgroundColor = .clear
      $0.setRounded(radius: 8)
      $0.separatorStyle = .none
      $0.estimatedRowHeight = 108
      $0.rowHeight = UITableView.automaticDimension
      $0.snp.makeConstraints {
        $0.top.equalTo(self.addressTitleLabel.snp.bottom).offset(16)
        $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo((self.userLikeModel?.content.count ?? 1) * 108)
      }
    }
  }

  
  // MARK: - General Helpers
  private func register() {
    reviewTableView.register(FavoriteListTableViewCell.self,
                              forCellReuseIdentifier: FavoriteListTableViewCell.identifier)
    reviewTableView.register(EmptyManageAddressTableViewCell.self,
                             forCellReuseIdentifier: EmptyManageAddressTableViewCell.identifier)
    reviewTableView.delegate = self
    reviewTableView.dataSource = self
  }
  
  private func configData() {
    self.addressTitleLabel.setupLabel(text: "내가 찜한 자취방",
                                      color: .blackText,
                                      font: .nanumRoundExtraBold(fontSize: 16),
                                      align: .left)
  }
  
  private func setupNavigation() {
    self.navigationView.naviTitle.text = "찜 목록"
  }
  
  func reloadTableView() {
    reviewTableView.reloadData()
  }
  
  private func fetchBuildingsUserLike() {
    buildingService.fetchBuildingUserLike()
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(BuildingUserLikeResponseModel.self,
                                          from: response.data)
            
            self.userLikeModel = data
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
  
  private func setupTendency(review: [ReviewUserLike]?) -> (String, String) {
    if review == nil || review?.isEmpty == true {
      return ("emoji5", "미지의 인물형")
    }
    else {
      var tendency = [0,0,0,0,0]
      for element in review! {
        switch element.communcationTendency {
        case "BUSINESS":
          tendency[0] += 1
        case "KIND":
          tendency[1] += 1
        case "GRAZE":
          tendency[2] += 1
        case "SOFTY":
          tendency[3] += 1
        case "BAD":
          tendency[4] += 1
        default:
          print("unknown tendency")
        }
      }
      switch judgeTendencyTop(judgee: tendency) {
      case "BUSINESS":
        return ("emoji1", "비즈니스형")
      case "KIND":
        return ("emoji2", "친절형")
      case "GRAZE":
        return ("emoji3", "방목형")
      case "SOFTY":
        return ("emoji4", "츤데레형")
      case "BAD":
        return ("emoji5", "할말하않")
      default:
        return ("", "")
      }
    }
    
  }
  
  private func judgeTendencyTop(judgee: [Int]) -> String {
    var top = 0
    for i in 1..<judgee.count {
      if judgee[i] > judgee[top] {
        top = i
      }
    }
    switch top {
    case 0:
      return "BUSINESS"
    case 1:
      return "KIND"
    case 2:
      return "GRAZE"
    case 3:
      return "SOFTY"
    case 4:
      return "BAD"
    default:
      return "UNKNOWN"
    }
  }

  private func setupEvaluation(review: [ReviewUserLike]?) -> String {
    if review == nil || review?.isEmpty == true {
      return "아직 작성된 리뷰가 없어요"
    }
    else {
      var evaluation = [0,0,0]
      for element in review! {
        switch element.totalEvaluation {
        case "GOOD":
          evaluation[0] += 1
        case "SOSO":
          evaluation[1] += 1
        case "BAD":
          evaluation[2] += 1
        default:
          print("unknown evaluation")
        }
      }
      switch judgeEvaluationTop(judgee: evaluation) {
      case "GOOD":
        return "다음에도 여기 살고 싶어요!"
      case "SOSO":
        return "완전 추천해요!"
      case "BAD":
        return "그닥 추천하지 않아요."
      default:
        return ""
      }
    }
  }
  
  private func judgeEvaluationTop(judgee: [Int]) -> String {
    var top = 0
    for i in 1..<judgee.count {
      if judgee[i] > judgee[top] {
        top = i
      }
    }
    switch top {
    case 0:
      return "GOOD"
    case 1:
      return "SOSO"
    case 2:
      return "BAD"
    default:
      return "UNKNOWN"
    }
  }
  
  private func setupReviewImage(review: [ReviewUserLike]?) -> String {
    if review == nil || review?.isEmpty == true {
      return "AppIcon"
    }
    else {
      if review![0].imageUrls == nil || review![0].imageUrls?.isEmpty == true {
        return "AppIcon"
      }
      else {
        return review![0].imageUrls![0]
      }
    }
  }
  private func assembleRoomCount(review: [ReviewUserLike]) -> Set<String> {
    var roomCountSet: Set<String> = Set<String>()
    for element in review {
      roomCountSet.insert(element.roomCount)
    }
    return roomCountSet
  }
  
  func registerButtonClicked() {
    self.tabBarController?.selectedIndex = 2
  }
  
  func didSelectCell(buildingID: Int) {
    let navigation = self.navigationController
    guard let nextViewController = LookAroundDetailViewController(nibName: nil, bundle: nil, model: buildingID) else { return }
    nextViewController.hidesBottomBarWhenPushed = true
    navigation?.pushViewController(nextViewController, animated: true)
  }
}

// MARK: - reviewTableView Delegate
extension FavoriteListViewConroller: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - reviewTableView DataSource
extension FavoriteListViewConroller: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: Int = 1
    if userLikeModel?.content.isEmpty == false {
      count = (userLikeModel?.content.count) ?? 0
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let emptyCell = tableView.dequeueReusableCell(
            withIdentifier: EmptyManageAddressTableViewCell.identifier,
            for: indexPath) as? EmptyManageAddressTableViewCell else {
      return UITableViewCell()
    }
    
    guard let reviewCell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteListTableViewCell.identifier,
            for: indexPath) as? FavoriteListTableViewCell else {
      return UITableViewCell()
    }
    
    if userLikeModel?.content.isEmpty == true ||
        userLikeModel?.content == nil {
      emptyCell.awakeFromNib()
      emptyCell.contextLabel.text = "아직 찜한 자취방이 없어요. :("
      emptyCell.rootViewController = self
      return emptyCell
    }
    else {
      let model = userLikeModel?.content[indexPath.row]
      reviewCell.dataBind(apartmentName: model?.apartmentName ?? "",
                          tendencyImageName: setupTendency(review: model?.reviews ?? []).0,
                          tendency: setupTendency(review: model?.reviews ?? []).1,
                          totalEvaluation: setupEvaluation(review: model?.reviews ?? []),
                          buildingImageURL: setupReviewImage(review: model?.reviews ?? []),
                          roomCount: assembleRoomCount(review: model?.reviews ?? []),
                          buildingType: model?.buildingType ?? "")
      reviewCell.awakeFromNib()
      return reviewCell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    self.viewWillLayoutSubviews()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let buildingID = self.userLikeModel?.content[indexPath.row].id
    if let id = buildingID {
      self.didSelectCell(buildingID: id)
    }
  }
}
