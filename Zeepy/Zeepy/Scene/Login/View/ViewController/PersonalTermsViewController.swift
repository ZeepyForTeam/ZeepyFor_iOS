//
//  PersonalTermsViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/26.
//

import UIKit
import WebKit

import SnapKit
import Then

class PersonalTermsViewController: BaseViewController {
  
  private let navigationView = CustomNavigationBar()
  
  lazy var webView: WKWebView = {
    let view = WKWebView()
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    request(url: "https://zeepy.creatorlink.net/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4%EC%B2%98%EB%A6%AC%EB%B0%A9%EC%B9%A8")
    setupNavigation()
    self.view.adds([navigationView,
                    webView])
    self.navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    self.webView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.equalTo(self.navigationView.snp.bottom)
    }
  }
  
  private func request(url: String) {
    self.webView.load(URLRequest(url: URL(string: url)!))
  }
  
  private func setupNavigation() {
    navigationView.naviTitle.text = "개인정보 이용약관"
  }
}
