//
//  ServiceTermsViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/26.
//

import UIKit
import WebKit

import SnapKit
import Then

class ServiceTermsViewController: BaseViewController {
  
  private let navigationView = CustomNavigationBar()
  
  lazy var webView: WKWebView = {
    let view = WKWebView()
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    request(url: "https://zeepy.creatorlink.net/%EC%9D%B4%EC%9A%A9%EC%95%BD%EA%B4%80")
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
    navigationView.naviTitle.text = "서비스 이용약관"
  }
}
