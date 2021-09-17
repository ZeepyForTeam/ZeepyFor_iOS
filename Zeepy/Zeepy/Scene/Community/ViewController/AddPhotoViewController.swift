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
    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,
          viewModel : AddPostViewModel?, reviewModel : ReviewModel? = nil) {
        self.viewModel = viewModel
        self.reviewModel = reviewModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let naviView = CustomNavigationBar().then {
        $0.setUp(title: "사진 첨부")
    }
    private let s3Service = S3Service(provider: MoyaProvider<S3Router>(plugins:[NetworkLoggerPlugin()]))
    private let reviewService = ReviewService(provider: MoyaProvider<ReviewRouter>(plugins:[NetworkLoggerPlugin()]))
    private let viewModel : AddPostViewModel?
    private var reviewModel: ReviewModel?
    private var imageArray: [YPMediaPhoto] = []
    private let imagePublisher = PublishSubject<[YPMediaPhoto]>()
    private let deleteImage = PublishSubject<YPMediaPhoto>()
    private let postTrigger = PublishSubject<Void>()
    private let noticeLabel = UILabel().then {
        $0.numberOfLines = 2
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
    
    private let jumpButton = UIButton().then {
        $0.setupButton(
            title: "건너뛰기",
            color: .grayText,
            font: .nanumRoundExtraBold(fontSize: 14),
            backgroundColor: .clear,
            state: .normal,
            radius: 0
        )
    }
    
    private let nextButton = UIButton().then{
        $0.setTitle("등록하기", for: .normal)
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
                        jumpButton,
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
        jumpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.nextButtonBackground.snp.top).offset(-4)
            $0.width.equalTo(80)
            $0.height.equalTo(44)
        }
    }
    private func setUpCollectionView() {
        let cellSize = (UIScreen.main.bounds.width - 32 - 50) / 4.0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        selectedImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectedImageCollectionView.backgroundColor = .gray244
        selectedImageCollectionView.setRounded(radius: 8)
        selectedImageCollectionView.register(ReusableSimpleImageCell.self, forCellWithReuseIdentifier: ReusableSimpleImageCell.identifier)
    }
    private let selectedImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        bind()
    }

    private func bind() {
        if let reviewModel = reviewModel {
            //리뷰작성 레이블 추가
            //maincolor 변경
            reviewLayout()
            reviewActions()
          else {
      let input = AddPostViewModel.Input(loadTrigger: Observable.just(()),
                                         currentImages: imagePublisher,
                                         deleteImage: deleteImage,
                                         post: postTrigger)
      let output = viewModel?.transform(input: input)
      output?.postResult.bind{[weak self] result in
        if result {
          LoadingHUD.rx.isAnimating.onNext(false)

          self?.popToRootViewController()
      }.disposed(by: disposeBag)
      nextButton.rx.tap.bind{[weak self] in
        let view = AddPostPopup.init(isCommunity: true)
        view.resultClosure = {result in
          if result {
            self?.postTrigger.onNext(())
            LoadingHUD.rx.isAnimating.onNext(true)
          }
        }
        PopUpView.shared.appearPopUpView(subView: view)

      }.disposed(by: disposeBag)
      imagePublisher.bind{print($0)}.disposed(by: disposeBag)
      output?.currentImage.bind(to: selectedImageCollectionView.rx.items(cellIdentifier: ReusableSimpleImageCell.identifier,
                                                                         cellType: ReusableSimpleImageCell.self)) { [weak self] row, data, cell in
        guard let self = self else {return}
        cell.bindCell(model: data.image,width: 72)
        cell.deleteBtn.rx.tap
          .takeUntil(cell.rx.methodInvoked(#selector(UICollectionViewCell.prepareForReuse)))
          .bind{[weak self] in
            self?.deleteImage.onNext(data)
          }.disposed(by: cell.disposebag)
      }.disposed(by: disposeBag)
      
      output?.currentImage.bind{[weak self] in
        self?.imageArray = $0
        self?.nextButton.setTitle( $0.isEmpty ? "건너뛰기" : "등록하기", for: .normal)
      }.disposed(by: disposeBag)
        addFromLib.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getImage(gesture:))))
        addFromCamera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getCamera(gesture:))))
    }
    @objc
    private func getImage(gesture : UITapGestureRecognizer) {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = true
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.hidesStatusBar = true
        config.hidesBottomBar = true
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = true
        config.library.maxNumberOfItems = 10
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 0
        config.library.skipSelectionsGallery = true
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            weak var `self` = self
            guard let self = self else {return}
            for item in items {
                switch item {
                case .photo(let photo):
                    if !self.imageArray.contains(where: {$0.asset == photo.asset}) {
                        self.imageArray.append(photo)
                    }
                    else {
                        print(self.imageArray)
                    }
                case .video(let video):
                    print(video)
                }
            }
            self.imagePublisher.onNext(self.imageArray)
            self.jumpButton.isHidden = true
            picker.dismiss(animated: true, completion: nil)
        }
        picker.modalPresentationStyle = .currentContext
        self.present(picker, animated: true, completion: nil)
    }
    @objc
    private func getCamera(gesture : UITapGestureRecognizer) {
        
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.hidesStatusBar = true
        config.hidesBottomBar = true
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                if !self.imageArray.contains(where: {$0.asset == photo.asset}) {
                    self.imageArray.append(photo)
                    self.jumpButton.isHidden = true
                }
            }
            self.imagePublisher.onNext(self.imageArray)
            
            picker.dismiss(animated: true, completion: nil)
        }
        picker.modalPresentationStyle = .currentContext
        self.present(picker, animated: true, completion: nil)
    }
}
import Moya
extension AddPhotoViewController {
    
