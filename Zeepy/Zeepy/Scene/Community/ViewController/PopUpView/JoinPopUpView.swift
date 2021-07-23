//
//  JoinPopUpView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class JoinPopUpView : UIView {
  private let disposeBag = DisposeBag()
  var popUpView = PopUpView.shared
  typealias customAction = () -> Void
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let titleLabel = UILabel().then {
    let attributedString = NSMutableAttributedString(string: "(필수) 아래 내용 입력 후 참여를 확정하세요!", attributes: [
      .font: UIFont.nanumRoundExtraBold(fontSize: 14),
      .foregroundColor: UIColor.blackText
    ])
    attributedString.addAttribute(.foregroundColor, value: UIColor.communityGreen, range: NSRange(location: 0, length: 5))
    attributedString.addAttribute(.font, value: UIFont.nanumRoundRegular(fontSize: 14), range: NSRange(location: 14, length: 2))
    attributedString.addAttribute(.font, value: UIFont.nanumRoundRegular(fontSize: 14), range: NSRange(location: 18, length: 2))
    attributedString.addAttribute(.font, value: UIFont.nanumRoundRegular(fontSize: 14), range: NSRange(location: 22, length: 4))
    $0.attributedText = attributedString
  }
  let contentTextView = UITextView().then {
    $0.font = .nanumRoundBold(fontSize: 12)
    $0.setRounded(radius: 10)
    $0.borderWidth = 1
    $0.borderColor = .grayText
  }
  let addJoinBtn = UIButton().then{
    $0.setTitle("댓글 작성하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.setTitleColor(.gray196, for: .disabled)
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  var resultClosure: ((String) -> ())?
  private func layout() {
    self.adds([titleLabel,contentTextView, addJoinBtn])
    titleLabel.snp.remakeConstraints{
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    contentTextView.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.height.equalTo(106)
    }
    addJoinBtn.snp.remakeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(contentTextView)
      $0.top.equalTo(contentTextView.snp.bottom).offset(8)
      $0.bottom.equalToSuperview().offset(-16)
      $0.height.equalTo(48)
    }
  }
  private func bind() {
    contentTextView.rx.text.map{$0?.isEmpty == false}
      .bind(to: addJoinBtn.rx.isEnabled)
      .disposed(by: disposeBag)
    addJoinBtn.rx.tap
      .withLatestFrom(contentTextView.rx.text)
      .bind{[weak self] content in
        if let content = content {
          if let closure = self?.resultClosure {
            closure(content)
          }
          self?.popUpView.dissmissFromSuperview()
        }
      }.disposed(by: disposeBag)
  }
}
