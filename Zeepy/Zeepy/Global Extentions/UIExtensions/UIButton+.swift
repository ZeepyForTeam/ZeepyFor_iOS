//
//  UIButton+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/06.
//

import Foundation
import UIKit
extension UIButton {
  public typealias UIButtonTargetClosure = (UIButton) -> ()
  private class UIButtonClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
      self.closure = closure
    }
  }
  /** 매번 setimage할때 귀찮아서 만듦 (normal 상태)
   - Parameter name: UIImage 이름을 적어주세요
   - Returns: 없음
   */
  func setImageByName(_ name: String){
    self.setImage(UIImage(named: name), for: .normal)
  }
  /** 매번 setimage할때 귀찮아서 만듦 (selected상태)
   - Parameter name: UIImage 이름을 적어주세요
   - parameter selected: selected일 때 이름을 적어주세요
   - Returns: 없음
   */
  func setImageByName(_ name: String, _ selected: String){
    self.setImage(UIImage(named: name), for: .normal)
    self.setImage(UIImage(named: selected), for: .selected)
  }
  
  private struct AssociatedKeys {
    static var targetClosure = "targetClosure"
  }
  private var targetClosure: UIButtonTargetClosure? {
    get {
      guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIButtonClosureWrapper else { return nil }
      return closureWrapper.closure
      
    }
    set(newValue) {
      guard let newValue = newValue else { return }
      objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIButtonClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  @objc
  func closureAction() {
    guard let targetClosure = targetClosure else { return }
    targetClosure(self)
    
  }
  public func addAction(for event: UIButton.Event, closure: @escaping UIButtonTargetClosure) {
    targetClosure = closure
    addTarget(self, action: #selector(UIButton.closureAction), for: event)
  }
  func setupButton(title: String,
                   color: UIColor,
                   font: UIFont,
                   backgroundColor: UIColor,
                   state: UIControl.State,
                   radius: CGFloat) {
    self.setTitle(title, for: state)
    self.setTitleColor(color, for: state)
    self.titleLabel?.font = font
    self.backgroundColor = backgroundColor
    self.setRounded(radius: radius)
  }
}
class checkBox : UIView {
  let checkBtn = UIButton().then {
    $0.setImageByName("checkBoxOutlineBlank2", "checkBoxSelected")
  }
  let checkLabel = UILabel().then {
    $0.font = .nanumRoundRegular(fontSize: 14)
    $0.textColor = .grayText
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func layout() {
    self.adds([checkBtn, checkLabel])
    checkBtn.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.width.height.equalTo(20)
    }
    checkLabel.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(checkBtn.snp.trailing).offset(8)
      $0.trailing.equalToSuperview()
    }
  }
}
