//
//  ReviewPhotoViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/10.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReviewPhotoViewController : BaseViewController {
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "사진 첨부")
  }
  private let addFromLib = UIView().then{
    $0.backgroundColor = .gray244
    let icon = UIImageView().then{
      $0.image = UIImage(named: "")
      $0.backgroundColor = .gray196
    }
    let text = UILabel().then{
      $0.text = "갤러리"
      $0.font = .nanumRoundBold(fontSize: 14)
      $0.textColor = .blackText
    }
    $0.adds([icon, text])
    icon.snp.makeConstraints{
      $0.height.width.equalTo(48)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(24)
    }
    text.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-18)
    }
    $0.setRounded(radius: 8)
    $0.isUserInteractionEnabled = true
  }
  private let addFromCamera = UIView().then{
    $0.backgroundColor = .gray244
    let icon = UIImageView().then{
      $0.image = UIImage(named: "")
      $0.backgroundColor = .gray196
    }
    let text = UILabel().then{
      $0.text = "사진촬영"
      $0.font = .nanumRoundBold(fontSize: 14)
      $0.textColor = .blackText
    }
    $0.adds([icon, text])
    icon.snp.makeConstraints{
      $0.height.width.equalTo(48)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(24)
    }
    text.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-18)
    }
    $0.setRounded(radius: 8)
    $0.isUserInteractionEnabled = true
  }
  private let titleNotice = UILabel().then{
    $0.text = "첨부된 이미지"
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
//    $0.isHidden = true
  }
  private var selectedImageCollectionView : UICollectionView!
  private let nextButtonBackground = UIView().then{
    $0.addline(at: .top)
    $0.backgroundColor = .white
  }
  
  private let nextButton = UIButton().then{
    $0.setTitle("건너뛰기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .communityGreen
  }
  
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
  
  
  private func layout() {
    setUpCollectionView()
    self.view.adds([naviView,
                    addFromLib,
                    addFromCamera,
                    titleNotice,
                    selectedImageCollectionView,
                    nextButtonBackground
    ])
    
    naviView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    addFromLib.snp.makeConstraints{
      $0.top.equalTo(naviView.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.width.equalTo(addFromCamera)
      $0.trailing.equalTo(addFromCamera.snp.leading).offset(-7)
      $0.height.equalTo(114)
    }
    addFromCamera.snp.makeConstraints{
      $0.height.equalTo(addFromLib)
      $0.centerY.equalTo(addFromLib)
      $0.trailing.equalToSuperview().offset(-16)
    }
    titleNotice.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(addFromLib.snp.bottom).offset(40)
    }
    selectedImageCollectionView.snp.makeConstraints{
      $0.top.equalTo(titleNotice.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(96)
    }
    nextButtonBackground.add(nextButton)
    nextButtonBackground.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(102)
    }
    nextButton.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(12)
      $0.height.equalTo(52)
    }
  }
  private func setUpCollectionView() {
    let cellSize = (UIScreen.main.bounds.width - 32 - 50) / 4.0
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: cellSize, height: cellSize)
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    selectedImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    selectedImageCollectionView.backgroundColor = .gray244
    selectedImageCollectionView.setRounded(radius: 8)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    nextButton.rx.tap.bind{[weak self] in
      let nextVC = RegisterReviewPopupViewController()
      nextVC.reviewModel = self!.reviewModel
      nextVC.resultClosure = { result in
        weak var `self` = self
        if result {
          self?.popToRootViewController()
        }
      }
      nextVC.modalPresentationStyle = .overFullScreen
      self?.present(nextVC, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
  }
}
