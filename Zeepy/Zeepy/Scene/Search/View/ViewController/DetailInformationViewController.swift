//
//  DetailInfoViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/11.
//
import UIKit

import RxDataSources
import RxSwift
import SnapKit
import Then

// MARK: - DetailInformationViewController
class DetailInformationViewController: BaseViewController {
  
  // MARK: - Lazy Components
  lazy var contentCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  let nextButton = UIButton()
  let separatorView = UIView()
  
  // MARK: - Variables
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
  
  private final let roomCounts = [("1개", "ONE"),
                                  ("2개", "TWO"),
                                  ("3개 이상", "THREEORMORE")]
  
  private final let reviewResults = ["좋아요",
                                     "적당해요",
                                     "별로에요",
                                     "없어요",
                                     "가끔 나와요",
                                     "많아요"]
  
  var furnitureOptions = [("에어컨", false, "AIRCONDITIONAL"),
                          ("세탁기", false, "WASHINGMACHINE"),
                          ("침대", false, "BED"),
                          ("옷장", false, "CLOSET"),
                          ("책상", false, "DESK"),
                          ("냉장고", false, "REFRIDGERATOR"),
                          ("인덕션", false, "INDUCTION"),
                          ("가스레인지", false, "BURNER"),
                          ("전자레인지", false, "MICROWAVE")]
  
  private final let reviewTitles = ["방음", "해충", "채광", "수압"]
  private final let reviewSelections = ["GOOD", "PROPER", "BAD"]
  var selectedRoomCount = 100
  var selectedSound = 100
  var selectedBug = 100
  var selectedLight = 100
  var selectedWater = 100
  
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutNavigationView()
    layoutNextButton()
    layoutSeparatorView()
    layoutCollectionView()
    register()
    contentCollectionView.dataSource = self
    contentCollectionView.delegate = self
    setupNavigation()
  }
}

// MARK: - Extensions
extension DetailInformationViewController {
  
  // MARK: - Layout Helpers
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  func layoutCollectionView() {
    self.view.add(contentCollectionView) {
      $0.backgroundColor = .clear
      $0.showsVerticalScrollIndicator = false
      $0.snp.makeConstraints {
        $0.top.equalTo(self.navigationView.snp.bottom)
        $0.bottom.equalTo(self.separatorView.snp.bottom)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
      }
    }
  }
  
