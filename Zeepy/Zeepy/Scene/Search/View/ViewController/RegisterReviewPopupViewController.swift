//
//  RegisterReviewPopupViewController.swift
//  Zeepy
//
//  Created by λΈνμ on 2021/08/10.
//

import UIKit

import Moya
import RxSwift
import RxCocoa
import SnapKit
import Then

// MARK: - RegisterReviewPopupViewController
class RegisterReviewPopupViewController: UIViewController {
  
  // MARK: - Components
  private let cardView = UIView()
  private let titleLabel = UILabel()
  private let firstContextLabel = UILabel()
  private let secondContextLabel = UILabel()
  private let cancelButton = UIButton()
  private let registerButton = UIButton()
  
  // MARK: - Variables
  private let reviewService = ReviewService(provider: MoyaProvider<ReviewRouter>(plugins:[NetworkLoggerPlugin()]))
  private let disposeBag = DisposeBag()
  var reviewModel = ReviewModel(address: "",
                                buildingID: 0,
                                communcationTendency: "",
                                furnitures: [],
                                imageUrls: [],
                                lessorAge: "",
                                lessorGender: "",
                                lessorReview: "",
                                lightning: "",
                                pest: "",
                                review: "",
                                roomCount: "",
                                soundInsulation: "",
                                totalEvaluation: "",
                                waterPressure: "")
  
  var resultClosure: ((Bool) -> ())?
  private var registerResult: Bool = false

  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
  
  override func viewDidLayoutSubviews() {
    self.cardView.snp.remakeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(self.view.frame.width * 288/375)
      $0.bottom.equalTo(self.registerButton.snp.bottom).offset(16)
    }
  } 
}

// MARK: - Extensions
extension RegisterReviewPopupViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    view.backgroundColor = .popupBackground
    layoutCardView()
    layoutTitleLabel()
    layoutFirstContextLabel()
    layoutSecondContextLabel()
    layoutCancelButton()
    layoutRegisterButton()
  }
  
  private func layoutCardView() {
    view.add(cardView) {
      $0.backgroundColor = .white
      $0.setRounded(radius: 10)
      $0.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(self.view.frame.width * 288/375)
        $0.height.equalTo(self.view.frame.width * 247/375)
      }
    }
  }
  
  private func layoutTitleLabel() {
    cardView.add(titleLabel) {
      $0.setupLabel(text: "λ¦¬λ·°λ₯Ό λ±λ‘νμκ² μ΅λκΉ?",
                    color: .blackText,
                    font: .nanumRoundExtraBold(fontSize: 18))
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(self.cardView.snp.top).offset(46)
      }
    }
  }
  
  private func layoutFirstContextLabel() {
    cardView.add(firstContextLabel) {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 5
      titleParagraphStyle.alignment = .center
      let titleText = NSMutableAttributedString(
        string: "*λ¦¬λ·° λ±λ‘ νμλ μμ νκ±°λ μ­μ νμ€ μ\nμμΌλ κΈ μμ±μ μ μν΄μ£ΌμΈμ",
        attributes: [
          .font: UIFont.nanumRoundBold(fontSize: 12),
          .foregroundColor: UIColor.grayText])
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      $0.attributedText = titleText
      $0.numberOfLines = 0
      $0.snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(17)
        $0.centerX.equalToSuperview()
        
      }
    }
  }
  
  private func layoutSecondContextLabel() {
    cardView.add(secondContextLabel) {
      let titleParagraphStyle = NSMutableParagraphStyle()
      titleParagraphStyle.lineSpacing = 5
      titleParagraphStyle.alignment = .center
      let titleText = NSMutableAttributedString(
        string: "*νμ/μ€λ³΅/μ±μμλ μ λ³΄ λλ λΉλ°©κΈμ\nμμ±ν  κ²½μ°, μλΉμ€ μ΄μ©μ΄ μ νλ  μ μμ΅λλ€.",
        attributes: [.font: UIFont.nanumRoundBold(fontSize: 12),
                     .foregroundColor: UIColor.grayText])
      titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: titleParagraphStyle,
                             range: NSMakeRange(0, titleText.length))
      $0.attributedText = titleText
      $0.numberOfLines = 0
      $0.snp.makeConstraints {
        $0.top.equalTo(self.firstContextLabel.snp.bottom).offset(10)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  private func layoutCancelButton() {
    cardView.add(cancelButton) {
      $0.setupButton(title: "μ·¨μ",
                     color: .mainBlue,
                     font: .nanumRoundExtraBold(fontSize: 14),
                     backgroundColor: .gray249,
                     state: .normal,
                     radius: 8)
      $0.addTarget(self, action: #selector(self.cancelButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.trailing.equalTo(self.cardView.snp.centerX).offset(-5)
        $0.leading.equalTo(self.cardView.snp.leading).offset(12)
        $0.top.equalTo(self.secondContextLabel.snp.bottom).offset(31)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  private func layoutRegisterButton() {
    cardView.add(registerButton) {
      $0.setupButton(title: "νμΈ",
                     color: .white,
                     font: .nanumRoundExtraBold(fontSize: 14),
                     backgroundColor: .mainBlue,
                     state: .normal,
                     radius: 8)
      $0.addTarget(self, action: #selector(self.registerButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.cardView.snp.centerX).offset(5)
        $0.trailing.equalTo(self.cardView.snp.trailing).offset(-12)
        $0.top.equalTo(self.secondContextLabel.snp.bottom).offset(31)
        $0.height.equalTo(self.view.frame.width * 48/375)
      }
    }
  }
  
  // MARK: - Action Helpers
  @objc
  private func cancelButtonClicked() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func registerButtonClicked() {
    reviewModel.imageUrls = []
    registerReview()
  }
  
  // MARK: - General Helpers
  private func registerReview() {
    let vc = self.presentingViewController?.children[0] as? TabbarViewContorller
    // TODO: - Server Connection
    reviewService.addReview(param: reviewModel)
      .subscribe(onNext: {[weak self] result in
        if result {
          do {
            print("success")

           
            self?.dismiss(animated: false, completion: {
              self?.registerResult = true
              if let closure = self?.resultClosure {
                   closure(self?.registerResult == true)
              }
            })
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
}
