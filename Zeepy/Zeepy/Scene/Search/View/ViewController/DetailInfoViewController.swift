//
//  DetailInfoViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/11.
//

import RxDataSources
import RxSwift
import SnapKit
import Then
import UIKit

class DetailInfoViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutNextButton()
    layoutSeparatorView()
    layoutCollectionView()
    register()
    contentCollectionView.dataSource = self
    contentCollectionView.delegate = self
  }
  
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  private let titleLabelNumberOfLine = 2
  
  lazy var contentCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  let firstSectionView: UICollectionReusableView = {
    let identifier = "firstSectionView"
    let reusableView = UICollectionReusableView(frame: .zero)
    return reusableView
  }()
  let nextButton = UIButton()
  let separatorView = UIView()
  let firstSectionTitleLabel = UILabel()
  let firstSectionSubtitleLabel = UILabel()
  let secondSectionView = UICollectionReusableView()
  let secondSectionTitleLabel = UILabel()
  let thirdSectionView = UICollectionReusableView()
  let thirdSectionTitleLabel = UILabel()
}

extension DetailInfoViewController {
  func layoutCollectionView() {
    self.view.add(contentCollectionView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        $0.bottom.equalTo(self.separatorView.snp.bottom)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
      }
    }
  }
  func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.backgroundColor = .gray244
      $0.setTitle("다음으로", for: .normal)
      $0.setTitleColor(.grayText, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38-(self.tabBarController?.tabBar.frame.height ?? 44))
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  func layoutSeparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  func firstSectionViewLayout() {
    self.firstSectionView.then {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.width.equalTo(self.contentCollectionView.frame.width)
        $0.height.equalTo(self.contentCollectionView.frame.height*141/1135)
      }
    }
    self.firstSectionView.add(firstSectionTitleLabel) {
      $0.attributedText = self.setUpTitleLabel()
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.top.equalTo(self.firstSectionView.snp.top).offset(16)
        $0.leading.equalTo(self.firstSectionView.snp.leading).offset(16)
      }
    }
    self.firstSectionView.add(firstSectionSubtitleLabel) {
      $0.setupLabel(text: "방의 개수는 몇 개인가요?", color: .blueText, font: .nanumRoundExtraBold(fontSize: 14))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.firstSectionTitleLabel).offset(36)
        $0.leading.equalTo(self.firstSectionTitleLabel)
      }
    }
  }
  func secondSectionViewLayout() {
    self.secondSectionView.then {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.width.equalTo(self.contentCollectionView.frame.width)
        $0.height.equalTo(self.contentCollectionView.frame.height*96/1135)
      }
    }
    self.secondSectionView.add(secondSectionTitleLabel) {
      $0.setupLabel(text: "객관식 리뷰", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.secondSectionView.snp.top).offset(64)
        $0.leading.equalTo(self.secondSectionView.snp.leading).offset(16)
      }
    }
  }
  func thirdSectionViewLayout() {
    self.thirdSectionView.then {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.width.equalTo(self.contentCollectionView.frame.width)
        $0.height.equalTo(self.contentCollectionView.frame.height*96/1135)
      }
    }
    self.thirdSectionView.add(thirdSectionTitleLabel) {
      $0.setupLabel(text: "가구옵션", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
      $0.snp.makeConstraints {
        $0.top.equalTo(self.thirdSectionView.snp.top).offset(64)
        $0.leading.equalTo(self.thirdSectionView.snp.leading).offset(16)
      }
    }
  }
  func register() {
    self.contentCollectionView.register(RoomAndFurnitureCollectionViewCell.self, forCellWithReuseIdentifier: RoomAndFurnitureCollectionViewCell.identifier)
    self.contentCollectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
    self.contentCollectionView.register(FirstSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FirstSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(SecondSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SecondSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(ThirdSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ThirdSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(EmptySectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptySectionCollectionReusableView.identifier)
  }
  func setUpTitleLabel() -> NSMutableAttributedString {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "집에 대한 정보를\n조금 더 알려주세요!",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 1))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 15, length: 6))
    return titleText
  }
}

extension DetailInfoViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 4
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 12
    case 2:
      return 9
    default:
      return 0
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let roomAndFurnitureCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomAndFurnitureCollectionViewCell.identifier, for: indexPath) as? RoomAndFurnitureCollectionViewCell else { return UICollectionViewCell() }
    guard let reviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
    
    switch indexPath.section {
    case 0:
      roomAndFurnitureCell.awakeFromNib()
      return roomAndFurnitureCell
    case 1:
      reviewCell.awakeFromNib()
      if indexPath.item % 3 == 0 {
        reviewCell.titleLabel.text = "채광"
      }
      else {
        reviewCell.titleLabel.text = " "
      }
      return reviewCell
    case 2:
      roomAndFurnitureCell.awakeFromNib()
      return roomAndFurnitureCell
    default:
      return UICollectionViewCell()
    }
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    var reusableView = UICollectionReusableView()
    if (kind == UICollectionView.elementKindSectionHeader) {
      let section = indexPath.section
      switch (section) {
      case 0:
        let firstSectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FirstSectionCollectionReusableView.identifier, for: indexPath)
        firstSectionView.awakeFromNib()
        reusableView = firstSectionView
      case 1:
        let secondSectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SecondSectionCollectionReusableView.identifier, for: indexPath)
        secondSectionView.awakeFromNib()
        reusableView = secondSectionView
      case 2:
        let thirdSectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ThirdSectionCollectionReusableView.identifier, for: indexPath)
        thirdSectionView.awakeFromNib()
        reusableView = thirdSectionView
      case 3:
        let emptySectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptySectionCollectionReusableView.identifier, for: indexPath)
        reusableView = emptySectionView
      default:
        return reusableView
      }
    }
    return reusableView
  }
}

extension DetailInfoViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth = (self.contentCollectionView.frame.width-16)/3
    if indexPath.section == 1 {
      return CGSize(width: cellWidth, height: cellWidth*80/109)
    }
    else {
    return CGSize(width: cellWidth, height: cellWidth*48/109)
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    switch section {
    case 0:
      return CGSize(width: collectionView.frame.width, height: 141)
    case 1:
      return CGSize(width: collectionView.frame.width, height: 96)
    case 2:
      return CGSize(width: collectionView.frame.width, height: 96)
    case 3:
      return CGSize(width: collectionView.frame.width, height: 64)
    default:
      return CGSize()
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
