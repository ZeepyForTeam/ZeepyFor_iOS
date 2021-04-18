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
  private let buildingName = UILabel().then{
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let userName = UILabel().then {
    $0.textColor = .grayText
    $0.font = .nanumRoundBold(fontSize: 10)
  }
  private let ownerStatus = UILabel()
  private let statusImage = UIImageView()
  private let statusLabel = UILabel()
  private let vaildateBuilding = UILabel()
  private let vaildationLabel = UILabel()
  private let thumbNail = UIImageView()
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
    self.statusLabel.text = model.ownderInfo.ownerStatusLabel
    self.vaildationLabel.text = model.review.review
    self.thumbNail.kf.setImage(with: URL(string: model.buildingImage))
    Observable.just(model.filters)
      .bind(to: optionsCollectionView.rx.items(cellIdentifier: SimpleLabelCollectionViewCell.identifier,
                                               cellType: SimpleLabelCollectionViewCell.self)) {row, data, cell in
        cell.bind(data)
      }.disposed(by: disposeBag)
  }
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 35, height: 16)
    layout.scrollDirection = .horizontal
    self.optionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.optionsCollectionView.backgroundColor = .gray244
    self.optionsCollectionView.isScrollEnabled = false
    self.optionsCollectionView.isUserInteractionEnabled = false
    self.optionsCollectionView.register(SimpleLabelCollectionViewCell.self,
                                        forCellWithReuseIdentifier: SimpleLabelCollectionViewCell.identifier)
  }
  private func layout() {
    self.contentView.backgroundColor = .gray244
    self.contentView.setRounded(radius: 8)
  }
}
class SimpleLabelCollectionViewCell: UICollectionViewCell {
  private let option = UILabel()
  private let background = UIView()
  func bind(_ option : String) {
    layout()
    self.option.text = option
  }
  private func layout() {
    self.contentView.backgroundColor = .gray228
    self.contentView.add(option)
    option.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    option.font = .nanumRoundBold(fontSize: 10)
    option.textColor = .blackText
  }
}
