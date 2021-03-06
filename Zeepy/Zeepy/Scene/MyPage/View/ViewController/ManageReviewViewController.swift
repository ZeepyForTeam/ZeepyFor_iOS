//
//  ManageReviewViewController.swift
//  Zeepy
//
//  Created by λΈνμ on 2021/07/23.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - ManageReviewViewController
class ManageReviewViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let addressTitleLabel = UILabel()
  private let reviewTableView = UITableView()
  
  // MARK: - Variables
  private var tableViewRowHeight: CGFloat = 116
  private var tableViewRowCount = 3
  private var reviewService = ReviewService(provider: MoyaProvider<ReviewRouter>(
                                              plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  private var reviewModel: UserReviewResponseModel?
  
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    configData()
    layout()
    register()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchReview()
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
        $0.height.equalTo(18)
      }
    }
  }
  
  private func layoutAddressTableView() {
    view.add(reviewTableView) {
      $0.backgroundColor = .clear
      $0.setRounded(radius: 8)
      $0.separatorStyle = .none
      $0.estimatedRowHeight = 140
      $0.rowHeight = UITableView.automaticDimension
      $0.snp.makeConstraints {
        $0.top.equalTo(self.addressTitleLabel.snp.bottom).offset(16)
        $0.leading.equalTo(self.addressTitleLabel.snp.leading)
        $0.centerX.equalToSuperview()
        $0.height.equalTo(Int(self.tableViewRowHeight) * self.tableViewRowCount)
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      }
    }
  }
  
  
  // MARK: - General Helpers
  private func register() {
    reviewTableView.register(ManageReviewTableViewCell.self,
                             forCellReuseIdentifier: ManageReviewTableViewCell.identifier)
    reviewTableView.register(EmptyManageAddressTableViewCell.self,
                             forCellReuseIdentifier: EmptyManageAddressTableViewCell.identifier)
    reviewTableView.delegate = self
    reviewTableView.dataSource = self
  }
  
  private func configData() {
    self.addressTitleLabel.setupLabel(text: "λ΄κ° μμ±ν λ¦¬λ·°",
                                      color: .blackText,
                                      font: .nanumRoundExtraBold(fontSize: 16),
                                      align: .left)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "λ¦¬λ·° κ΄λ¦¬")
  }
  
  func reloadTableView() {
    reviewTableView.reloadData()
  }
  
  private func convertData(data: String) -> String {
    switch data {
    case "MALE":
      return "λ¨μ"
    case "FEMALE":
      return "μ¬μ"
    case "TWENTY":
      return "20λ"
    case "THIRTY":
      return "30λ"
    case "FOURTY":
      return "40λ"
    case "FIFTY":
      return "50λ"
    case "SIXTY":
      return "60λ μ΄μ"
    case "UNKNOWN":
      return "λμ΄λ λͺ¨λ₯΄κ² μ§λ§"
    default:
      return ""
    }
  }
  
  private func convertOptionData(data: String) -> String {
    switch data {
    case "GOOD":
      return "iconSmile"
    case "PROPER":
      return "iconSoso"
    case "BAD":
      return "iconAngry"
    default:
      return ""
    }
  }
  
  private func converTendencyData(data: String) -> String {
    switch data {
    case "BUSINESS":
      return "μΉΌ κ°μ μ°λ¦¬ μ¬μ΄, λΉμ¦λμ€ν"
    case "KIND":
      return "λ°λ»ν΄ λΉμλ΄λ¦¬λ μ€! μΉμ ν"
    case "GRAZE":
      return "μμ λ‘­κ²λ§ μ΄μλ€μ€, λ°©λͺ©ν"
    case "SOFTY":
      return "κ²μ λ°μ­ μμ μ΄μ΄! μΈ€λ°λ ν"
    case "BAD":
      return "ν λ§μ λ§μ§λ§ νμ§ μμλμ :("
    default:
      return ""
    }
  }
  
  private func fetchReview() {
    reviewService.getUserReviews()
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(UserReviewResponseModel.self,
                                          from: response.data)
            
            self.reviewModel = data
            self.reviewTableView.reloadData()
          }
          catch {
            print(error)
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  func registerButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = SelectAddressViewController()
    nextViewController.hidesBottomBarWhenPushed = true
    navigation?.pushViewController(nextViewController, animated: true)
  }
  
  func selectCell(reviewID: Int) {
    let navigation = self.navigationController
    guard let nextViewController = DetailReviewViewContoller(nibName: nil, bundle: nil, reviewId: reviewID) else { return }
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: true)
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
    var count: Int = 1
    if reviewModel?.simpleReviewDtoList.isEmpty == false {
      count = (reviewModel?.simpleReviewDtoList.count) ?? 0
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
            withIdentifier: ManageReviewTableViewCell.identifier,
            for: indexPath) as? ManageReviewTableViewCell else {
      return UITableViewCell()
    }
    
    if reviewModel?.simpleReviewDtoList.isEmpty == true ||
        reviewModel?.simpleReviewDtoList == nil {
      emptyCell.awakeFromNib()
      emptyCell.contextLabel.text = "μμ§ μμ±ν λ¦¬λ·°κ° μμ΄μ. :("
      emptyCell.rootViewController = self
      return emptyCell
    }
    
    else {
      reviewCell.awakeFromNib()
      let review = self.reviewModel?.simpleReviewDtoList[indexPath.row]
      let dateText: [Substring] = review?.reviewDate.split(separator: "T") ?? [""]
      reviewCell.dataBind(address: review?.apartmentName ?? "",
                          date: String(dateText[0]),
                          lender: "\(convertData(data: review?.lessorAge ?? "")) \(convertData(data: "MALE"))λ‘ λ³΄μ¬μ",
                          tendency: converTendencyData(data: review?.communcationTendency ?? ""),
                          sound: convertOptionData(data: review?.soundInsulation ?? ""),
                          bug: convertOptionData(data: review?.pest ?? ""),
                          light: convertOptionData(data: review?.lightning ?? ""),
                          water: convertOptionData(data: review?.waterPressure ?? ""))
      return reviewCell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    self.viewWillLayoutSubviews()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let reviewID = self.reviewModel?.simpleReviewDtoList[indexPath.row].id
    if let id = reviewID {
      print(id)
      selectCell(reviewID: id)
    }
  }
}
