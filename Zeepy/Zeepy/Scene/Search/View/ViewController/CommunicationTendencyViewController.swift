//
//  CommunicationTendencyViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/03.
//

import SnapKit
import Then
import UIKit

class CommunicationTendencyViewController: BaseViewController {
  // MARK: - Constants
  let titleLabelNumberOfLine = 2
  
  // MARK: - Components
  let titleLabel = UILabel()
  let tendencyTableContainerView = UIView()
  let tendencyTableView = UITableView()
  let nextButton = UIButton()
  let separatorView = UIView()
  var tendencyImageList = ["emoji1", "emoji2", "emoji3", "emoji4", "emoji5"]
  var tendencyMapImageList = ["emoji1Map", "emoji2Map", "emoji3Map", "emoji4Map", "emoji5Map"]
  var tendencyTextList = [
    "칼 같은 우리 사이, 비즈니스형",
    "따뜻해 녹아내리는 중! 친절형",
    "자유롭게만 살아다오, 방목형",
    "겉은 바삭 속은 촉촉! 츤데레형",
    "할말은 많지만 하지 않을래요 :("
  ]
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
    register()
    self.tendencyTableView.delegate = self
    self.tendencyTableView.dataSource = self
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "리뷰작성")
  }
  
}
// MARK: - Extensions
extension CommunicationTendencyViewController {
  // MARK: - Helpers
  func layoutTitleLabel() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "임대인의 소통성향은 \n어땠나요?",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 3, length: 1))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 8))
    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  func layoutTendencyTableContainerView() {
    self.view.add(self.tendencyTableContainerView) {
      $0.backgroundColor = .gray244
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(100)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.height.equalTo(self.tendencyTextList.count*40)
      }
    }
  }
  func layoutTendencyTableView() {
    self.tendencyTableContainerView.add(self.tendencyTableView) {
      $0.estimatedRowHeight = UITableView.automaticDimension
      $0.rowHeight = UITableView.automaticDimension
      $0.backgroundColor = .clear
      $0.separatorStyle = .none
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.tendencyTableContainerView.snp.leading)
        $0.trailing.equalTo(self.tendencyTableContainerView.snp.trailing)
        $0.top.equalTo(self.tendencyTableContainerView.snp.top).offset(8)
        $0.bottom.equalTo(self.tendencyTableContainerView.snp.bottom)
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
        $0.leading.equalTo(self.tendencyTableContainerView.snp.leading)
        $0.trailing.equalTo(self.tendencyTableContainerView.snp.trailing)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38-(self.tabBarController?.tabBar.frame.height ?? 44))
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
    layoutTitleLabel()
    layoutTendencyTableContainerView()
    layoutTendencyTableView()
    layoutNextButton()
    layoutseparatorView()
  }
  func register() {
    self.tendencyTableView.register(TendencyTableViewCell.self, forCellReuseIdentifier: TendencyTableViewCell.identifier)
  }
  @objc func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = LenderInformationViewController()
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
}

extension CommunicationTendencyViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 36
  }
}

extension CommunicationTendencyViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tendencyTextList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let tendencyCell = tableView.dequeueReusableCell(withIdentifier: TendencyTableViewCell.identifier, for: indexPath) as? TendencyTableViewCell else { return UITableViewCell() }
    tendencyCell.iconImageView.image = UIImage(named: self.tendencyImageList[indexPath.row])
    tendencyCell.tendencyLabel.setupLabel(text: self.tendencyTextList[indexPath.row], color: .blackText, font: .nanumRoundRegular(fontSize: 14))
    tendencyCell.awakeFromNib()
    return tendencyCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tendencyCell = tableView.dequeueReusableCell(withIdentifier: TendencyTableViewCell.identifier, for: indexPath) as? TendencyTableViewCell
    tendencyCell?.iconImageView.image = UIImage(named: self.tendencyMapImageList[indexPath.row])
    tendencyCell?.tendencyLabel.font = .nanumRoundExtraBold(fontSize: 14)
    tendencyCell?.tendencyContainerView.setBorder(borderColor: .mainBlue, borderWidth: 1)
    tableView.reloadData()
    tableView.awakeFromNib()
  }
}
