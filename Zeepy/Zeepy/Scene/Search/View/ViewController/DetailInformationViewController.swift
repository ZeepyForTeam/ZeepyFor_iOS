//
//  DetailInformationViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/10.
//
import SnapKit
import Then
import UIKit

class DetailInformationViewController: BaseViewController {
  
  let titleLabelNumberOfLine = 2
  let contentScrollView = UIScrollView()
  let titleLabel = UILabel()
  let numberOfRoomTitleLabel = UILabel()
  let numberOfRoomCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  let optionalReviewTitleLabel = UILabel()
  let optionalReviewTableView = UITableView()
  let furnitureOptionTitleLabel = UILabel()
  let furnitureOptionCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  let nextButton = UIButton()
  let separatorView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
 
  
}

extension DetailInformationViewController {
  func layoutContentScrollView() {
    self.view.add(contentScrollView) {
      $0.snp.makeConstraints {
        $0.edges.equalTo(self.view.snp.edges)
      }
    }
  }
  func layoutTitleLabel() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "집에 대한 정보를\n조금 더 알려주세요!",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 9, length: 1))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 15, length: 6))

    self.contentScrollView.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      }
    }
  }
  func layoutNumberOfRoomTitleLabel() {
    self.contentScrollView.add(numberOfRoomTitleLabel) {
      $0.text = "방의 개수는 몇 개인가요?"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(36)
      }
    }
  }
  func layoutNumberOfRoomCollectionView() {
    self.contentScrollView.add(numberOfRoomCollectionView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.top.equalTo(self.numberOfRoomTitleLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.numberOfRoomTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
      }
    }
  }
  func layoutOptionalReviewTitleLabel() {
    self.contentScrollView.add(optionalReviewTitleLabel) {
      $0.text = "객관식 리뷰"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.numberOfRoomCollectionView.snp.bottom).offset(64)
      }
    }
  }
  func layoutOptionalReviewTableView() {
    self.contentScrollView.add(optionalReviewTableView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.optionalReviewTitleLabel.snp.bottom).offset(12)
        $0.centerX.equalTo(self.view.snp.centerX)
      }
    }
  }
  func layoutFurnitureOptionTitleLabel() {
    self.contentScrollView.add(furnitureOptionTitleLabel) {
      $0.setupLabel(text: "가구 옵션", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.optionalReviewTableView.snp.bottom).offset(64)
      }
    }
  }
  func layoutNextButton() {
    self.contentScrollView.add(self.nextButton) {
      $0.backgroundColor = .gray244
      $0.setTitle("다음으로", for: .normal)
      $0.setTitleColor(.grayText, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38-(self.tabBarController?.tabBar.frame.height ?? 44))
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  func layoutSeparatorView() {
    self.contentScrollView.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  func layoutFurnitureOptionCollectionView() {
    self.contentScrollView.add(furnitureOptionCollectionView) {
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.furnitureOptionTitleLabel.snp.bottom).offset(12)
        $0.centerX.equalTo(self.view.snp.centerX)
//        $0.bottom.equalTo(self.separatorView.snp.top).offset(-63)
      }
    }
  }
  func layout() {
    layoutContentScrollView()
    layoutTitleLabel()
    layoutNumberOfRoomTitleLabel()
    layoutNumberOfRoomCollectionView()
    layoutOptionalReviewTitleLabel()
    layoutOptionalReviewTableView()
    layoutFurnitureOptionTitleLabel()
    layoutNextButton()
    layoutSeparatorView()
    layoutFurnitureOptionCollectionView()
  }
}
