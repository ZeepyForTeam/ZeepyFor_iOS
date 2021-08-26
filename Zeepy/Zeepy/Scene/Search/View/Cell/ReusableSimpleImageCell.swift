//
//  ReusableSimpleImageCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/16.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
class ReusableSimpleImageCell  : UICollectionViewCell{
  let disposebag = DisposeBag()
  private let imageView = UIImageView().then{
    $0.backgroundColor = .blue
  }
  private let plusImage = UIImageView().then{
    $0.image = UIImage(named: "btnOpacityAdd")
    $0.isHidden = true
  }
  let deleteBtn = UIButton().then {
    $0.setTitle("삭제", for: .normal)
    $0.backgroundColor = .gray
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    plusImage.isHidden = true
    layout()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func bindCell(model : String, over : Bool) {
    plusImage.isHidden = !over
    imageView.kf.setImage(with: URL(string: model))
    imageView.setRounded(radius: 6)
  }
  func bindCell(model: String , width : CGFloat = 100 * (UIScreen.main.bounds.width/375)) {
    layout(width: width)
    imageView.kf.setImage(with: URL(string: model))
    imageView.setRounded(radius: 6)
  }
  func bindCell(model: UIImage, width: CGFloat = 100 * (UIScreen.main.bounds.width/375)) {
    layout(width: width, deletable: true)
    imageView.image = model
    imageView.setRounded(radius: 6)
  }
  func moreImage() {
    plusImage.isHidden = false
  }
  private func layout(width : CGFloat, deletable: Bool = false) {
    deleteBtn.isHidden = !deletable

    self.contentView.adds([imageView, plusImage, deleteBtn])
    imageView.snp.remakeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
      $0.width.height.equalTo(width)
    }
    deleteBtn.snp.remakeConstraints{
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview()
      $0.top.equalToSuperview()
    }
    plusImage.snp.remakeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
      $0.width.height.equalTo(width)
    }
  }
  private func layout() {
    self.contentView.adds([imageView, plusImage, deleteBtn])
    imageView.snp.remakeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
      $0.width.height.equalTo(72)
    }
    deleteBtn.snp.remakeConstraints{
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview()
      $0.top.equalToSuperview()
    }
    plusImage.snp.remakeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
      $0.width.height.equalTo(72)
    }
  }
}
