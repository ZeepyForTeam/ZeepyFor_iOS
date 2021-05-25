//
//  SettingView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class BaseHalfSubView : UIView {
  var disposeBag = DisposeBag()
  var halfView = HalfAppearView.shared
  typealias customAction = () -> Void
  
  
}
class SettingView : BaseHalfSubView  {
  private let SettingTableView = UITableView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.add(SettingTableView)
    SettingTableView.snp.makeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
    SettingTableView.isScrollEnabled = false
    SettingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    SettingTableView.rowHeight = 37
    SettingTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  var resultClosure: ((String) -> ())?
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  func setUpTableView(_ list: [(String, customAction?)]) {
    let superView = halfView
    Observable.just(list)
      .bind(to: SettingTableView.rx.items(cellIdentifier: SettingTableViewCell.identifier, cellType: SettingTableViewCell.self)) { row, data, cell in
        cell.titleLable.text = data.0
      }.disposed(by: disposeBag)
    SettingTableView.rx.modelSelected((String, customAction).self)
      .bind{ action in
        superView.dissmissWithAction(action: action.1)
      }.disposed(by: disposeBag)
    SettingTableView.rx
      .observeWeakly(CGSize.self, "contentSize")
      .compactMap { $0?.height }
      .distinctUntilChanged()
      .bind{ height in
        superView.halfView.snp.updateConstraints{
          $0.height.equalTo(height + 37)
        }
      }
      .disposed(by: disposeBag)
  }
}
class SettingTableViewCell : UITableViewCell {
  var titleLable = UILabel().then{
    $0.font = .nanumRoundExtraBold(fontSize: 16)
    $0.textAlignment = .center
    $0.textColor = .mainBlue
    
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.add(titleLable)
    titleLable.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    self.selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
