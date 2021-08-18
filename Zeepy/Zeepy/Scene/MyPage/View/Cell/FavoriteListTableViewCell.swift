//
//  FavoriteListTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/16.
//

import UIKit

import SnapKit
import Then

// MARK: - FavoriteListTableViewCell
class FavoriteListTableViewCell: UITableViewCell {
  
  // MARK: - Lazy Components
  lazy var tagCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  // MARK: - Components
  private let containerView = UIView()
  let buildingImageView = UIImageView()
  let titleLabel = UILabel()
  private let tendencyTitleLabel = UILabel()
  let tendencyIconView = UIImageView()
  let tendencyContentLabel = UILabel()
  private let assessTitleLabel = UILabel()
  let assessContentLabel = UILabel()
  
  // MARK: - Variables
  var roomCount: Set<String>?
  var buildingType: String?
  
  // MARK: - Life Cycles
  override func awakeFromNib() {
    super.awakeFromNib()
    configData()
    layout()
    register()
  }
}

// MARK: - Extensions
extension FavoriteListTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    self.backgroundColor = .white
    layoutContainerView()
    layoutTitleLabel()
    layoutTendencyTitleLabel()
    layoutTendencyIconView()
    layoutTendencyContentLabel()
    layoutAssessTitleLabel()
    layoutAssessContentLabel()
    layoutBuildingImageView()
    layoutTagCollectionView()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.setRounded(radius: 8)
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(4)
        $0.leading.equalTo(self.contentView.snp.leading).offset(16)
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(self.contentView.snp.bottom).offset(-4)
      }
    }
  }
  
  private func layoutTitleLabel() {
    containerView.add(titleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.containerView.snp.top).offset(12)
        $0.leading.equalTo(self.containerView.snp.leading).offset(16)
      }
    }
  }
  
  private func layoutTendencyTitleLabel() {
    containerView.add(tendencyTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        $0.leading.equalTo(self.titleLabel.snp.leading)
      }
    }
  }
  
  private func layoutTendencyIconView() {
    containerView.add(tendencyIconView) {
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.tendencyTitleLabel.snp.centerY)
        $0.leading.equalTo(self.tendencyTitleLabel.snp.trailing).offset(4)
        $0.width.height.equalTo(16)
      }
    }
  }
  
  private func layoutTendencyContentLabel() {
    containerView.add(tendencyContentLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.tendencyIconView.snp.trailing).offset(4)
        $0.centerY.equalTo(self.tendencyIconView.snp.centerY)
      }
    }
  }
  
  private func layoutAssessTitleLabel() {
    containerView.add(assessTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.tendencyTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.tendencyTitleLabel.snp.leading)
      }
    }
  }
  
  private func layoutAssessContentLabel() {
    containerView.add(assessContentLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.assessTitleLabel.snp.trailing).offset(4)
        $0.centerY.equalTo(self.assessTitleLabel.snp.centerY)
      }
    }
  }
  
  private func layoutBuildingImageView() {
    containerView.add(buildingImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.top)
        $0.centerY.equalToSuperview()
        $0.trailing.equalTo(self.containerView.snp.trailing).offset(-12)
        $0.width.equalTo(92)
      }
    }
  }
  
  private func layoutTagCollectionView() {
    containerView.add(tagCollectionView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.assessTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.height.equalTo(16)
        $0.trailing.equalTo(self.buildingImageView.snp.leading)
        $0.bottom.equalTo(self.containerView.snp.bottom).offset(-16)
      }
    }
  }
  
  // MARK: - General Helpers
  private func register() {
    tagCollectionView.register(
      RoomTagCollectionViewCell.self,
      forCellWithReuseIdentifier: RoomTagCollectionViewCell.identifier)
    tagCollectionView.delegate = self
    tagCollectionView.dataSource = self
  }
  
  private func configData() {
    tendencyTitleLabel.setupLabel(text: "집주인 성향",
                                  color: .pastelYellow,
                                  font: .nanumRoundExtraBold(fontSize: 10))
    assessTitleLabel.setupLabel(text: "건물 평가",
                                color: .pastelYellow,
                                font: .nanumRoundExtraBold(fontSize: 10))
  }
  
  func dataBind(apartmentName: String, tendencyImageName: String, tendency: String, totalEvaluation: String, buildingImageName: String, roomCount: Set<String>, buildingType: String) {
    titleLabel.setupLabel(text: apartmentName,
                          color: .blackText,
                          font: .nanumRoundExtraBold(fontSize: 14))
    
    tendencyIconView.image = UIImage(named: tendencyImageName)
    tendencyContentLabel.setupLabel(text: tendency,
                                    color: .blackText,
                                    font: .nanumRoundExtraBold(fontSize: 10))
    
    assessContentLabel.setupLabel(text: totalEvaluation,
                                  color: .blackText,
                                  font: .nanumRoundRegular(fontSize: 10))
    
    self.roomCount = roomCount
    self.buildingType = buildingType
  }
  
  func reloadCollectionView() {
    tagCollectionView.reloadData()
  }
  
  private func setupCollectionViewItemCount() -> Int {
    if buildingType == "UNKNOWN" &&
        (roomCount?.isEmpty == true || roomCount == nil) {
      return 1
    }
    if buildingType == "UNKNOWN" {
      return roomCount?.count ?? 0
    }
    else {
      return (roomCount?.count ?? 0) + 1
    }
  }
  
  private func setupTags() -> [String] {
    var tags: [String] = []
    for element in roomCount ?? Set([""]) {
      tags.append(element)
    }
    tags.append(buildingType ?? "")
    return tags
  }
  
  private func setupTagString(tags: [String]) -> [String] {
    var tagStrings: [String] = []
    for tag in tags {
      switch tag {
      case "ONE":
        tagStrings.append("원룸")
      case "TWO":
        tagStrings.append("투룸")
      case "TRHEEORMORE":
        tagStrings.append("쓰리룸+")
      case "OFFICETEL":
        tagStrings.append("오피스텔")
      case "ROWHOUSE":
        tagStrings.append("연립다세대")
      case "UNKNOWN":
        print("UNKNOWN")
      default:
        print("default")
      }
    }
    return tagStrings
  }
}

// MARK: - UICollectionView DelegateFlowLayout
extension FavoriteListTableViewCell: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let tagNames = setupTags()
    var width: CGFloat = 0
    if tagNames == ["UNKNOWN"] {
      return CGSize(width: 106, height: 16)
    }
    switch tagNames[indexPath.item] {
    case "ONE", "TWO":
      width = 35
    case "TRHEEORMORE":
      width = 52
    case "OFFICETEL":
      width = 53
    case "ROWHOUSE":
      width = 62
    case "UNKNOWN":
      print("UNKNOWN")
    default:
      print("default")
    }
    return CGSize(width: width, height: 16)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }
}

extension FavoriteListTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    setupCollectionViewItemCount()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomTagCollectionViewCell.identifier, for: indexPath) as? RoomTagCollectionViewCell else { return UICollectionViewCell() }
    
    let tagNames: [String] = setupTags()
    if buildingType == "UNKNOWN" &&
        (roomCount?.isEmpty == true || roomCount == nil) {
      tagCell.tagLabel.setupLabel(text: "정보 업데이트 준비 중",
                                  color: .blackText,
                                  font: .nanumRoundBold(fontSize: 10))
    }
    tagCell.tagLabel.setupLabel(text: tagNames[indexPath.item],
                                color: .blackText,
                                font: .nanumRoundBold(fontSize: 10))
    return tagCell
  }
  
  
}
