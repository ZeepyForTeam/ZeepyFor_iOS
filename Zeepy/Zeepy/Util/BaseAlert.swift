//
//  BaseAlert.swift
//  Zeepy
//
//  Created by κΉνν on 2021/04/05.
//

import Foundation
import UIKit

class BaseAlert: UIView {
  lazy var blackView: UIView = { [weak self] in
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.black
    $0.alpha = 0.5
    $0.isUserInteractionEnabled = true
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFromSuperview)))
    return $0
  }(UIView(frame: .zero))
  
  let alertView: UIView = {
    $0.backgroundColor = UIColor.white
    $0.layer.cornerRadius = 10
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UIView(frame: .zero))
  
  let titleLabel: UILabel = {
    $0.font = .nanumRoundExtraBold(fontSize: 16)
    $0.textColor = UIColor.black
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel(frame: .zero))
  
  let grantButton: UIButton = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.backgroundColor = UIColor.white
    $0.setTitleColor(UIColor.mainBlue, for: .normal)
    $0.setTitle("", for: .normal)
    return $0
  }(UIButton(frame: .zero))
  
  let denyButton: UIButton = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.backgroundColor = UIColor.mainBlue
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.setTitle("", for: .normal)
    
    return $0
  }(UIButton(frame: .zero))
  
  lazy var buttonStackView: UIStackView = { [weak self] in
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addArrangedSubview(grantButton)
    
    $0.addArrangedSubview(denyButton)
    $0.distribution = .fillEqually
    $0.axis = .horizontal
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    $0.layer.cornerRadius = 10
    return $0
  }(UIStackView(frame: .zero))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initializeMainView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BaseAlert {
  func initializeMainView() {
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) {
      window.endEditing(true)
      alertView.alpha = 1
      blackView.alpha = 0.5
      
      blackView.frame = window.frame
      window.addSubview(blackView)
      window.addSubview(alertView)
      alertView.addSubview(titleLabel)
      alertView.addSubview(buttonStackView)
      
      NSLayoutConstraint.activate([
        alertView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
        alertView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
        alertView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
        
        titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
        titleLabel.widthAnchor.constraint(equalTo: alertView.widthAnchor, constant: -32),
        titleLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor, constant: -24),
        
        buttonStackView.heightAnchor.constraint(equalToConstant: 48),
        buttonStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 12),
        buttonStackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -12),
        buttonStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10)
      ])
    }
  }
  @objc
  func dismissFromSuperview() {
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(translationX: 0, y: -200)
      UIView.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: { [unowned self] in
                      self.alertView.transform = transform
                      self.alertView.alpha = 0
                      self.blackView.alpha = 0
                     }, completion: { _ in
                      self.blackView.removeFromSuperview()
                      self.alertView.removeFromSuperview()
                     })
    }
  }
}
