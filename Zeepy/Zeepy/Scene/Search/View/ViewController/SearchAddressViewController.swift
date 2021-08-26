//
//  SearchAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/02.
//

import UIKit

import Moya
import RxSwift
import SnapKit
import Then

// MARK: - SearchAddressViewController
class SearchAddressViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let titleLabel = UILabel()
  private let searchTextFieldContainerView = UIView()
  private let searchTextField = UITextField()
  private let searchButton = UIButton()
  private let nextButton = UIButton()
  private let separatorView = UIView()
  private let addressTableView = UITableView()
  
  // MARK: - Variables
  private var addressModel: SearchAddressModel?
  var userAddressModel: ResponseGetAddress = ResponseGetAddress(addresses: [])
  private final let tableViewRowHeight: CGFloat = 81
  private let buildingService = BuildingService(
    provider: MoyaProvider<BuildingRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
    
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
    register()
    setupNavigation()
  }

}
// MARK: - Extensions
extension SearchAddressViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutTitleLabel()
    layoutSearchTextFieldContainerView()
    layoutSearchTextField()
    layoutSearchButton()
    layoutAddressTableView()
  }
  
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func layoutTitleLabel() {
    self.view.add(titleLabel) {
      $0.text = "주소 검색"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(19)
      }
    }
  }
  
  private func layoutSearchTextFieldContainerView() {
    self.view.add(searchTextFieldContainerView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
        $0.height.equalTo(32)
      }
    }
  }
  
  private func layoutSearchTextField() {
    let placeholderText = NSMutableAttributedString(
      string: "주소를 입력해주세요",
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 12),
                   .foregroundColor: UIColor.grayText])
    
    let searchIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 37.5, height: 16))
    searchIconContainerView.backgroundColor = .clear
    let searchIconImageView = UIImageView(image: UIImage(named: "iconSearch"))
    searchIconImageView.frame = CGRect(x: 12.5, y: 0, width: 16, height: 16)
    searchIconContainerView.add(searchIconImageView)
    self.searchTextFieldContainerView.add(self.searchTextField) {
      $0.attributedPlaceholder = placeholderText
      $0.setBorder(borderColor: .mainBlue, borderWidth: 1)
      $0.setRounded(radius: 16)
      $0.leftView = searchIconContainerView
      $0.leftViewMode = .always
      $0.font = UIFont.nanumRoundRegular(fontSize: 12)
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.searchTextFieldContainerView.snp.edges)
      }
    }
  }
  
  private func layoutSearchButton() {
    searchTextFieldContainerView.add(searchButton) {
      $0.setTitle("검색", for: .normal)
      $0.setTitleColor(.mainBlue, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 12)
      $0.backgroundColor = .clear
      $0.addTarget(self,
                   action: #selector(self.searchButtonClicked),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.searchTextFieldContainerView.snp.top)
        $0.bottom.equalTo(self.searchTextFieldContainerView.snp.bottom)
        $0.trailing.equalTo(self.searchTextFieldContainerView.snp.trailing)
        $0.width.equalTo(self.view.frame.width*60/375)
      }
    }
  }

  private func layoutAddressTableView() {
    view.add(addressTableView) {
      $0.isHidden = true
      $0.separatorStyle = .none
      $0.backgroundColor = .clear
      $0.estimatedRowHeight = self.tableViewRowHeight
      $0.rowHeight = UITableView.automaticDimension
      $0.snp.makeConstraints {
        $0.top.equalTo(self.searchTextField.snp.bottom).offset(10)
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(self.view.snp.bottom)
      }
    }
  }
  
  // MARK: - General Helpers
  private func register() {
    addressTableView.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.identifier)
    addressTableView.delegate = self
    addressTableView.dataSource = self
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
  
  private func fetchAddresses() {
    buildingService.fetchBuildingByAddress(address: self.searchTextField.text ?? "")
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(SearchAddressModel.self,
                                          from: response.data)
            self.addressModel = data
            self.addressTableView.isHidden = false
            self.addressTableView.reloadData()
          }
          catch {
            print(error)
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  private func addAddress() {
    userService.addAddress(param: self.userAddressModel ?? ResponseGetAddress(addresses: []))
      .subscribe(onNext: { result in
        if result {
          do {
            self.navigationController?.popViewController(animated: true)
          }
          catch {
            print(error)
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  private func splitAddress(address: String) {
    let addressArray = address.split(separator: " ")
    if addressArray[0] == "세종특별자치시" {
      let cityDistrinct = String(addressArray[0])
      var str = ""
      for i in 1..<addressArray.count {
        if i == addressArray.count-1 {
          str.append(String(addressArray[i]))
        }
        else {
          str.append(String(addressArray[i]))
          str.append(" ")
        }
      }
      let primaryAddress = str
      userAddressModel.addresses.append(
        Addresses(cityDistinct: cityDistrinct,
                  primaryAddress: primaryAddress,
                  isAddressCheck: true))
    }
    else {
      var str = ""
      str.append(String(addressArray[0]))
      str.append(" ")
      str.append(String(addressArray[1]))
      let cityDistrinct = str
      str = ""
      for i in 2..<addressArray.count {
        if i == addressArray.count-1 {
          str.append(String(addressArray[i]))
        }
        else {
          str.append(String(addressArray[i]))
          str.append(" ")
        }
      }
      let primaryAddress = str
      let address = Addresses(cityDistinct: cityDistrinct,
                              primaryAddress: primaryAddress,
                              isAddressCheck: true)
      userAddressModel.addresses.append(address)
    }
  }
  
  // MARK: - Action Helpers
  @objc
  func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = DetailAddressViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
  
  @objc
  private func searchButtonClicked() {
    fetchAddresses()
  }
  
}

// MARK: - addressTableView Delegate
extension SearchAddressViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - addressTableView DataSource
extension SearchAddressViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = self.addressModel?.content.count {
      return count
    }
    else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell else {
      return UITableViewCell()
    }
    addressCell.AddressLabel.setupLabel(
      text: self.addressModel?.content[indexPath.row].fullNumberAddress ?? "",
      color: .blackText,
      font: .nanumRoundRegular(fontSize: 14))
    addressCell.RoadAddressLabel.setupLabel(
      text:
        self.addressModel?.content[indexPath.row].shortRoadNameAddress ?? "",
      color: .addressGray,
      font: .nanumRoundRegular(fontSize: 12))
    addressCell.awakeFromNib()
    return addressCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // TODO: - Selection Action
    let address =
      addressModel?.content[indexPath.row].fullNumberAddress
    splitAddress(address: address ?? "")
    addAddress()
  }
}

