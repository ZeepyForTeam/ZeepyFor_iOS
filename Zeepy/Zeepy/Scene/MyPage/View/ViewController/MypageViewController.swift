//
//  MypageViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/21.
//

import UIKit

import Moya
import RxSwift
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
  private let navigationView = CustomNavigationBar()
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
  private let userService = UserService(
    provider: MoyaProvider<UserRouter>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  private var isLogined = LoginManager.shared.isLogin()
  private var userName: String?
  private var userEmail: String?
  private final let addressButtonTitle = "btnManageadress"
  private final let reviewButtonTitle = "btnManagereview"
  private final let favoriteButtonTitle = "btnManageLike"
  private final let addressTitle = "주소 관리"
  private final let reviewTitle = "리뷰 관리"
  private final let favoriteTitle = "찜 목록"
  private final let tableViewRowHeight: CGFloat = 47
  private final let tableViewRowCount = 4
  private final var tableViewTitles = ["환경설정",
                                       "문의 및 의견 보내기",
                                       "지피의 지기들",
                                       "현재 버전 1.1"]
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    configData()
    layout()
    setupNavigation()
    setupGesture()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchNickname()
  }
}

// MARK: - Extensions
extension MypageViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
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
  
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func layoutTitleLabel() {
    view.add(titleLabel) {
      $0.numberOfLines = 2
      $0.isUserInteractionEnabled = true
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
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
      $0.addTarget(self, action: #selector(self.favoriteButtonClicked), for: .touchUpInside)
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
    }
    else {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 7
      let titleText = NSMutableAttributedString(
        string: "반가워요!\n\(self.userName ?? "") 지기님",
        attributes: [.font: UIFont.nanumRoundRegular(fontSize: 24),
                     .foregroundColor: UIColor.blackText])
      
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      
      titleText.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.nanumRoundExtraBold(fontSize: 24),
                             range: NSRange(location: 6,
                                            length: userName?.count ?? 0))
      
      titleText.addAttribute(NSAttributedString.Key.underlineStyle,
                             value: NSUnderlineStyle.single.rawValue,
                             range: NSRange(location: 6,
                                            length: userName?.count ?? 0))
      
      titleText.addAttribute(NSAttributedString.Key.underlineColor,
                             value: UIColor.blackText,
                             range: NSRange(location: 6,
                                            length: userName?.count ?? 0))
      self.titleLabel.attributedText = titleText
      
      
    }
    let versions = VersionChecker.shared.versionChecker().0
    self.tableViewTitles[self.tableViewTitles.count-1] = "현재 버전 \(versions.version)"
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "마이페이지")
  }
  
  func reloadTableView() {
    self.mypageTableView.reloadData()
  }
  
  private func setupGesture() {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(self.titleLabelClicked))
    
    self.titleLabel.addGestureRecognizer(tap)
  }
  
  private func fetchNickname() {
    userService.fetchNickname()
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ResponseFetchNickname.self,
                                          from: response.data)
            self.userName = data.nickname
            self.userEmail = data.email
            self.configData()
          }
          catch {
            print(error)
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  private func mailToUs() {
    let email = "zeepy.official@gmail.com"
    if let url = URL(string: "mailto:\(email)") {
      UIApplication.shared.open(url)
    }
  }
  // MARK: - Action Helpers
  
  @objc
  private func addressButtonClicked() {
    let addressVC = ManageAddressViewController()
    addressVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(addressVC, animated: true)
  }
  
  @objc
  private func reviewButtonClicked() {
    let reviewVC = ManageReviewViewController()
    reviewVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(reviewVC, animated: true)
  }
  
  @objc
  private func favoriteButtonClicked() {
    let favoriteVC = FavoriteListViewConroller()
    favoriteVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(favoriteVC, animated: true)
  }
  
  @objc
  private func titleLabelClicked() {
    if isLogined == false {
      let root = LoginEmailViewController()
      let rootNav = UINavigationController()
      rootNav.navigationBar.isHidden = true
      rootNav.viewControllers = [root]
      if let window = self.view.window {
        window.rootViewController = rootNav
      }
    }
    else {
      let modifyVC = ModifyInformationViewController()
      modifyVC.userName = userName
      modifyVC.socialEmail = userEmail
      modifyVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(modifyVC, animated: true)
    }
  }
  
  @objc
  override func backButtonClicked() {
    let tabbar = self.navigationController?.parent as? TabbarViewContorller
    tabbar?.selectedIndex = 0
    self.navigationController?.popViewController()
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
      let modifyVC = SettingsViewController()
      modifyVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    if indexPath.row == 1 {
      self.mailToUs()
    }
    if indexPath.row == 2 {
      let creditVC = CreditViewController()
      creditVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(creditVC, animated: true)
    }
  }
}
