//
//  tableViewHeaderCollectionViewCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/13.
//

import UIKit

class tableViewHeaderCollectionViewCell: UICollectionViewCell {
    let container = UIView().then{
        $0.backgroundColor = .gray244
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }
    let label = UILabel().then{
      $0.textAlignment = .center
    }
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

    }
  required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    private func layout() {
        contentView.addSubview(container)
        container.addSubview(label)
        container.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        label.snp.makeConstraints{
          $0.top.bottom.equalToSuperview()
          $0.leading.equalToSuperview().offset(10)
          $0.trailing.equalToSuperview().offset(-10)
          $0.height.equalTo(28)
        }
    }
  func bindCell(_ model : FilterModel , first: Bool) {
      layout()
    label.text = model.title.rawValue
    self.container.layer.backgroundColor = model.selected ? UIColor.softBlue.cgColor : UIColor.gray244.cgColor
    self.label.textColor = model.selected ? .white : .blackText
    self.label.font = .nanumRoundBold(fontSize: 12)
  }
}
