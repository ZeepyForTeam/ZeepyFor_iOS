//
//  SelectAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/04/17.
//
import Foundation
import SnapKit
import Then
import UIKit

// MARK: - AddressModel
struct AddressModel: Codable {
  let addresses: [Addresses]
}

// MARK: - Addresses
struct Addresses: Codable {
  let cityDistinct, primaryAddress, detailAddress: String
}

class SelectAddressViewController: BaseViewController {
  // MARK: - Constants
  let titleLabelNumberOfLine = 2
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  let titleLabel = UILabel()
  let addressLabel = UILabel()
  let submitButton = UIButton()
  let addressTableContainerView = UIView()
  let addressTableView = UITableView()
  let addressTableFooterLabel = UILabel()
  let separatorView = UIView()
  let nextButton = UIButton()
  
  // MARK: - Variables
  var selectedIndex = 100
  var reviewModel = ReviewModel(address: "",
                                buildingID: 0,
                                communcationTendency: "",
                                furnitures: [],
                                imageUrls: [],
                                lessorAge: "",
                                lessorGender: "",
                                lessorReview: "",
                                lightning: "",
                                pest: "",
                                review: "",
                                roomCount: "",
                                soundInsulation: "",
                                totalEvaluation: "",
                                user: 0,
                                waterPressure: "")
  
  var addressModel =  AddressModel(addresses: [
                                    Addresses(cityDistinct: "서울시 노원구",
                                              primaryAddress: "공릉동",
                                              detailAddress: "34번지 102호"),
                                    Addresses(cityDistinct: "서울시 노원구",
                                              primaryAddress: "공릉동",
                                              detailAddress: "34번지 102호"),
                                    Addresses(cityDistinct: "서울시 노원구",
                                              primaryAddress: "공릉동",
                                              detailAddress: "34번지 102호")])
  
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
extension SelectAddressViewController {
  // MARK: - Helpers
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  func layoutTitleText() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "거주하고 계신 집을 \n검색하세요",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 8))
    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
      }
    }
  }
  func layoutAddressLabel() {
    self.view.add(self.addressLabel) {
      $0.textColor = .blackText
      $0.font = UIFont.nanumRoundExtraBold(fontSize: 18)
      $0.text = "현재 등록된 주소"
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(64)
      }
    }
  }
  func layoutSubmitButton() {
    self.view.add(self.submitButton) {
      $0.setTitle("직접 등록하기", for: .normal)
      $0.setTitleColor(.blackText, for: .normal)
      $0.titleLabel?.font = .nanumRoundBold(fontSize: 10)
      $0.addTarget(self, action: #selector(self.submitButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.addressLabel.snp.centerY)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
      }
    }
  }
  func layoutAddressTableView() {
    self.view.add(self.addressTableView) {
      $0.estimatedRowHeight = 56
      $0.rowHeight = UITableView.automaticDimension
      $0.separatorStyle = .none
      $0.isScrollEnabled = false
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.addressLabel.snp.leading)
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.addressLabel.snp.bottom).offset(16)
        $0.height.equalTo(self.addressModel.addresses.count * 56)
      }
    }
  }
  func layoutAddressTableFooterLabel() {
    self.view.add(self.addressTableFooterLabel) {
      $0.text = "* 최대 3개까지 등록 가능합니다."
      $0.textColor = .grayText
      $0.font = .nanumRoundRegular(fontSize: 10)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.addressTableView.snp.bottom).offset(16)
        $0.leading.equalTo(self.addressTableView.snp.leading)
      }
    }
  }
  func layoutNextButton() {
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
        $0.leading.equalTo(self.addressTableView.snp.leading)
        $0.trailing.equalTo(self.addressTableView.snp.trailing)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38)
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  func layoutseparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  func layout() {
    layoutNavigationView()
    layoutTitleText()
    layoutAddressLabel()
    layoutSubmitButton()
    layoutAddressTableView()
    layoutAddressTableFooterLabel()
    layoutNextButton()
    layoutseparatorView()
  }
  
  // MARK: - General Helpers
  private func register() {
    addressTableView.register(
      SelectAddressTableViewCell.self,
      forCellReuseIdentifier: SelectAddressTableViewCell.identifier)
    addressTableView.delegate = self
    addressTableView.dataSource = self
  }
  
  // MARK: - Action Helpers
  @objc
  private func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = DetailAddressViewController()
    nextViewController.addressModel = addressModel.addresses[selectedIndex]
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
  
  @objc
  private func submitButtonClicked() {
    if addressModel.addresses.count == 3 {
      let popupVC = AddressLimitPopupViewController()
      popupVC.modalPresentationStyle = .overFullScreen
      self.present(popupVC, animated: true, completion: nil)
    }
    else {
      let navigation = self.navigationController
      let nextViewController = SearchAddressViewController()
      nextViewController.hidesBottomBarWhenPushed = false
      navigation?.pushViewController(nextViewController, animated: true)
    }
  }
  
  func deleteButtonClicked() {
    let popupVC = ConfirmDeletePopupViewController()
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: true, completion: nil)
  }
  
  func registerButtonClicked() {
    let navigation = self.navigationController
    let nextVC = SearchAddressViewController()
    nextVC.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextVC, animated: true)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
  
}

// MARK: - addressTableView Delegate
extension SelectAddressViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - addressTableView DataSource
extension SelectAddressViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addressModel.addresses.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let addressCell = tableView.dequeueReusableCell(withIdentifier: SelectAddressTableViewCell.identifier, for: indexPath) as? SelectAddressTableViewCell else {
      return UITableViewCell()
    }
    addressCell.awakeFromNib()
    let address = addressModel.addresses[indexPath.row]
    addressCell.addressLabel.text = "\(address.cityDistinct) \(address.primaryAddress) \(address.detailAddress)"
    addressCell.rootViewController = self
    if indexPath.row == selectedIndex {
      addressCell.containerView.layer.borderColor = UIColor.mainBlue.cgColor
      addressCell.containerView.layer.borderWidth = 2
    }
    else {
      addressCell.containerView.layer.borderColor = UIColor.grayText.cgColor
      addressCell.containerView.layer.borderWidth = 1
    }
    return addressCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    tableView.reloadData()
  }
}