  func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.tag = 0
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
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38)
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
  
  // MARK: - General Helpers
  func register() {
    self.contentCollectionView.register(RoomAndFurnitureCollectionViewCell.self, forCellWithReuseIdentifier: RoomAndFurnitureCollectionViewCell.identifier)
    self.contentCollectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
    self.contentCollectionView.register(FirstSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FirstSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(SecondSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SecondSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(ThirdSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ThirdSectionCollectionReusableView.identifier)
    self.contentCollectionView.register(EmptySectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptySectionCollectionReusableView.identifier)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
  
  private func activateNextButton() {
    if selectedRoomCount != 100 &&
        selectedSound != 100 &&
        selectedBug != 100 &&
        selectedLight != 100 &&
        selectedWater != 100 {
      nextButton.backgroundColor = .mainBlue
      nextButton.setTitleColor(.white, for: .normal)
      nextButton.isUserInteractionEnabled = true
    }
  }
  
  // MARK: - Action Helpers
  @objc func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = AdditionalInformationViewController()
    reviewModel.roomCount = roomCounts[selectedRoomCount].1
    reviewModel.soundInsulation = reviewSelections[selectedSound % 3]
    reviewModel.pest = reviewSelections[selectedBug % 3]
    reviewModel.lightning = reviewSelections[selectedLight % 3]
    reviewModel.waterPressure = reviewSelections[selectedWater % 3]
    var furnitures: [String] = []
    for furniture in furnitureOptions {
      if furniture.1 == true {
        furnitures.append(furniture.2)
      }
    }
    reviewModel.furnitures = furnitures
    nextViewController.reviewModel = reviewModel
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
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
      roomAndFurnitureCell.titleLabel.text = roomCounts[indexPath.item].0
      roomAndFurnitureCell.index = indexPath.item
      if selectedRoomCount == indexPath.item {
        roomAndFurnitureCell.containerView.backgroundColor = .mainBlue
        roomAndFurnitureCell.titleLabel.textColor = .white
      }
      return roomAndFurnitureCell
    case 1:
      reviewCell.awakeFromNib()
      
      if indexPath.item == 3 || indexPath.item == 4 || indexPath.item == 5 {
        reviewCell.containerContentLabel.text =
          reviewResults[indexPath.item]
      }
      else {
        reviewCell.containerContentLabel.text =
          reviewResults[indexPath.item % 3]
      }
      
      if indexPath.item % 3 == 0 {
        reviewCell.titleLabel.text = reviewTitles[indexPath.item / 3]
        if indexPath.item == selectedSound || indexPath.item == selectedBug || indexPath.item == selectedLight || indexPath.item == selectedWater {
          reviewCell.containerBackgroundImageView.image = UIImage(named: "btnGoodReviewSelected")
          reviewCell.containerContentLabel.textColor = .blackText
        }
        else {
          reviewCell.containerBackgroundImageView.image = UIImage(named: "btnGoodReviewUnselected")
          reviewCell.containerContentLabel.textColor = .grayText
        }
      }
      else if indexPath.item % 3 == 1 {
        reviewCell.titleLabel.text = " "
        if indexPath.item == selectedSound || indexPath.item == selectedBug || indexPath.item == selectedLight || indexPath.item == selectedWater {
          reviewCell.containerBackgroundImageView.image = UIImage(named: "btnSosoReviewSelected")
          reviewCell.containerContentLabel.textColor = .blackText
        }
        else {
          reviewCell.containerBackgroundImageView.image = UIImage(named: "btnSosoReviewUnselected")
          reviewCell.containerContentLabel.textColor = .grayText
        }
      }
      else if indexPath.item % 3 == 2 {
        reviewCell.titleLabel.text = " "
        if indexPath.item == selectedSound || indexPath.item == selectedBug || indexPath.item == selectedLight || indexPath.item == selectedWater {
          reviewCell.containerBackgroundImageView.image = UIImage(named: "btnAngryReviewSelected")
          reviewCell.containerContentLabel.textColor = .blackText
        }
        else {
          reviewCell.containerBackgroundImageView.image = UIImage(named: "btnAngryReviewUnselected")
          reviewCell.containerContentLabel.textColor = .grayText
        }
      }
      
      reviewCell.index = indexPath.item
      return reviewCell
    case 2:
      roomAndFurnitureCell.awakeFromNib()
      roomAndFurnitureCell.titleLabel.text = furnitureOptions[indexPath.item].0
      if furnitureOptions[indexPath.item].1 == true {
        roomAndFurnitureCell.titleLabel.textColor = .white
        roomAndFurnitureCell.containerView.backgroundColor = .mainBlue
      }
      else {
        roomAndFurnitureCell.titleLabel.textColor = .blackText
        roomAndFurnitureCell.containerView.backgroundColor = .mainYellow
      }
      roomAndFurnitureCell.index = indexPath.item
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      selectedRoomCount = indexPath.item
      activateNextButton()
    }
    if indexPath.section == 1 {
      if indexPath.item / 3 == 0 {
        selectedSound = indexPath.item
      }
      else if indexPath.item / 3 == 1 {
        selectedBug = indexPath.item
      }
      else if indexPath.item / 3 == 2 {
        selectedLight = indexPath.item
      }
      else {
        selectedWater = indexPath.item
      }
      activateNextButton()
    }
    if indexPath.section == 2 {
      furnitureOptions[indexPath.item].1 = !(furnitureOptions[indexPath.item].1)
    }
    collectionView.reloadData()
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