    private func reviewLayout() {
        self.view.add(noticeLabel)
        noticeLabel.snp.makeConstraints{
            $0.top.equalTo(naviView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        addFromLib.snp.updateConstraints{
            $0.top.equalTo(naviView.snp.bottom).offset(121)
        }
        nextButton.backgroundColor = .mainBlue
        let attributedString = NSMutableAttributedString(string: "집의 외부와 내부 사진을\n첨부해 주세요.", attributes: [
            .font: UIFont.nanumRoundRegular(fontSize: 24),
            .foregroundColor: UIColor.mainBlue
        ])
        attributedString.addAttribute(.font, value: UIFont.nanumRoundExtraBold(fontSize: 24), range: NSRange(location: 3, length: 9))
        noticeLabel.attributedText = attributedString
    }
    private func reviewActions() {
        let current = configureImages(deleteAction: deleteImage,
                                      resetAction: imagePublisher,
                                      origin: []) ?? .empty()
        current.bind(to: selectedImageCollectionView.rx.items(cellIdentifier: ReusableSimpleImageCell.identifier,
                                                              cellType: ReusableSimpleImageCell.self)) { [weak self] row, data, cell in
            guard let self = self else {return}
            cell.bindCell(model: data.image,width: 72)
            cell.deleteBtn.rx.tap
                .takeUntil(cell.rx.methodInvoked(#selector(UICollectionViewCell.prepareForReuse)))
                .bind{[weak self] in
                    self?.deleteImage.onNext(data)
                }.disposed(by: cell.disposebag)
        }.disposed(by: disposeBag)
        current.bind{[weak self] in
            self?.imageArray = $0
        }.disposed(by: disposeBag)
        nextButton.rx.tap.bind{[weak self] in
            let view = AddPostPopup.init(isCommunity: false)
            view.resultClosure = { result in
                if result {
                    self?.postTrigger.onNext(())
                }
            }
            PopUpView.shared.appearPopUpView(subView: view)
        }.disposed(by: disposeBag)
        
        jumpButton.rx.tap.bind{[weak self] in
            let view = AddPostPopup.init(isCommunity: false)
            view.resultClosure = { result in
                if result {
                    self?.postTrigger.onNext(())
                }
            }
            PopUpView.shared.appearPopUpView(subView: view)
        }.disposed(by: disposeBag)
        
        let makeRequsetModel = postTrigger.flatMapLatest{[weak self] _ -> Observable<ReviewModel> in
            
            if self?.imageArray.isEmpty == true {
                self?.reviewModel?.imageUrls = []
                return .just((self?.reviewModel)!)
            }
            else {
                return self?.s3Service.sendImages(image: self?.imageArray.map{$0.image} ?? [])
                    .map{ [weak self] urls -> ReviewModel in
                        self?.reviewModel?.imageUrls = urls
                        return (self?.reviewModel)!
                    }
                    ?? .empty()
            }
        }
        
        let result = makeRequsetModel.flatMapLatest{ [weak self] model in
            self?.reviewService.addReview(param: model) ?? .empty()
        }
        .bind{[weak self] result in
            if result {
                self?.popToRootViewController()
            }
            else {
                print("실패")
            }
        }
        .disposed(by: disposeBag)
        
        
    }
    private func configureImages(
        deleteAction: Observable<YPMediaPhoto>,
        resetAction: Observable<[YPMediaPhoto]>,
        origin:[YPMediaPhoto]) -> Observable<[YPMediaPhoto]> {
        enum Action {
            case delete(model : YPMediaPhoto)
            case reset(modle: [YPMediaPhoto])
        }
        return Observable.merge(deleteAction.map(Action.delete),
                                resetAction.map(Action.reset))
            .scan(into: origin) {state, action in
                switch action {
                case let .delete(model) :
                    state.removeAll(where: {$0.asset == model.asset})
                case .reset(modle: let modle):
                    state = modle
                }
            }.startWith(origin)
    }
}
