//
//  ReportNoticeView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class ReportNoticeView : UIView {
  private let disposeBag = DisposeBag()
  var popUpView = PopUpView.shared
  typealias customAction = () -> Void
  override init(frame: CGRect) {
    super.init(frame: frame)
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
    $0.setupLabel(text: "정말 신고하시겠어요?", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
  }
  private let notice1 = UILabel().then {
    $0.numberOfLines = 2
    
    $0.setupLabel(text: """
*신고 후에는 신고 내용을 수정하거나
취소하실 수 없습니다.
""", color: .grayText, font: .nanumRoundBold(fontSize: 12), align: .center)
  }
  private let notice2 = UILabel().then {
    $0.numberOfLines = 2
    
    $0.setupLabel(text: """
*악의적인 의도나 허위로 신고할 경우에는
서비스 이용이 제한될 수 있습니다.
""", color: .grayText, font: .nanumRoundBold(fontSize: 12), align: .center)
  }
  let reportBtn = UIButton().then{
    $0.setTitle("확인했으며, 신고할게요", for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .mainYellow2
    $0.setRounded(radius: 8)
  }
  let cancleBtn = UIButton ().then {
    $0.setTitle("취소", for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setTitleColor(.mainYellow2, for: .normal)
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  var resultClosure: ((Bool) -> ())?
  private func layout() {
    self.adds([titleLabel,notice1, notice2, reportBtn, cancleBtn])
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
    reportBtn.snp.remakeConstraints{
      $0.top.equalTo(notice2.snp.bottom).offset(31)
      $0.trailing.equalToSuperview().offset(-12)
      $0.bottom.equalToSuperview().offset(-16)
      $0.height.equalTo(48)
    }
    cancleBtn.snp.remakeConstraints{
      $0.centerY.equalTo(reportBtn)
      $0.trailing.equalTo(reportBtn.snp.leading).offset(-10)
      $0.leading.equalToSuperview().offset(12)
      $0.width.equalTo(reportBtn).multipliedBy(0.5)
      $0.height.equalTo(48)

    }
  }
  private func bind() {
//
//    reportBtn.rx.tap
//      .bind{[weak self] content in
//        if let content = content {
//          if let closure = self?.resultClosure {
//            closure(content)
//          }
//          self?.popUpView.dissmissFromSuperview()
//        }
//      }.disposed(by: disposeBag)
  }
}
