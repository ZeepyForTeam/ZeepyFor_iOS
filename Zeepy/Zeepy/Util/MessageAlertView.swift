//
//  Message.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/05.
//

import Foundation
import UIKit

class MessageAlertView: BaseAlert {
  typealias PopupDialogButtonAction = () -> Void
  
  static let shared = MessageAlertView()
  
  var buttonAction: PopupDialogButtonAction?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MessageAlertView {
  func showAlertView(
    title: String,
    grantMessage: String,
    denyMessage: String = "",
    mainColor: UIColor = .mainBlue,
    okAction: PopupDialogButtonAction? = nil
  ) {
    initializeMainView()
    denyButton.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    grantButton.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    denyButton.backgroundColor = mainColor
    grantButton.setTitleColor(mainColor, for: .normal)
    denyButton.isHidden = denyMessage == ""
    grantButton.layer.maskedCorners = [
      .layerMaxXMaxYCorner,
      .layerMinXMaxYCorner
    ]
    grantButton.layer.cornerRadius = 10
    denyButton.layer.maskedCorners = [
      .layerMinXMaxYCorner,
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner,
      .layerMaxXMaxYCorner
    ]
    denyButton.layer.cornerRadius = 10
    buttonAction = okAction
    
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 28/20
    style.alignment = .center
    
    let attributeString: [NSAttributedString.Key: Any] = [
        .paragraphStyle : style,
        .font: UIFont.nanumRoundExtraBold(fontSize: 16)
    ]
    titleLabel.attributedText = NSAttributedString(
      string: title,
      attributes: attributeString
    )
    
    denyButton.setTitle(denyMessage, for: .normal)
    denyButton.addTarget(self,
                         action: #selector(dismissFromSuperview),
                         for: .allTouchEvents)
    grantButton.setTitle(grantMessage, for: .normal)
    grantButton.addTarget(self,
                          action: #selector(dismissAlertView),
                          for: .allTouchEvents)
    
    let titlelabelLineCount = titleLabel.intrinsicContentSize.height / 24
    alertView.heightAnchor.constraint(equalToConstant: 170 + 24 * titlelabelLineCount).isActive = true
    
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(translationX: 0, y: -300)
      alertView.transform = transform
      blackView.alpha = 0
      UIView.animate(withDuration: 0.7,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.blackView.alpha = 0.5
                      self.alertView.transform = .identity
                     }, completion: nil)
    }
  }
  @objc
  func dismissAlertView() {
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
                      self.buttonAction?()
                      self.blackView.removeFromSuperview()
                      self.alertView.removeFromSuperview()
                     })
    }
  }
  
}
