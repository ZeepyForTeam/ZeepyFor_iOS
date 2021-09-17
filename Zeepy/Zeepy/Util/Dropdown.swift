//
//  Dropdown.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import Foundation
import RxSwift
import RxCocoa
class Dropdown : UIView {
  typealias dropDownAction = () -> Void
  static let shared = Dropdown()
  var addedSubView: UIView!
  private var viewCenter: CGPoint?
  private var dispose = DisposeBag()
  lazy var blackView: UIView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .black
    $0.alpha = 0.5
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    
    return $0
  }(UIView(frame: .zero))

  let container: UIView = {
    $0.backgroundColor = .white
    $0.setRounded(radius: 8)
    $0.translatesAutoresizingMaskIntoConstraints = false
   
    return $0
  }(UIView(frame: .zero))
  let point : UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))

    let path = UIBezierPath()
    path.move(to: CGPoint(x: 7.5, y: 3))
    path.addLine(to: CGPoint(x: 15, y: 15))
    path.addLine(to: CGPoint(x: 0, y: 15))
    path.close()
    
    let layer = CAShapeLayer()
    layer.frame = view.bounds
    layer.path = path.cgPath
    layer.fillColor = UIColor.white.cgColor
    layer.lineWidth = 0
    view.layer.addSublayer(layer)
    view.backgroundColor = .clear
    return view
  }()

  let dropdown : UITableView = {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.rowHeight = 30
    $0.register(dropdownCell.self, forCellReuseIdentifier: dropdownCell.identifier)
    $0.isScrollEnabled = false
    return $0
  }(UITableView(frame: .zero))
  
  var actions: [dropDownAction?] = []
  var titles: [String] = []

  override init(frame:CGRect) {
    super.init(frame: frame)
    initializeMainView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension Dropdown {
  func initializeMainView(_ halfViewHeight : Int? = nil) {
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) {
      window.endEditing(true)
      container.alpha = 1
      blackView.alpha = 0.5
      blackView.frame = window.frame
      window.addSubview(blackView)
      window.addSubview(container)
      window.addSubview(point)
      container.addSubview(dropdown)
      container.snp.remakeConstraints{
        $0.top.equalToSuperview().offset(130)
        $0.leading.equalToSuperview().offset(16)
        $0.width.equalTo(215)
      }
      dropdown.snp.remakeConstraints{
        $0.top.bottom.leading.trailing.equalToSuperview()
        $0.height.equalTo(0)
      }
      point.snp.remakeConstraints{
        $0.top.equalTo(container.snp.top).offset(-15)
        $0.width.height.equalTo(15)
        $0.leading.equalTo(container.snp.leading).offset(26)
      }
    }
  }
 
  @objc func dismiss(gesture: UITapGestureRecognizer) {
    dissmissFromSuperview()
  }
  @objc
  func dissmissFromSuperview() {
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(scaleX: 1, y: 1)
      container.transform = transform
      blackView.alpha = 0
      UIView.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: { [unowned self] in
                      self.container.transform = transform
                      self.container.alpha = 0
                      self.blackView.alpha = 0
                      self.point.alpha = 0
                     }, completion: { _ in
                      self.blackView.removeFromSuperview()
                      self.container.removeFromSuperview()
                      self.point.removeFromSuperview()
                      self.dispose = DisposeBag()

                     })
    }
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
    }
  }
  @objc
  func dissmiss(with action : dropDownAction?) {
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(scaleX: 1, y: 1)
      container.transform = transform
      blackView.alpha = 0
      UIView.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: { [unowned self] in
                      self.container.transform = transform
                      self.container.alpha = 0
                      self.blackView.alpha = 0
                      self.point.alpha = 0
                     }, completion: { _ in
                      self.blackView.removeFromSuperview()
                      self.container.removeFromSuperview()
                      self.point.removeFromSuperview()
                      if let action = action{
                        action ()
                        self.dispose = DisposeBag()

                      }
                     })
    }
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
    }
  }
}
extension Dropdown {
  func addDropDown(items : [Addresses],
                  disposeBag : DisposeBag,
                  dissmissAction: dropDownAction? = nil ,
                  currentItemKey: Addresses? = nil,
                  color: UIColor = .communityGreen) {
    initializeMainView()
    var itemUsecase = items
    let addition = Addresses(cityDistinct: "", primaryAddress: "주소 변경하기", isAddressCheck: false)
    itemUsecase.append(addition)
    titles = itemUsecase.map{$0.primaryAddress}
    Observable.just(itemUsecase).bind(to: dropdown.rx.items(cellIdentifier: dropdownCell.identifier,
                                                       cellType: dropdownCell.self) ) {row, data,cell in
      cell.layout()
      cell.titlelabel.text = data.primaryAddress
      if let currentitem = currentItemKey {
        if data.cityDistinct == "" {
          cell.titlelabel.textColor = color
        }
        else if data == currentitem {
          cell.titlelabel.textColor = color
        }
      }
    }.disposed(by: disposeBag)
    dropdown.rx.modelSelected(Addresses.self)
      .bind{[weak self] address in
        if address.cityDistinct == "" {
          let additionAction : dropDownAction = {
            let vc = ManageAddressViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
          }
          self?.dissmiss(with: additionAction)
        }
        else {
          UserManager.shared.changeCurrent(by: address)
          self?.dissmiss(with: dissmissAction)
        }
      }.disposed(by: dispose)
    dropdown.rx
        .observeWeakly(CGSize.self, "contentSize")
        .compactMap { $0?.height }
        .distinctUntilChanged()
        .bind { [weak self] height in
          self?.dropdown.snp.updateConstraints{
            $0.height.equalTo(height)
          }
        }
        .disposed(by: disposeBag)
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(scaleX: 1, y: 1)
      container.transform = transform
      blackView.alpha = 0
      UIView.animate(withDuration: 0.7,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.blackView.alpha = 0.5
                      self.container.transform = .identity
                      self.point.alpha = 1
                     }, completion: nil)
    }
  }
  func addDropDown(items : [(String , dropDownAction?)],
                   disposeBag : DisposeBag,
                   currentItemKey: String? = nil) {
    initializeMainView()
    actions = items.map{$0.1}
    titles = items.map{$0.0}
    
    Observable.just(items).bind(to: dropdown.rx.items(cellIdentifier: dropdownCell.identifier,
                                                       cellType: dropdownCell.self) ) {row, data,cell in
      cell.layout()
      cell.titlelabel.text = data.0
      if let currentitem = currentItemKey {
        if data.0 == currentitem {
          cell.titlelabel.textColor = .communityGreen
        }
      }
    }.disposed(by: disposeBag)
    dropdown.rx.modelSelected((String, dropDownAction?).self)
      .bind{[weak self] in
        if let action = $0.1 {
          self?.dissmiss(with: action)
        }
    }.disposed(by: dispose)
    dropdown.rx
        .observeWeakly(CGSize.self, "contentSize")
        .compactMap { $0?.height }
        .distinctUntilChanged()
        .bind { [weak self] height in
          self?.dropdown.snp.updateConstraints{
            $0.height.equalTo(height)
          }
        }
        .disposed(by: disposeBag)
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(scaleX: 1, y: 1)
      container.transform = transform
      blackView.alpha = 0
      UIView.animate(withDuration: 0.7,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.blackView.alpha = 0.5
                      self.container.transform = .identity
                      self.point.alpha = 1
                     }, completion: nil)
    }
  }
}

class dropdownCell : UITableViewCell {
  let titlelabel =  UILabel().then{
    $0.font = .nanumRoundExtraBold(fontSize: 12)
    $0.textColor = .blackText
  }
  func layout() {
    selectionStyle = .none
    self.contentView.addSubview(titlelabel)
    titlelabel.snp.remakeConstraints{
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(18)
    }
  }
}
