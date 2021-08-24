//
//  ReportViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ReportViewController
class ReportViewController: BaseViewController {
  
  // MARK: - Lazy Components
  private lazy var reasonTableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 40
    tableView.rowHeight = UITableView.automaticDimension
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let separatorView = UIView()
  
  // MARK: - Variables
  private let tableViewTitles = [
    "자취방 후기 글이 아니에요.",
    "비방과 욕설을 사용했어요.",
    "허위사실을 기재했어요.",
    "사기 글이에요.",
    "기타 사유 선택"]
  
  private final let subtitle =
    "신고 후에는 운영진의 확인 후 글삭제, 회원 탈퇴 등의 절차가 이루어지게 됩니다."
  
  private final let reportTypes = [
    "MISMATCHING",
    "ABUSE",
    "FALSE_FACTS",
    "SCAM",
    "ETC"]
  
  var reportModel = RequestReportModel(
    requestReportModelDescription: "",
    reportID: 0,
    reportType: "",
    reportUser: 0,
    targetTableType: "",
    targetUser: 0)
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension ReportViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutTitleLabel()
    layoutSubtitleLabel()
    layoutSeparatorView()
    layoutReasonTableView()
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
  
  private func layoutTitleLabel() {
    view.add(titleLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(20)
      }
    }
  }
  
  private func layoutSubtitleLabel() {
    view.add(subtitleLabel) {
      if #available(iOS 14.0, *) {
        $0.lineBreakStrategy = .hangulWordPriority
      } else {
        $0.lineBreakMode = .byWordWrapping
      }
      $0.numberOfLines = 2
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-87)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
      }
    }
  }
  
  private func layoutSeparatorView() {
    view.add(separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.top.equalTo(self.subtitleLabel.snp.bottom).offset(23)
        $0.height.equalTo(1)
      }
    }
  }
  
  private func layoutReasonTableView() {
    view.add(reasonTableView) {
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.top.equalTo(self.separatorView.snp.bottom)
        $0.height.equalTo(self.tableViewTitles.count * 41)
      }
    }
  }
  
  // MARK: - General Helpers
  private func register() {
    reasonTableView.delegate = self
    reasonTableView.dataSource = self
    reasonTableView.register(ReportTableViewCell.self,
                             forCellReuseIdentifier: ReportTableViewCell.identifier)
  }
  
  private func configData() {
    navigationView.naviTitle.text = "신고하기"
    titleLabel.setupLabel(text: "신고 사유를 선택해주세요.",
                          color: .blackText,
                          font: .nanumRoundExtraBold(fontSize: 16))
    
    configSubtitle()
    
  }
  
  private func configSubtitle() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(
      string: self.subtitle,
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 12),
                   .foregroundColor: UIColor.blackText])
    
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    
    subtitleLabel.attributedText = titleText
  }
  
  /// Test Code
  private func test() {
    reportModel.targetUser = 1
    reportModel.reportID = 4
    reportModel.targetTableType = "REVIEW"
  }
}

// MARK: - reasonTableView Delegate
extension ReportViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}


// MARK: - reasonTableView DataSource
extension ReportViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let reasonCell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as? ReportTableViewCell else {
      return UITableViewCell()
    }
    reasonCell.awakeFromNib()
    reasonCell.reasonLabel.setupLabel(
      text: self.tableViewTitles[indexPath.row],
      color: .blackText,
      font: .nanumRoundRegular(fontSize: 14))
    return reasonCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    reportModel.reportType = reportTypes[indexPath.row]
    reportModel.reportUser = UserDefaultHandler.userId ?? 100
    test()
    if indexPath.row == 4 {
      let detailVC = ReportDetailViewController()
      print(reportModel)
      detailVC.reportModel = reportModel
      self.navigationController?.pushViewController(detailVC, animated: true)
    }
    else {
      reportModel.requestReportModelDescription =
        reportTypes[indexPath.row]
      let popupVC = ReportPopupViewController()
      popupVC.reportModel = reportModel
      popupVC.resultClosure = { result in
        weak var `self` = self
        if result {
          self?.popViewController()
        }
      }
      popupVC.modalPresentationStyle = .overFullScreen
      self.present(popupVC, animated: true, completion: nil)
    }
  }
  
}
