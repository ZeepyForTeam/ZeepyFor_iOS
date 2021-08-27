//
//  PopUpView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/23.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa
import Then
import SnapKit

class PopUpView : UIView {
  static let shared = PopUpView()
  var addedSubView: UIView!
  
  let disposeBag = DisposeBag()
  private var customAction : (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeMainView()
  }
  lazy var blackView: UIView = { [weak self] in
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.black
    $0.alpha = 0.5
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    return $0
  }(UIView(frame: .zero))
  let backgroundView: UIView = {
    $0.backgroundColor = UIColor.white
    $0.layer.cornerRadius = 10
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UIView(frame: .zero))
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension PopUpView {
  func initializeMainView() {
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) {
      window.endEditing(true)
      backgroundView.alpha = 1
      blackView.alpha = 0.5
      
      blackView.frame = window.frame
      window.adds([blackView, backgroundView])
      
      backgroundView.snp.remakeConstraints{
        $0.centerX.centerY.equalToSuperview()
        $0.leading.equalToSuperview().offset(20)
      }
      
    }
  }
}
extension PopUpView {
  func appearPopUpView(subView: UIView) {
    initializeMainView()
    addedSubView = subView
    backgroundView.addSubview(addedSubView)
    addedSubView.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      backgroundView.transform = transform
      blackView.alpha = 0
      UIView.animate(withDuration: 0.7,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.blackView.alpha = 0.5
                      self.backgroundView.transform = .identity
                     }, completion: nil)
    }
  }
  @objc func dismiss(gesture: UITapGestureRecognizer) {
    dissmissFromSuperview()
  }
  @objc
  func dissmissFromSuperview() {
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .curveEaseOut,
        animations: { [unowned self] in
          self.backgroundView.transform = transform
          self.backgroundView.alpha = 0
          self.blackView.alpha = 0
        }, completion: { _ in
          self.blackView.removeFromSuperview()
          self.backgroundView.removeFromSuperview()
          self.backgroundView.removeFromSuperview()
          self.addedSubView = nil
          
        })
    }
  }
}
