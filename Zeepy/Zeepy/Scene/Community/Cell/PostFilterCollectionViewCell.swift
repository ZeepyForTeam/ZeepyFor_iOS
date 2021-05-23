//
//  PostFilterCollectionViewCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/18.
//

import UIKit

class PostFilterCollectionViewCell: UICollectionViewCell {
  private let containerView = UIView().then {
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 14)
  }
  private let filterLabel = UILabel().then {
    $0.font = .nanumRoundExtraBold(fontSize: 12)
    $0.textColor = .blackText
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    containerView.backgroundColor = .gray244
    filterLabel.textColor = .blackText
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func bindCell(str : String , selected : Bool) {
    filterLabel.text = str
    filterLabel.textColor = selected ? .white : .blackText
    containerView.backgroundColor = selected ? .communityGreen : .gray244
  }
  private func layout() {
    self.contentView.add(containerView)
    self.containerView.add(filterLabel)
    containerView.snp.makeConstraints{$0.leading.trailing.top.bottom.equalToSuperview()}
    filterLabel.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
      $0.leading.equalTo(12)
    }
  }
}
