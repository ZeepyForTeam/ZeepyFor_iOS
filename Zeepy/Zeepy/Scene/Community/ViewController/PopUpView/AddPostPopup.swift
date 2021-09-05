//
//  AddPostPopup.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class AddPostPopup : UIView {
  private var disposeBag = DisposeBag()
  var popUpView = PopUpView.shared
  typealias customAction = () -> Void
  private var isCommunity: Bool!
  convenience init(isCommunity: Bool) {
    self.init(frame: .zero)
    self.isCommunity = isCommunity
    
    layout()
    bind()
  }
  deinit {
    print("DEINIT: \(self.className)")
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let titleLabel = UILabel().then {
    $0.setupLabel(text: "리뷰를 등록하시겠습니까?", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
  }
  private let notice1 = UILabel().then {
    $0.numberOfLines = 2
    
    $0.setupLabel(text: """
*리뷰 등록 후에는 수정하거나 삭제하실 수 없으니 글 작성에 유의해주세요.

""", color: .grayText, font: .nanumRoundBold(fontSize: 12), align: .center)
  }
  private let notice2 = UILabel().then {
    $0.numberOfLines = 2
    
    $0.setupLabel(text: """
*허위/중복/성의없는 정보 또는 비방글을 작성할 경우, 서비스 이용이 제한될 수 있습니다.
""", color: .grayText, font: .nanumRoundBold(fontSize: 12), align: .center)
  }
  let okButton = UIButton().then{
    $0.setTitle("확인", for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .communityGreen
    $0.setRounded(radius: 8)
  }
  let cancleBtn = UIButton ().then {
    $0.setTitle("취소", for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setTitleColor(.communityGreen, for: .normal)
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  var resultClosure: ((Bool) -> ())?
  private func layout() {
    self.adds([titleLabel,notice1, notice2, okButton, cancleBtn])
    titleLabel.snp.remakeConstraints{
      $0.top.equalToSuperview().offset(48)
      $0.centerX.equalToSuperview()
    }
    notice1.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(13)
    }
    notice2.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(notice1.snp.bottom).offset(5)
    }
    okButton.snp.remakeConstraints{
      $0.top.equalTo(notice2.snp.bottom).offset(31)
      $0.trailing.equalToSuperview().offset(-12)
      $0.bottom.equalToSuperview().offset(-16)
      $0.height.equalTo(48)
    }
    cancleBtn.snp.remakeConstraints{
      $0.centerY.equalTo(okButton)
      $0.trailing.equalTo(okButton.snp.leading).offset(-10)
      $0.leading.equalToSuperview().offset(12)
      $0.width.equalTo(okButton)
      $0.height.equalTo(48)
    }
    
  }
  private func bind() {
    if isCommunity {
      titleLabel.text = "글을 등록하시겠습니까"
      notice1.text = """
        *공동구매 글의 경우 참여자가 1명 이상일
        경우 글을 삭제하거나 수정하실 수 없습니다.
        """
      okButton.setTitleColor(.white, for: .normal)
      okButton.backgroundColor = .communityGreen
      cancleBtn.setTitleColor(.communityGreen, for: .normal)
      cancleBtn.backgroundColor = .gray244
    }
    else {
      okButton.setTitleColor(.white, for: .normal)
      okButton.backgroundColor = .mainBlue
      cancleBtn.setTitleColor(.mainBlue, for: .normal)
      cancleBtn.backgroundColor = .gray244
    }
    okButton.rx.tap.map{return true}
      .bind{[weak self] content in
        if let closure = self?.resultClosure {
          closure(content)
        }
//        self?.disposeBag = DisposeBag()
        self?.popUpView.dissmissFromSuperview()
      }.disposed(by: disposeBag)
    cancleBtn.rx.tap.map{return false}
      .bind{[weak self] content in
        if let closure = self?.resultClosure {
          closure(content)
        }
//        self?.disposeBag = DisposeBag()
        self?.popUpView.dissmissFromSuperview()
      }.disposed(by: disposeBag)
  }
}
