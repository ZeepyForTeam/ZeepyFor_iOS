//
//  TabbarViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/04.
//

import Foundation
import UIKit

class TabbarViewContorller : UITabBarController {
  var defaultIndex = 0 {
    didSet {
      self.selectedIndex = defaultIndex
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.selectedIndex = defaultIndex
    self.tabBar.layer.borderWidth = 0.6
//    self.tabBar.layer.borderColor = lineColor.cgColor
  }

}
extension TabbarViewContorller : UITabBarControllerDelegate {
//  override func viewDidLayoutSubviews() {
//      super.viewDidLayoutSubviews()
//      tabBar.frame.size.height = 95
//      tabBar.frame.origin.y = view.frame.height - 95
//  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let tab1NavigationController =  HomeViewController()

//    let tab2NavigationController =  LookAroundViewController()
    let tab2NavigationController = MapViewController()
    let tab3NavigationController = CommunityViewController()
    let tab4NavigationController = MyPageViewController()
    let vc = [tab1NavigationController, tab2NavigationController, tab3NavigationController, tab4NavigationController]
    self.setViewControllers(vc, animated: true)

    let tabBar: UITabBar = self.tabBar
    tabBar.backgroundColor = UIColor.clear
    tabBar.barStyle = UIBarStyle.default
    tabBar.barTintColor = UIColor.white
    
    let imageNames = ["tabHomeInact", "tabSearchInact", "tabCommunityInact", "tabMyInact"]
    let imageSelectedNames = ["tabHomeAct", "tabSearchAct", "tabCommunityAct", "tabMyAct"]

    for (ind, value) in (tabBar.items?.enumerated())! {
      let tabBarItem: UITabBarItem = value as UITabBarItem
      tabBarItem.title = nil
      tabBarItem.image = UIImage(named: imageNames[ind])?.withRenderingMode(.alwaysOriginal)
      tabBarItem.selectedImage = UIImage(named: imageSelectedNames[ind])?.withRenderingMode(.alwaysOriginal)
      tabBarItem.accessibilityIdentifier = imageNames[ind]
      tabBarItem.imageInsets.top = 15
      tabBarItem.imageInsets.bottom = -15
    }
  }
}
