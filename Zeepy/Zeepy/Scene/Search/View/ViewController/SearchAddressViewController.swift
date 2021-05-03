//
//  SearchAddressViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/02.
//

import SnapKit
import Then
import UIKit

class SearchAddressViewController: BaseViewController {
  // MARK: - Components
  let titleLabel = UILabel()
  let searchTextFieldContainerView = UIView()
  let searchTextField = UITextField()
  let searchButton = UIButton()
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
  }

}
// MARK: - Extensions
extension SearchAddressViewController {
  // MARK: - Helpers
  func layoutTitleLabel() {
    self.view.add(titleLabel) {
      $0.text = "주소 검색"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(19)
      }
    }
  }
  func layoutSearchTextFieldContainerView() {
    self.view.add(searchTextFieldContainerView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
        $0.height.equalTo(32)
      }
    }
  }
  func layoutSearchTextField() {
    let placeholderText = NSMutableAttributedString(string: "주소를 입력해주세요",
                                                    attributes: [
                                                      .font: UIFont.nanumRoundRegular(fontSize: 12),
                                                      .foregroundColor: UIColor.grayText])
    let searchIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 37.5, height: 16))
    searchIconContainerView.backgroundColor = .clear
    let searchIconImageView = UIImageView(image: UIImage(named: "iconSearch"))
    searchIconImageView.frame = CGRect(x: 12.5, y: 0, width: 16, height: 16)
    searchIconContainerView.add(searchIconImageView)
    self.searchTextFieldContainerView.add(self.searchTextField) {
      $0.attributedPlaceholder = placeholderText
      $0.setBorder(borderColor: .mainBlue, borderWidth: 1)
      $0.setRounded(radius: 16)
      $0.leftView = searchIconContainerView
      $0.leftViewMode = .always
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.searchTextFieldContainerView.snp.edges)
      }
    }
  }
  func layoutSearchButton() {
    searchTextFieldContainerView.add(searchButton) {
      $0.setTitle("검색", for: .normal)
      $0.setTitleColor(.mainBlue, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 12)
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.top.equalTo(self.searchTextFieldContainerView.snp.top)
        $0.bottom.equalTo(self.searchTextFieldContainerView.snp.bottom)
        $0.trailing.equalTo(self.searchTextFieldContainerView.snp.trailing)
        $0.width.equalTo(self.view.frame.width*60/375)
      }
    }
  }
  func layout() {
    layoutTitleLabel()
    layoutSearchTextFieldContainerView()
    layoutSearchTextField()
    layoutSearchButton()
  }
}
