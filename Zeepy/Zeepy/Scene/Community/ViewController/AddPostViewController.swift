//
//  AddPostViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddPostViewContoller : BaseViewController {
  private let postType : PostType!
  private let viewModel : AddPostViewModel!
  init?(nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?,
        postType : PostType,
        viewModel : AddPostViewModel) {
    self.postType = postType
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "글 작성하기")
  }
  private let scrollView = UIScrollView()
  private let contentView = UIView().then{
    $0.backgroundColor = .white
  }
  private let titleNotice = UILabel().then{
    $0.text = "글 제목"
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let titleTextField = CustomTextField().then {
    $0.placeholder = "글의 제목을 입력해주세요"
  }
  private let contentNotice = UILabel().then {
    $0.setupLabel(text: "공구 소개", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private let contentTextView = CustomTextView().then {
    $0.isScrollEnabled = true
  }
  private var placeholder: String = ""
  private let infoNotice = UILabel().then{
    $0.text = "구매정보 입력"
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let productTitle = CustomTextField().then {
    $0.placeholder = "제품명(ex. 삼다수 1.5L)"
  }
  private let productPrice = CustomTextField().then {
    $0.placeholder = "제품금액 (ex. 15,000원)"
    $0.keyboardType = .numberPad
  }
  private let productMall = CustomTextField().then {
    $0.placeholder = "구매 장소 (ex. 쿠팡, 동네 슈퍼 등)"
  }
  private let productMethod = CustomTextField().then {
    $0.placeholder = "거래 방식 (택배/직거래/만남장소 등))"
  }
  private let memberNotice = UILabel().then{
    $0.text = "목표 인원"
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let memberNumber = CustomTextField().then {
    $0.placeholder = "ex. 3"
    $0.keyboardType = .numberPad
  }
  private let peopleCount = UILabel().then {
    $0.text = "명"
    $0.textColor = .blackText
    $0.font = .nanumRoundRegular(fontSize: 14)
  }
  private let memberInfoNotice = UILabel().then{
    $0.text = "참여자에게 어떤 내용을 받을까요?"
    $0.textColor = .blackText
    $0.font = .nanumRoundExtraBold(fontSize: 14)
  }
  private let productNameCheckBox = checkBox().then{
    $0.checkLabel.text = "제품명"
  }
  private let buyCountCheckBox = checkBox().then{
    $0.checkLabel.text = "구매개수"
  }
  private let tradeWayCheckBox = checkBox().then{
    $0.checkLabel.text = "거래방식"
  }
  private let kakakoIdCheckBox = checkBox().then{
    $0.checkLabel.text = "카카오톡ID"
  }
  private let phoneNumberCheckBox = checkBox().then{
    $0.checkLabel.text = "휴대폰번호"
  }
  
  private let nextButtonBackground = UIView().then{
    $0.addline(at: .top)
    $0.backgroundColor = .white
  }
  private let nextButton = UIButton().then{
    $0.setTitle("다음으로", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    $0.setRounded(radius: 8)
    $0.backgroundColor = .communityGreen
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    layout(type: postType)
    self.hideKeyboardWhenTappedAround()
    bind()
    nextButton.rx.tap.bind{[weak self] in
      guard let self = self else {return}
      guard let vc = AddPhotoViewController(nibName: nil, bundle: nil, viewModel: self.viewModel) else {return}
      vc.hidesBottomBarWhenPushed = true
      
      self.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
  }
  private let memberCheckInfo = BehaviorSubject<CheckBoxContent>(value: .productNameCheckBox)
  private let textCounter = UILabel().then {
    $0.setupLabel(text: "", color: .grayText, font: .nanumRoundRegular(fontSize: 11))
  }
  func addTextCounter(maxVal: Int = 100) {
    contentView.add(textCounter)
    textCounter.snp.makeConstraints{
      $0.trailing.equalTo(contentTextView).offset(-8)
      $0.bottom.equalTo(contentTextView).offset(-4)
    }
    contentTextView.rx.text.orEmpty.asObservable().map{($0, $0.count)}
      .share()
      .bind{[weak self] text, count in
        if text == self?.placeholder {
          self?.textCounter.textColor = .grayText
          self?.textCounter.text = "\(0)/\(maxVal)자"
        }
        if count >= maxVal {
          self?.textCounter.textColor = .red
          self?.contentTextView.resignFirstResponder()
        }
        else {
          self?.textCounter.textColor = .grayText
          self?.textCounter.text = "\(count)/\(maxVal)자"
        }
      }.disposed(by: disposeBag)
  }
}
extension AddPostViewContoller {
  private func layout(type : PostType) {
    self.view.adds([naviView,
                    scrollView,
                    nextButtonBackground])
    naviView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    scrollView.snp.makeConstraints{
      $0.width.leading.trailing.equalToSuperview()
      $0.top.equalTo(naviView.snp.bottom)
      $0.bottom.equalTo(nextButtonBackground.snp.top)
    }
    scrollView.add(contentView)
    contentView.snp.makeConstraints{
      $0.top.leading.trailing.bottom.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalToSuperview().priority(250)
    }
    switch type {
    case .deal:
      auctionLayout()
    default :
      basicLayout()
    }
  }
  private func basicLayout() {
    contentView.adds([titleNotice,
                      titleTextField,
                      infoNotice,
                      productTitle,
                      productPrice,
                      contentNotice,
                      contentTextView])
    
    titleNotice.snp.makeConstraints{
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    titleTextField.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.top.equalTo(titleNotice.snp.bottom).offset(10)
    }
    contentNotice.snp.makeConstraints{
      $0.top.equalTo(titleTextField.snp.bottom).offset(36)
      $0.leading.equalToSuperview().offset(16)
    }
    contentTextView.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(278).priority(.medium)
      $0.top.equalTo(contentNotice.snp.bottom).offset(10)
    }
    
    nextButtonBackground.add(nextButton)
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
    contentNotice.text = "글 내용"
    placeholder = "*ZEEPY 이용정책에 위반되는 게시글의 경우\n무통보 게시글 삭제 및 이용이 제재될 수 있습니다.  "
    contentTextView.setPlaceholder(placeholder: placeholder, disposeBag: disposeBag)
    addTextCounter(maxVal: 1500)

  }
  private func auctionLayout() {
    contentView.adds([titleNotice,
                      titleTextField,
                      infoNotice,
                      productTitle,
                      productPrice,
                      contentNotice,
                      contentTextView,
                      productMall,
                      productMethod,
                      memberNotice,
                      memberNumber,
                      peopleCount,
                      memberInfoNotice,
                      productNameCheckBox,
                      buyCountCheckBox,
                      tradeWayCheckBox,
                      kakakoIdCheckBox,
                      phoneNumberCheckBox])
    
    titleNotice.snp.makeConstraints{
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    titleTextField.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.top.equalTo(titleNotice.snp.bottom).offset(10)
    }
    contentNotice.snp.makeConstraints{
      $0.top.equalTo(titleTextField.snp.bottom).offset(36)
      $0.leading.equalToSuperview().offset(16)
    }
    contentTextView.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(90)
      $0.top.equalTo(contentNotice.snp.bottom).offset(10)
    }
    infoNotice.snp.makeConstraints{
      $0.top.equalTo(contentTextView.snp.bottom).offset(36)
      $0.leading.equalToSuperview().offset(16)
    }
    productTitle.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.top.equalTo(infoNotice.snp.bottom).offset(10)
    }
    productPrice.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.top.equalTo(productTitle.snp.bottom).offset(10)
    }
    productMall.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.top.equalTo(productPrice.snp.bottom).offset(10)
    }
    productMethod.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.top.equalTo(productMall.snp.bottom).offset(10)
    }
    memberNotice.snp.makeConstraints{
      $0.top.equalTo(productMethod.snp.bottom).offset(36)
      $0.leading.equalToSuperview().offset(16)
    }
    memberNumber.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(44)
      $0.width.equalTo(116)
      $0.top.equalTo(memberNotice.snp.bottom).offset(10)
    }
    peopleCount.snp.makeConstraints{
      $0.centerY.equalTo(memberNumber)
      $0.leading.equalTo(memberNumber.snp.trailing).offset(8)
    }
    memberInfoNotice.snp.makeConstraints{
      $0.top.equalTo(memberNumber.snp.bottom).offset(53)
      $0.leading.equalToSuperview().offset(16)
    }
    productNameCheckBox.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(memberInfoNotice.snp.bottom).offset(17)
      $0.height.equalTo(22)

    }
    buyCountCheckBox.snp.makeConstraints{
      $0.leading.equalTo(productNameCheckBox.snp.trailing).offset(24)
      $0.centerY.equalTo(productNameCheckBox)
      $0.height.equalTo(22)

    }
    tradeWayCheckBox.snp.makeConstraints{
      $0.leading.equalTo(buyCountCheckBox.snp.trailing).offset(24)
      $0.centerY.equalTo(productNameCheckBox)
      $0.height.equalTo(22)

    }
    kakakoIdCheckBox.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(productNameCheckBox.snp.bottom).offset(14)
      $0.height.equalTo(22)
    }
    phoneNumberCheckBox.snp.makeConstraints{
      $0.leading.equalTo(kakakoIdCheckBox.snp.trailing).offset(24)
      $0.centerY.equalTo(kakakoIdCheckBox)
      $0.bottom.equalToSuperview().offset(-47)
      $0.height.equalTo(22)
    }
    nextButtonBackground.add(nextButton)
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
    placeholder = "공동구매를 간단히 소개해주세요. (100자 이내)"
    contentTextView.setPlaceholder(placeholder: placeholder, disposeBag: disposeBag)
    addTextCounter()

  }
  private func bind() {
    let input = AddPostViewModel.ContentInput(titleText: titleTextField.rx.text.asObservable(),
                                              contentText: contentTextView.rx.text.asObservable(),
                                              productTitle: productTitle.rx.text.asObservable(),
                                              productPrice: productPrice.rx.text.map{
                                                if $0.isNotNil {
                                                  return $0
                                                }
                                                else {
                                                  return nil
                                                }
                                              }.asObservable(),
                                              productMall: productMall.rx.text.asObservable(),
                                              tradeType: productMethod.rx.text.asObservable(),
                                              targetMember: memberNumber.rx.text.map{
                                                if $0.isNotNil {
                                                  return Int($0!)
                                                }
                                                else {
                                                  return nil
                                                }
                                              }.asObservable(),
                                              memberInfo: memberCheckInfo)
    let output = viewModel.MutateContent(input: input)
    output.checkedContent.bind{[weak self] checked in
      self?.productNameCheckBox.checkBtn.isSelected = checked == .productNameCheckBox
      self?.productNameCheckBox.checkLabel.textColor = checked == .productNameCheckBox ? .blackText : .grayText
      
      self?.buyCountCheckBox.checkBtn.isSelected = checked == .buyCountCheckBox
      self?.buyCountCheckBox.checkLabel.textColor = checked == .buyCountCheckBox ? .blackText : .grayText

      self?.tradeWayCheckBox.checkBtn.isSelected = checked == .tradeWayCheckBox
      self?.tradeWayCheckBox.checkLabel.textColor = checked == .tradeWayCheckBox ? .blackText : .grayText

      self?.kakakoIdCheckBox.checkBtn.isSelected = checked == .kakakoIdCheckBox
      self?.kakakoIdCheckBox.checkLabel.textColor = checked == .kakakoIdCheckBox ? .blackText : .grayText

      self?.phoneNumberCheckBox.checkBtn.isSelected = checked == .phoneNumberCheckBox
      self?.phoneNumberCheckBox.checkLabel.textColor = checked == .phoneNumberCheckBox ? .blackText : .grayText

    }.disposed(by: disposeBag)
    output.isEnabled.bind{ [weak self] in
      self?.nextButton.isEnabled = $0
      if $0 {
        self?.nextButton.backgroundColor = .communityGreen
        self?.nextButton.setTitleColor(.white, for: .normal)
      }
      else {
        self?.nextButton.backgroundColor = .gray244
        self?.nextButton.setTitleColor(.blackText, for: .normal)
      }
    }.disposed(by: disposeBag)
    contentTextView.rx.observeWeakly(CGSize.self, "contentSize")
      .compactMap { $0?.height }
      .filter{$0 > 90}
      .distinctUntilChanged()
      .bind{ [weak self] height in
        self?.contentTextView.snp.updateConstraints{
          $0.height.equalTo(height).priority(.medium)
        }
      }
      .disposed(by: disposeBag)
    productPrice.rx.controlEvent(.editingDidEnd)
      .map{[weak self] in
        self?.productPrice.text ?? ""
      }.bind{[weak self] price in
        if price.contains("원") == true {
          //이미 전환됨
        }
        else {
          if let value = Int(price) {
            self?.productPrice.text = NumberFormatter().makeDecimalFormat(value) + "원"
          }
        }
      }.disposed(by: disposeBag)
    productPrice.rx.controlEvent(.editingDidBegin)
      .map{[weak self] in
        self?.productPrice.text ?? ""
      }.bind{[weak self] price in
        if price.contains("원") == true {
          var current = price
          current.removeLast()
          let splits = current.split(separator: ",").map{String($0)}.reduce(""){$0 + $1}
          self?.productPrice.text = splits
        }
      }.disposed(by: disposeBag)
    productNameCheckBox.checkBtn.rx.tap.map{_ -> CheckBoxContent in
      return .productNameCheckBox
    }.bind(to: memberCheckInfo).disposed(by: disposeBag)
    buyCountCheckBox.checkBtn.rx.tap.map{_ -> CheckBoxContent in
      return .buyCountCheckBox
    }.bind(to: memberCheckInfo).disposed(by: disposeBag)
    tradeWayCheckBox.checkBtn.rx.tap.map{_ -> CheckBoxContent in
      return .tradeWayCheckBox}.bind(to: memberCheckInfo).disposed(by: disposeBag)
    kakakoIdCheckBox.checkBtn.rx.tap.map{_ -> CheckBoxContent in
      return .kakakoIdCheckBox}.bind(to: memberCheckInfo).disposed(by: disposeBag)
    phoneNumberCheckBox.checkBtn.rx.tap.map{_ -> CheckBoxContent in
      return .phoneNumberCheckBox}.bind(to: memberCheckInfo).disposed(by: disposeBag)
  }
}

enum CheckBoxContent : String {
  case productNameCheckBox = "제품명"
  case buyCountCheckBox = "구매개수"
  case tradeWayCheckBox = "거래방식"
  case kakakoIdCheckBox = "카카오톡"
  case phoneNumberCheckBox = "휴대폰번호"
}
extension CheckBoxContent {
  var requestVersion : String? {
    switch self {
    
    case .productNameCheckBox:
      return ""
    case .buyCountCheckBox:
      return ""
    case .tradeWayCheckBox:
      return ""
    case .kakakoIdCheckBox:
      return ""
    case .phoneNumberCheckBox:
      return ""
    }
  }
}
