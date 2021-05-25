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

class DetailInformationViewController: BaseViewController {
  
  // MARK: - LifeCycles
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
  lazy var contentCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  let nextButton = UIButton()
  let separatorView = UIView()
}

// MARK: - Extensions
extension DetailInformationViewController {
  // MARK: - Helpers
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
  func register() {
    self.contentCollectionView.register(RoomAndFurnitureCollectionViewCell.self, forCellWithReuseIdentifier: RoomAndFurnitureCollectionViewCell.identifier)
    self.contentCollectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
    self.contentCollectionView.register(FirstSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FirstSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(SecondSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SecondSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(ThirdSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ThirdSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(EmptySectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptySectionCollectionReusableView.identifier)
  }
}

// MARK: - UICollectionViewDataSource
extension DetailInformationViewController: UICollectionViewDataSource {
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

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailInformationViewController: UICollectionViewDelegateFlowLayout {
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
