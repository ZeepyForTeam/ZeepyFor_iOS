//
//  PostViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PostViewController : BaseViewController {
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "글 작성하기")
  }
  private let noticelabel = UILabel().then {
    $0.numberOfLines = 2
    let attributedString = NSMutableAttributedString(string: "글의 카테고리를 \n선택해주세요", attributes: [
      .font: UIFont(name: "NanumSquareRoundOTFR", size: 24.0)!,
      .foregroundColor: UIColor.communityGreen
    ])
    attributedString.addAttribute(.font, value: UIFont(name: "NanumSquareRoundOTFEB", size: 24.0)!, range: NSRange(location: 0, length: 7))
    $0.attributedText = attributedString
  }
  private let buyBtn = UIButton().then{
    $0.setTitle("공동 구매", for: .normal)
    $0.setTitleColor(.grayText, for: .normal)
    $0.setTitleColor(.blackText, for: .selected)
    $0.backgroundColor = .gray244
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 10)
    $0.isSelected = false
  }
  private let shareBtn = UIButton().then{
    $0.setTitle("무료 나눔", for: .normal)
    $0.setTitleColor(.grayText, for: .normal)
    $0.setTitleColor(.blackText, for: .selected)
    $0.backgroundColor = .gray244
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 10)
    $0.isSelected = false
  }
  private let friendBtn = UIButton().then{
    $0.setTitle("동네 친구  ", for: .normal)
    $0.setTitleColor(.grayText, for: .normal)
    $0.setTitleColor(.blackText, for: .selected)
    $0.backgroundColor = .gray244
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 10)
    $0.isSelected = false
  }
  private let nextButtonBackground = UIView().then{
    $0.addline(at: .top)
    $0.backgroundColor = .white
  }
  private let nextButton = UIButton().then{
    $0.setTitle("다음으로", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .gray244
    $0.isEnabled = false
  }
  private func layout() {
    self.view.adds([naviView,
                    noticelabel,
                    buyBtn,
                    shareBtn,
                    friendBtn,
                    nextButtonBackground])
    nextButtonBackground.add(nextButton)
    
    naviView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    noticelabel.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(naviView.snp.bottom).offset(16)
    }
    buyBtn.snp.makeConstraints{
      $0.top.equalTo(noticelabel.snp.bottom).offset(68)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(72)
    }
    shareBtn.snp.makeConstraints{
      $0.top.equalTo(buyBtn.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(72)
    }
    friendBtn.snp.makeConstraints{
      $0.top.equalTo(shareBtn.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(72)
    }
    nextButtonBackground.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(102)
    }
    nextButton.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(12)
      $0.height.equalTo(52)
    }
  }
  
  
  let viewModel = AddPostViewModel()
  
  private let postType = PublishSubject<PostType>()
  override func viewDidLoad() {
    super.viewDidLoad()
    if UserManager.shared.address.isEmpty {
      MessageAlertView.shared.showAlertView(title: "현재 주소가 없습니다!\n주소를 등록해주세요!", grantMessage: "확인",mainColor: .communityGreen, okAction: { [weak self] in
        self?.popViewController()
      })
    }
    layout()
    bind()

  }
  private func bind() {
    let input = AddPostViewModel.TypeInput(postType: postType,
                                           nextBtnTap: nextButton.rx.tap.asObservable())
    
    let output = viewModel.selectType(type: input)
    
    output.isSelected.bind{ [weak self] selected in
      if selected {
        self?.nextButton.isEnabled = true
        self?.nextButton.setTitleColor(.white, for: .normal)
        self?.nextButton.backgroundColor = .communityGreen
      }
    }.disposed(by: disposeBag)
    
    output.currentSelection.bind{[weak self] type in
      self?.buyBtn.isSelected = type == .deal
      self?.shareBtn.isSelected = type == .share
      self?.friendBtn.isSelected = type == .friend
      switch type{
      case .total:
        print("")
      case .deal:
        self?.buyBtn.backgroundColor = .white
        self?.shareBtn.backgroundColor = .gray244
        self?.friendBtn.backgroundColor = .gray244
        
        self?.buyBtn.setBorder(borderColor: .communityGreen, borderWidth: 1)
        self?.shareBtn.setBorder(borderColor: .communityGreen, borderWidth: 0)
        self?.friendBtn.setBorder(borderColor: .communityGreen, borderWidth: 0)

      case .share:
        self?.buyBtn.backgroundColor = .gray244
        self?.shareBtn.backgroundColor = .white
        self?.friendBtn.backgroundColor = .gray244
        
        self?.buyBtn.setBorder(borderColor: .communityGreen, borderWidth: 0)
        self?.shareBtn.setBorder(borderColor: .communityGreen, borderWidth: 1)
        self?.friendBtn.setBorder(borderColor: .communityGreen, borderWidth: 0)
      case .friend:
        self?.buyBtn.backgroundColor = .gray244
        self?.shareBtn.backgroundColor = .gray244
        self?.friendBtn.backgroundColor = .white

        self?.buyBtn.setBorder(borderColor: .communityGreen, borderWidth: 0)
        self?.shareBtn.setBorder(borderColor: .communityGreen, borderWidth: 0)
        self?.friendBtn.setBorder(borderColor: .communityGreen, borderWidth: 1)
      }
    }.disposed(by: disposeBag)
    
    output.selectedType.bind{[weak self] vc in
      guard let vc = vc else { return }
      vc.hidesBottomBarWhenPushed = true
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
    
    buyBtn.rx.tap.map{ _ -> PostType in
      return .deal
    }.bind(to: postType)
    .disposed(by: disposeBag)
    shareBtn.rx.tap.map{ _ -> PostType in
      return .share
    }.bind(to: postType)
    .disposed(by: disposeBag)
    friendBtn.rx.tap.map{ _ -> PostType in
      return .friend
    }.bind(to: postType)
    .disposed(by: disposeBag)
  }
}
