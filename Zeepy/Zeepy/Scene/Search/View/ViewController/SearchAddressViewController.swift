//
//  SearchAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/02.
//

import SnapKit
import Then
import UIKit

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
  private let addressModel: KakaoAddressModel? = nil
  private final let tableViewRowHeight: CGFloat = 81
    
  // MARK: - LifeCycles
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
    layoutNextButton()
    layoutseparatorView()
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
      $0.snp.makeConstraints {
        $0.top.equalTo(self.searchTextFieldContainerView.snp.top)
        $0.bottom.equalTo(self.searchTextFieldContainerView.snp.bottom)
        $0.trailing.equalTo(self.searchTextFieldContainerView.snp.trailing)
        $0.width.equalTo(self.view.frame.width*60/375)
      }
    }
  }
  
  private func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.tag = 1
      $0.setRounded(radius: 8)
      $0.setTitle("다음으로", for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      if $0.tag == 0 {
        $0.backgroundColor = .gray244
        $0.setTitleColor(.grayText, for: .normal)
        $0.isUserInteractionEnabled = false
      }
      else if $0.tag == 1 {
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.isUserInteractionEnabled = true
      }
      $0.addTarget(self, action: #selector(self.nextButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38)
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  
  private func layoutseparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
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
        $0.top.equalTo(self.searchTextField.snp.bottom).offset(6)
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(self.separatorView.snp.top)
      }
    }
  }
  // MARK: - General Helpers
  @objc
  func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = DetailAddressViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
  
  private func register() {
    addressTableView.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.identifier)
    addressTableView.delegate = self
    addressTableView.dataSource = self
  }
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
}

// MARK: - addressTableView Delegate
extension SearchAddressViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let count = self.addressModel?.meta.totalCount {
      return self.tableViewRowHeight * CGFloat(count)
    }
    else {
      return 0
    }
  }
}

// MARK: - addressTableView DataSource
extension SearchAddressViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = self.addressModel?.meta.totalCount {
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
      text: self.addressModel?.documents[indexPath.row].addressName ?? "",
      color: .blackText,
      font: .nanumRoundRegular(fontSize: 14))
    addressCell.RoadAddressLabel.setupLabel(
      text:
        self.addressModel?.documents[indexPath.row].roadAddress.addressName ?? "",
      color: .addressGray,
      font: .nanumRoundRegular(fontSize: 12))
    addressCell.awakeFromNib()
    return addressCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // TODO: - Selection Action
  }
}

// MARK: - searchTextField Delegate
extension SearchAddressViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // TODO: - Server Connection with Kakao RestAPI
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    addressTableView.isHidden = false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    addressTableView.isHidden = true
  }
  
}
