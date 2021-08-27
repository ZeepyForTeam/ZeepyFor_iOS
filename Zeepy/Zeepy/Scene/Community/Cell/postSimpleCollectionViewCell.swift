//
//  postSimpleCollectionViewCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import UIKit

class postSimpleCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func prepareForReuse() {
    super.prepareForReuse()
      self.type.textColor = .communityGreen
      self.status.textColor = .blackText
      self.postTitle.textColor = .blackText
      self.content.textColor = .blackText
      self.postedAt.textColor = .grayText
  }
  private let type = UILabel().then {
    $0.font = .nanumRoundExtraBold(fontSize: 12)
    $0.textColor = .communityGreen
  }
  private let status = UILabel().then
  {
   $0.font = .nanumRoundBold(fontSize: 12)
   $0.textColor = .blackText
 }
  private let postTitle = UILabel().then {
    $0.font = .nanumRoundExtraBold(fontSize: 16)
    $0.textColor = .blackText
  }
  private let content = UILabel().then {
    $0.font = .nanumRoundRegular(fontSize: 12)
    $0.textColor = .blackText
    $0.numberOfLines = 2
  }
  private let postedAt = UILabel().then {
    $0.font = .nanumRoundRegular(fontSize: 12)
    $0.textColor = .grayText
  }
  private func layout() {
    self.contentView.backgroundColor = .gray249
    self.contentView.setRounded(radius: 5)
    self.contentView.adds([type,status,postTitle,content,postedAt])

    type.snp.makeConstraints{
      $0.top.leading.equalToSuperview().offset(12)
    }
    status.snp.makeConstraints{
      $0.centerY.equalTo(type)
      $0.leading.equalTo(type.snp.trailing).offset(8)
    }
    postTitle.snp.makeConstraints{
      $0.top.equalTo(type.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(12)
    }
    content.snp.makeConstraints{
      $0.top.equalTo(postTitle.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(12)
      $0.trailing.equalToSuperview().offset(-12)
      $0.width .equalTo(UIScreen.main.bounds.width - 56)

    }
    postedAt.snp.makeConstraints{
      $0.top.equalTo(content.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(12)
      $0.bottom.equalToSuperview().offset(-12)
    }
  }
  func bindCell(model : PostModel) {
    self.type.text = model.type.rawValue
    self.status.text = model.status ? "모집 중" : "모집 완료"
    self.postTitle.text = model.postTitle
    self.content.text = model.postConent
    self.postedAt.text = model.postedAt.asDate(format: .yyyyMMdd)?.detailTime
    if !model.status {
      self.type.textColor = .grayText
      self.status.textColor = .grayText
      self.postTitle.textColor = .grayText
      self.content.textColor = .grayText
      self.postedAt.textColor = .grayText
    }
  }
}
