//
//  LookAroundTableViewCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/14.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Then
class LookAroundTableViewCell: UITableViewCell {
  private let cellBackground = UIView().then{
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 10)
  }
  private let buildingName = UILabel().then{
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let userName = UILabel().then {
    $0.textColor = .grayText
    $0.font = .nanumRoundBold(fontSize: 10)
  }
  private let ownerStatus = UILabel().then{
    $0.textColor = .mainBlue
    $0.font = .nanumRoundExtraBold(fontSize: 10)
    $0.text = "집주인 성향"
  }
  private let statusImage = UIImageView()
  private let statusLabel = UILabel().then{
    $0.font = .nanumRoundExtraBold(fontSize: 10)
    $0.textColor = .blackText
  }
  private let vaildateBuilding = UILabel().then{
    $0.textColor = .mainBlue
    $0.font = .nanumRoundExtraBold(fontSize: 10)
    $0.text = "건물 평가"
  }
  private let vaildationLabel = UILabel().then{
    $0.font = .nanumRoundRegular(fontSize: 10)
    $0.textColor = .blackText
  }
  private let thumbNail = UIImageView().then{
    $0.setRounded(radius: 3)
  }
  let disposeBag = DisposeBag()
  private var optionsCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func bind(model : BuildingModel) {
    setupCollectionView()
    layout()
    
    self.buildingName.text = model.buildingName
    self.userName.text = model.review.reviewrName
    self.statusLabel.text = model.ownderInfo.rawValue
    self.statusImage.image = UIImage(named: model.ownderInfo.image)
    self.vaildationLabel.text = model.review.review
    self.thumbNail.kf.setImage(with: URL(string: model.buildingImage))
    Observable.just(model.filters)
      .bind(to: optionsCollectionView.rx.items(cellIdentifier: SimpleLabelCollectionViewCell.identifier,
                                               cellType: SimpleLabelCollectionViewCell.self)){ [weak self] row, data, cell in
        cell.bind(data)
      }.disposed(by: disposeBag)
  }
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = CGSize(width: 35, height: 16)
    self.optionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.optionsCollectionView.backgroundColor = .gray244
    self.optionsCollectionView.isScrollEnabled = false
    self.optionsCollectionView.isUserInteractionEnabled = false
    self.optionsCollectionView.register(SimpleLabelCollectionViewCell.self,
                                        forCellWithReuseIdentifier: SimpleLabelCollectionViewCell.identifier)
  }
  private func layout() {
    self.selectionStyle = .none
    self.contentView.add(cellBackground)
    cellBackground.snp.makeConstraints{
      $0.top.equalToSuperview().offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.centerX.equalToSuperview()
    }
    self.cellBackground.adds([buildingName,
                           userName,
                           ownerStatus,
                           statusImage,
                           statusLabel,
                           vaildateBuilding,
                           vaildationLabel,
                           optionsCollectionView,
                           thumbNail])
    thumbNail.snp.makeConstraints{
      $0.width.height.equalTo(92)
      $0.centerY.equalToSuperview()
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
    buildingName.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(13)
    }
    userName.snp.makeConstraints{
      $0.leading.equalTo(buildingName.snp.trailing).offset(8)
      $0.bottom.equalTo(buildingName.snp.bottom)
    }
    ownerStatus.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(buildingName.snp.bottom).offset(10)
    }
    statusImage.snp.makeConstraints{
      $0.centerY.equalTo(ownerStatus)
      $0.leading.equalTo(ownerStatus.snp.trailing).offset(4)
      $0.width.height.equalTo(16)
    }
    statusLabel.snp.makeConstraints{
      $0.bottom.equalTo(ownerStatus.snp.bottom)
      $0.leading.equalTo(statusImage.snp.trailing).offset(4)
    }
    vaildateBuilding.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(ownerStatus.snp.bottom).offset(7)
    }
    vaildationLabel.snp.makeConstraints{
      $0.centerY.equalTo(vaildateBuilding)
      $0.leading.equalTo(vaildateBuilding.snp.trailing).offset(4)
    }
    optionsCollectionView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalTo(thumbNail.snp.leading).offset(-16)
      $0.top.equalTo(vaildationLabel.snp.bottom).offset(8)
      $0.bottom.equalToSuperview()
    }
  }
}
class SimpleLabelCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let option = UILabel().then{
    $0.font = .nanumRoundBold(fontSize: 10)
    $0.textColor = .black
    
  }
  private let background = UIView().then{
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray228
  }
  func bind(_ option : String) {
    self.option.text = option
  }
  private func layout() {
    self.contentView.backgroundColor = .gray228
    self.contentView.add(background)
    background.add(option)
    background.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
      $0.height.equalTo(16)
    }
    option.snp.makeConstraints{
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(8)
      $0.trailing.equalToSuperview().offset(-8)
    }
    option.font = .nanumRoundBold(fontSize: 10)
    option.textColor = .blackText
  }
}
