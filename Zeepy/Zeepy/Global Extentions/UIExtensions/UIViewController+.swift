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
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc
  func dismissVC() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }
  @objc
  func popToRootViewController() {
    self.navigationController?.popToRootViewController(animated: true)
  }
  func setupStatusBar(_ color: UIColor) {
    if #available(iOS 13.0, *) {
      let margin = view.layoutMarginsGuide
      let statusbarView = UIView()
      statusbarView.backgroundColor = color
      statusbarView.frame = CGRect.zero
      view.addSubview(statusbarView)
      statusbarView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        statusbarView.topAnchor.constraint(equalTo: view.topAnchor),
        statusbarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
        statusbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        statusbarView.bottomAnchor.constraint(equalTo: margin.topAnchor)
      ])
      
    } else {
      let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
      statusBar?.backgroundColor = UIColor.mainBlue
    }
  }
  
  func setupNavigationBar(_ color: UIColor) {
    guard let navigationBar = self.navigationController?.navigationBar else { return }
    
    navigationBar.isTranslucent = true
    navigationBar.backgroundColor = color
    navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationBar.shadowImage = UIImage()
  }
  
  func setTabBarHidden(
    _ hidden: Bool,
    animated: Bool = true,
    duration: TimeInterval = 0.3
  ) {
    if self.tabBarController?.tabBar.isHidden != hidden {
      if animated {
        //Show the tabbar before the animation in case it has to appear
        if (self.tabBarController?.tabBar.isHidden)! {
          self.tabBarController?.tabBar.isHidden = hidden
        }
        if let frame = self.tabBarController?.tabBar.frame {
          let factor: CGFloat = hidden ? 1 : 0
          let y = frame.origin.y + (frame.size.height * factor)
          
          UIView.animate(withDuration: duration, animations: {
            self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
          }) { (bool) in
            //hide the tabbar after the animation in case ti has to be hidden
            if (!(self.tabBarController?.tabBar.isHidden)!) {
              self.tabBarController?.tabBar.isHidden = hidden
            }
          }
        }
      }
    }
  }
}
