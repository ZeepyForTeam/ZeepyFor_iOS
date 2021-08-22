//
//  addPhotoViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import YPImagePicker

class AddPhotoViewController : BaseViewController {
  var picker : YPImagePicker {
    var config = YPImagePickerConfiguration()
    config.isScrollToChangeModesEnabled = true
    config.onlySquareImagesFromCamera = true
    config.usesFrontCamera = false
    config.showsPhotoFilters = false
    config.showsVideoTrimmer = true
    config.shouldSaveNewPicturesToAlbum = true
    config.startOnScreen = YPPickerScreen.library
    config.screens = [.library, .photo]
    config.showsCrop = .none
    config.targetImageSize = YPImageSize.original
    config.hidesStatusBar = true
    config.hidesBottomBar = false
    config.hidesCancelButton = false
    config.preferredStatusBarStyle = UIStatusBarStyle.default
    config.maxCameraZoomFactor = 1.0
    config.library.onlySquare = false
    config.library.isSquareByDefault = true
    config.library.minWidthForItem = nil
    config.library.mediaType = YPlibraryMediaType.photo
    config.library.defaultMultipleSelection = false
    config.library.maxNumberOfItems = 10
    config.library.minNumberOfItems = 1
    config.library.numberOfItemsInRow = 4
    config.library.spacingBetweenItems = 1.0
    config.library.skipSelectionsGallery = true
    config.library.preselectedItems = nil
    return YPImagePicker(configuration: config)
  }
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
  private let selectedImages : [UIImage] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    nextButton.rx.tap.bind{[weak self] in
      self?.navigationController?.popToRootViewController(animated: true)
    }.disposed(by: disposeBag)
    bind()
  }
  private func bind() {
    addFromLib.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getImage(gesture:))))
    addFromCamera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getCamera(gesture:))))
    
  }
  @objc
  private func getImage(gesture : UITapGestureRecognizer) {
    
    picker.didFinishPicking { [unowned picker] items, cancelled in
        for item in items {
            switch item {
            case .photo(let photo):
                print(photo)
            case .video(let video):
                print(video)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    self.present(picker, animated: true, completion: nil)
  }
  @objc
  private func getCamera(gesture : UITapGestureRecognizer) {
    picker.didFinishPicking { [unowned picker] items, _ in
        if let photo = items.singlePhoto {
            print(photo.fromCamera) // Image source (camera or library)
            print(photo.image) // Final image selected by the user
            print(photo.originalImage) // original image selected by the user, unfiltered
            print(photo.modifiedImage) // Transformed image, can be nil
            print(photo.exifMeta) // Print exif meta data of original image.
        }
        picker.dismiss(animated: true, completion: nil)
    }
    self.present(picker, animated: true, completion: nil)
  }
}
