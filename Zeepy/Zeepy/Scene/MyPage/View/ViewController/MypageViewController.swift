//
//  MypageViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/21.
//

import UIKit

import SnapKit
import Then

// MARK: - MypageViewController
final class MypageViewController: BaseViewController {
  
  // MARK: - Lazy Components
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [addressView, reviewView, favoriteView])
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  // MARK: - Components
  private let titleLabel = UILabel()
  private let addressView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 82))
  private let reviewView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 82))
  private let favoriteView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 82))
  private let addressButton = UIButton()
  private let addressLabel = UILabel()
  private let reviewButton = UIButton()
  private let reviewLabel = UILabel()
  private let favoriteButton = UIButton()
  private let favoriteLabel = UILabel()
  private let mypageTableView = UITableView()
  
  // MARK: - Variables
  private var isLogined = false
  private var userName: String?
  private final let addressButtonTitle = "btnManageadress"
  private final let reviewButtonTitle = "btnManagereview"
  private final let favoriteButtonTitle = "btnLike"
  private final let addressTitle = "주소 관리"
  private final let reviewTitle = "리뷰 관리"
  private final let favoriteTitle = "찜 목록"
  private final let tableViewRowHeight: CGFloat = 47
  private final let tableViewRowCount = 4
  private final let tableViewTitles = ["환경설정", "문의 및 의견 보내기", "지피의 지기들", "현재 버전 1.1"]
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    configData()
    layout()
    setupNavigation()
  }
}

// MARK: - Extensions
extension MypageViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutTitleLabel()
    layoutButtonStackView()
    layoutAddressButton()
    layoutAddressLabel()
    layoutReviewButton()
    layoutReviewLabel()
    layoutFavoriteButton()
    layoutFavoriteLabel()
    layoutMypageTableView()
  }
  
  private func layoutTitleLabel() {
    view.add(titleLabel) {
      $0.numberOfLines = 2
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  
  private func layoutButtonStackView() {
    view.add(buttonStackView) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(28)
        $0.width.equalTo(208)
        $0.height.equalTo(82)
      }
    }
  }
  
  private func layoutAddressButton() {
    addressView.add(addressButton) {
      $0.setBackgroundImage(UIImage(named: self.addressButtonTitle), for: .normal)
      $0.addTarget(self, action: #selector(self.addressButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalTo(56)
      }
    }
  }
  
  private func layoutAddressLabel() {
    addressView.add(addressLabel) {
      $0.setupLabel(text: self.addressTitle, color: .blackText, font: .nanumRoundBold(fontSize: 12))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.addressButton.snp.bottom).offset(12)
      }
    }
  }
  
  private func layoutReviewButton() {
    reviewView.add(reviewButton) {
      $0.setBackgroundImage(UIImage(named: self.reviewButtonTitle), for: .normal)
      $0.addTarget(self, action: #selector(self.reviewButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalTo(56)
      }
    }
  }
  
  private func layoutReviewLabel() {
    reviewView.add(reviewLabel) {
      $0.setupLabel(text: self.reviewTitle, color: .blackText, font: .nanumRoundBold(fontSize: 12))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.reviewButton.snp.bottom).offset(12)
      }
    }
  }
  
  private func layoutFavoriteButton() {
    favoriteView.add(favoriteButton) {
      $0.setBackgroundImage(UIImage(named: self.favoriteButtonTitle), for: .normal)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalTo(56)
      }
    }
  }
  
  private func layoutFavoriteLabel() {
    favoriteView.add(favoriteLabel) {
      $0.setupLabel(text: self.favoriteTitle, color: .blackText, font: .nanumRoundBold(fontSize: 12))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.favoriteButton.snp.bottom).offset(12)
      }
    }
  }
  
  private func layoutMypageTableView() {
    view.add(mypageTableView) {
      $0.backgroundColor = .clear
      $0.separatorStyle = .singleLine
      $0.separatorColor = .gray244
      $0.isScrollEnabled = false
      $0.snp.makeConstraints {
        $0.top.equalTo(self.buttonStackView.snp.bottom).offset(42)
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(Int(self.tableViewRowHeight) * self.tableViewRowCount)
      }
    }
  }
  
  // MARK: - General Helpers
  private func register() {
    mypageTableView.register(MypageTableViewCell.self,
                             forCellReuseIdentifier: MypageTableViewCell.identifier)
    mypageTableView.delegate = self
    mypageTableView.dataSource = self
  }
  
  private func configData() {
    configTitleLabel()
  }
  
  private func configTitleLabel() {
    if self.isLogined == false {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 7
      let titleText = NSMutableAttributedString(string: "로그인을\n완료해주세요.",
                                                attributes: [
                                                  .font: UIFont.nanumRoundRegular(fontSize: 24),
                                                  .foregroundColor: UIColor.blackText])
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      titleText.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.nanumRoundExtraBold(fontSize: 24),
                             range: NSRange(location: 0, length: 3))
      titleText.addAttribute(NSAttributedString.Key.foregroundColor,
                             value: UIColor.pointYellow,
                             range: NSRange(location: 0, length: 3))
      titleText.addAttribute(NSAttributedString.Key.underlineStyle,
                             value: NSUnderlineStyle.single.rawValue,
                             range: NSRange(location: 0, length: 3))
      titleText.addAttribute(NSAttributedString.Key.underlineColor,
                             value: UIColor.pointYellow,
                             range: NSRange(location: 0, length: 3))
      self.titleLabel.attributedText = titleText
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClicked))
      self.titleLabel.addGestureRecognizer(tap)
    }
    else {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 7
      let titleText = NSMutableAttributedString(string: "반가워요!\n\(self.userName ?? "") 지기님",
                                                attributes: [
                                                  .font: UIFont.nanumRoundRegular(fontSize: 24),
                                                  .foregroundColor: UIColor.blackText])
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      titleText.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.nanumRoundExtraBold(fontSize: 24),
                             range: NSRange(location: 5, length: titleText.length - 5 - 4))
      self.titleLabel.attributedText = titleText
    }
  }
  
  private func setupNavigation() {
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "마이페이지")
  }
  
  func reloadTableView() {
    self.mypageTableView.reloadData()
  }
  
  @objc
  func addressButtonClicked() {
    let addressVC = ManageAddressViewController()
    self.navigationController?.pushViewController(addressVC, animated: false)
  }
  
  @objc
  func reviewButtonClicked() {
    let reviewVC = ManageReviewViewController()
    self.navigationController?.pushViewController(reviewVC, animated: false)
  }
  
  @objc
  func titleLabelClicked() {
    let loginVC = LoginViewController()
    self.navigationController?.pushViewController(loginVC, animated: false)
  }
}

// MARK: - mypageTableView Delegate
extension MypageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.tableViewRowHeight
  }
}

// MARK: - mypageTableView DataSource
extension MypageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableViewRowCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let mypageCell = tableView.dequeueReusableCell(
            withIdentifier: MypageTableViewCell.identifier,
            for: indexPath) as? MypageTableViewCell else {
      return UITableViewCell()
    }
    mypageCell.awakeFromNib()
    mypageCell.configData(title: self.tableViewTitles[indexPath.row])
    return mypageCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let modifyVC = ModifyInformationViewController()
      self.navigationController?.pushViewController(modifyVC, animated: false)
    }
  }
}
