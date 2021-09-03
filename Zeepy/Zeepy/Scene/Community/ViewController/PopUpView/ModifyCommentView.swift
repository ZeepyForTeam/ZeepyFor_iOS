//
//  ModifyCommentView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class ModifyCommentView : UIView {
  var popUpView = PopUpView.shared
  typealias customAction = () -> Void
  private var current : String?
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  convenience init(currentComment: String? = nil) {
    self.init(frame: .zero)
    self.current = currentComment
    layout()
    bind()

  }
  deinit {
    print("DEINIT: \(self.className)")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.text = """
      댓글을 수정해주세요!
      """
    $0.font = .nanumRoundExtraBold(fontSize: 14)
    $0.textColor = .blackText
  }
  let contentTextView = UITextView().then {
    $0.font = .nanumRoundBold(fontSize: 12)
    $0.setRounded(radius: 10)
    $0.borderWidth = 1
    //$0.placeholder = "참여자가 있을 때는 글 수정이 제한됩니다."
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
      $0.height.equalTo(40)
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
    contentTextView.text = current
    contentTextView.rx.text.map{$0?.isEmpty == false}
      .bind(to: addJoinBtn.rx.isEnabled)
      .disposed(by: popUpView.disposeBag)
    addJoinBtn.rx.tap
      .withLatestFrom(contentTextView.rx.text)
      .bind{[weak self] content in
        if let content = content {
          if let closure = self?.resultClosure {
            closure(content)
          }
          self?.popUpView.dissmissFromSuperview()
        }
      }.disposed(by: popUpView.disposeBag)
  }
}
