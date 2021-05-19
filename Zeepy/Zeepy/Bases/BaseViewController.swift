//
//  BaseViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/15.
//

import Foundation
import UIKit
import RxSwift
class BaseViewController: UIViewController, UIPopoverPresentationControllerDelegate{

  private func swipeRecognizer() {
    let popGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer!
    if let targets = popGestureRecognizer?.value(forKey: "targets") as? NSMutableArray {
      let gestureRecognizer = UIPanGestureRecognizer()
      gestureRecognizer.setValue(targets, forKey: "targets")
      self.view.addGestureRecognizer(gestureRecognizer)
    }
  }
  

  enum HudAction: Int {
    case show = 1, hideWithSucces, hideWithError, hideWithInfo, dismiss
  }

  private var scrollViewContainer: UIScrollView?
  private var appDelegate = UIApplication.shared.delegate as! AppDelegate

  @objc
  func keyboardWillShow(_ notification: Notification) {
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue

    if let scrollViewContainer = scrollViewContainer {
      scrollViewContainer.contentInset.bottom = keyboardRectangle.height
    }
  }

  @objc
  func keyboardWillHide(_ notification: Notification) {
    if let scrollViewContainer = scrollViewContainer {
      scrollViewContainer.contentInset.bottom = 0
    }
  }

  @objc
  func keyboardWillAppear(_ notification: Notification) {

  }

  @objc
  func keyboardDidAppear(_ notification: Notification) {

  }

  @objc
  func keyboardWillDisappear(_ notification: Notification) {

  }

  @objc
  func keyboardDidDisappear(_ notification: Notification) {

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    swipeRecognizer()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    self.navigationController?.isNavigationBarHidden = true

  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    print("deinit")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

