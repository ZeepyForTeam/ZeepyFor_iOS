//
//  UIView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/06.
//

import Foundation
import UIKit
extension UIView {
  func customAnchorEdgesToSuperView(_ view: UIView) {
    view.topAnchor.constraint(equalTo: (view.superview?.topAnchor)!).isActive = true
    view.bottomAnchor.constraint(equalTo: (view.superview?.bottomAnchor)!).isActive = true
    view.leftAnchor.constraint(equalTo: (view.superview?.leftAnchor)!).isActive = true
    view.rightAnchor.constraint(equalTo: (view.superview?.rightAnchor)!).isActive = true
  }
}
extension UIView {
  @IBInspectable
  var ibCornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable
  var borderColor: UIColor? {
    get {
      let color = UIColor.init(cgColor: layer.borderColor!)
      return color
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }

  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = CGSize(width: 0, height: 2)
      layer.shadowOpacity = 0.4
      layer.shadowRadius = newValue
    }
  }
}

//
// View for UILabel Accessory
//
extension UIView {
  @discardableResult
  func add<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
    addSubview(subview)
    closure?(subview)
    return subview
  }

  @discardableResult
  func adds<T: UIView>(_ subviews: [T], then closure: (([T]) -> Void)? = nil) -> [T] {
    subviews.forEach { addSubview($0) }
    closure?(subviews)
    return subviews
  }

  func setRounded(radius : CGFloat?){
      // UIView 의 모서리가 둥근 정도를 설정
      if let cornerRadius_ = radius {
        self.layer.cornerRadius = cornerRadius_
      }  else {
        // cornerRadius 가 nil 일 경우의 default
        self.layer.cornerRadius = self.layer.frame.height / 2
      }

      self.layer.masksToBounds = true
    }
  func setBorder(borderColor : UIColor?, borderWidth : CGFloat?) {

    // UIView 의 테두리 색상 설정
    if let borderColor_ = borderColor {
      self.layer.borderColor = borderColor_.cgColor
    } else {
      // borderColor 변수가 nil 일 경우의 default
      self.layer.borderColor = UIColor(red: 205/255, green: 209/255, blue: 208/255, alpha: 1.0).cgColor
    }

    // UIView 의 테두리 두께 설정
    if let borderWidth_ = borderWidth {
      self.layer.borderWidth = borderWidth_
    } else {
      // borderWidth 변수가 nil 일 경우의 default
      self.layer.borderWidth = 1.0
    }
  }
}

extension CALayer {
  func applyShadow(
    color: UIColor = .black,
    alpha: Float = 0.15,
    x: CGFloat = 0,
    y: CGFloat = 0,
    blur: CGFloat = 15,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }

  func dismissShadow(
    color: UIColor = .white,
    alpha: Float = 0,
    x: CGFloat = 0,
    y: CGFloat = 0,
    blur: CGFloat = 0,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = 0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
