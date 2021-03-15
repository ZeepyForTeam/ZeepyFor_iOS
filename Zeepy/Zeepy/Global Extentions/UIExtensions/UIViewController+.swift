//
//  UIViewController+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/07.
//

import Foundation
import UIKit
import RxSwift
import PopupDialog
extension UIViewController {
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

//popUPDialogue
extension UIViewController {
  func callMSGDialog(message: String) {
    let custom = PopupDialog(
      title: "",
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: true,
      panGestureDismissal: true,
      hideStatusBar: false,
      completion: nil
    )
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color = .black
    overlayAppearance.blurRadius = 50
    let button = DefaultButton(title: "확인") {

    }
    button.titleColor = .black
    custom.addButton(button)
    self.present(custom, animated: true, completion: nil)
  }
  func callOkActionMSGDialog(message: String, okAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: "",
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: false,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )

    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color = .black
    overlayAppearance.blurRadius = 50
    let button = DefaultButton(title: "확인") {
      okAction()
    }
    button.titleColor = .black
    custom.addButton(button)
    self.present(custom, animated: true, completion: nil)
  }
  func callTWODialog(yesTxt: String, NoTxt: String, message: String, okAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: "",
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: true,
      panGestureDismissal: true,
      hideStatusBar: false,
      completion: nil
    )
    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color = .black
    overlayAppearance.blurRadius = 50
    let buttonOne = CancelButton(title: NoTxt) { }
    buttonOne.titleFont = UIFont.systemFont(ofSize: 15)
    buttonOne.setTitleColor(.black, for: .normal)

    let buttonTwo = DefaultButton(title: yesTxt) {
      okAction()
    }
    buttonTwo.setTitleColor(UIColor.lightGray, for: .normal)
    buttonTwo.titleFont = UIFont.systemFont(ofSize: 15)

    custom.addButtons([buttonTwo, buttonOne])

    self.present(custom, animated: true, completion: nil)
  }
  func callTWOActionDialog(yesTxt: String, NoTxt: String, message: String, okAction: @escaping () -> Void, cancelActon: @escaping () -> Void) {
    let custom = PopupDialog(
      title: "",
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: true,
      panGestureDismissal: true,
      hideStatusBar: false,
      completion: nil
    )
    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color = .black
    overlayAppearance.blurRadius = 50
    let buttonOne = CancelButton(title: NoTxt) {
      cancelActon()
    }
    let buttonTwo = DefaultButton(title: yesTxt) {
      okAction()
    }

    buttonTwo.tintColor = .black
    buttonTwo.titleColor = .black

    custom.addButtons([buttonOne, buttonTwo])

    self.present(custom, animated: true, completion: nil)
  }
  func callSubViewDialog(_ subview: UIViewController) {
    let custom = PopupDialog(viewController: subview,
                             buttonAlignment: .horizontal,
                             transitionStyle: .zoomIn,
                             preferredWidth: self.view.frame.size.width - 32,
                             tapGestureDismissal: true, panGestureDismissal: true,
                             hideStatusBar: false,
                             completion: nil)
    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color = .black
    overlayAppearance.blurRadius = 50
    custom.keyboardShiftsView = true
    self.present(custom, animated: true, completion: nil)
  }
}
