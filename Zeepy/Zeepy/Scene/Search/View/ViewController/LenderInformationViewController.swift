//
//  LenderInformationViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/03.
//

import SnapKit
import Then
import UIKit

class LenderInformationViewController: BaseViewController {
  
  // MARK: - Constants
  private final let titleLabelNumberOfLine = 2
  private final let maxLength = 1500
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let titleLabel = UILabel()
  private let genderTitleLabel = UILabel()
  private let maleButton = UIButton()
  private let femaleButton = UIButton()
  private let ageTitleLabel = UILabel()
  private let ageView = UIView()
  private let ageContextLabel = UILabel()
  private let ageButton = UIButton()
  private let ageUnitLabel = UILabel()
  private let detailTitleLabel = UILabel()
  private let detailTextField = UITextView()
  private let detailTextFieldFooterLabel = UILabel()
  private let nextButton = UIButton()
  private let separatorView = UIView()
  private let countLabel = UILabel()
  
  // MARK: - Variables
  private var selectedGender: String?
  private var selectedAge: String = "UNKNOWN"
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
  private var textCount = 0
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layout()
    setupNavigation()
    notifyTextView()
    addGestureRecognizer()
    configTextView()
  }
}
// MARK: - Extensions
extension LenderInformationViewController {
  
  // MARK: - Layout Helpers
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func layoutTitleLabel() {
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 7
    let titleText = NSMutableAttributedString(string: "임대인에 대해\n조금 더 알려주세요!",
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 24),
                                                .foregroundColor: UIColor.mainBlue])
    titleText.addAttribute(NSAttributedString.Key.paragraphStyle,
                           value: titleParagraphStyle,
                           range: NSMakeRange(0, titleText.length))
    titleText.addAttribute(NSAttributedString.Key.font,
                           value: UIFont.nanumRoundRegular(fontSize: 24),
                           range: NSRange(location: 3, length: 10))

    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
      }
    }
  }
  
  private func layoutGenderTitleLabel() {
    self.view.add(self.genderTitleLabel) {
      $0.text = "성별"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(32)
      }
    }
  }
  
  private func layoutMaleButton() {
    self.view.add(self.maleButton) {
      $0.backgroundColor = .white
      $0.setTitle("남", for: .normal)
      $0.setTitleColor(.blackText, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
      $0.setRounded(radius: 16)
      $0.addTarget(self,
                   action: #selector(self.genderButtonClicked(_:)),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.trailing).offset(22)
        $0.centerY.equalTo(self.genderTitleLabel.snp.centerY)
        $0.width.height.equalTo(32)
      }
    }
  }
  
  private func layoutFemaleButton() {
    self.view.add(self.femaleButton) {
      $0.backgroundColor = .white
      $0.setTitle("여", for: .normal)
      $0.setTitleColor(.blackText, for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
      $0.setRounded(radius: 16)
      $0.addTarget(self,
                   action: #selector(self.genderButtonClicked(_:)),
                   for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.maleButton.snp.trailing).offset(11)
        $0.centerY.equalTo(self.genderTitleLabel.snp.centerY)
        $0.width.height.equalTo(32)
      }
    }
  }
  
  private func layoutAgeTitleLabel() {
    self.view.add(self.ageTitleLabel) {
      $0.text = "연령대"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.genderTitleLabel.snp.centerY)
        $0.leading.equalTo(self.femaleButton.snp.trailing).offset(53)
      }
    }
  }
  
  private func layoutAgeView() {
    self.view.add(self.ageView) {
      $0.backgroundColor = .gray244
      $0.setRounded(radius: 4)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageTitleLabel.snp.centerY)
        $0.leading.equalTo(self.ageTitleLabel.snp.trailing).offset(4)
        $0.width.equalTo(54)
        $0.height.equalTo(24)
      }
    }
  }
  
  private func layoutAgeContextLabel() {
    self.ageView.add(self.ageContextLabel) {
      $0.text = "-"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageView.snp.centerY)
        $0.leading.equalTo(self.ageView.snp.leading).offset(15)
      }
    }
  }
  
  private func layoutAgeButton() {
    self.ageView.add(self.ageButton) {
      $0.setBackgroundImage(UIImage(named: "toggleAge"), for: .normal)
//      $0.addTarget(self, action: #selector(self.clickedAgeButton), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageView.snp.centerY)
        $0.trailing.equalTo(self.ageView.snp.trailing).offset(-3)
        $0.width.height.equalTo(10)
      }
    }
  }
  
  private func layoutAgeUnitLabel() {
    self.view.add(self.ageUnitLabel) {
      $0.text = "대"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.centerY.equalTo(self.ageView.snp.centerY)
        $0.leading.equalTo(self.ageView.snp.trailing).offset(4)
      }
    }
  }
  
  private func layoutDetailTitleLabel() {
    self.view.add(self.detailTitleLabel) {
      $0.text = "상세정보"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 14)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.leading)
        $0.top.equalTo(self.genderTitleLabel.snp.bottom).offset(24)
      }
    }
  }
  
  private func layoutDetailTextField() {
    self.view.add(self.detailTextField) {
      $0.textColor = .blackText
      $0.font = .nanumRoundRegular(fontSize: 14)
      $0.setRounded(radius: 8)
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.backgroundColor = .clear
      $0.textAlignment = .left
      $0.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
      $0.autocorrectionType = .no
      $0.autocapitalizationType = .none
      $0.delegate = self
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.detailTitleLabel.snp.bottom).offset(12)
        $0.height.equalTo(self.view.frame.height*163/812)
      }
    }
  }
  
  private func layoutDetailTextFieldFooterLabel() {
    self.view.add(detailTextFieldFooterLabel) {
      $0.text = "*임대인을 향한 비방이나 너무 심한 욕설은 자제해주세요. T-T!"
      $0.textColor = .grayText
      $0.font = .nanumRoundRegular(fontSize: 10)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.genderTitleLabel.snp.leading)
        $0.top.equalTo(self.detailTextField.snp.bottom).offset(12)
      }
    }
  }
  
  private func layoutNextButton() {
    self.view.add(self.nextButton) {
      $0.tag = 0
      $0.setRounded(radius: 8)
      $0.setTitle("다음으로", for: .normal)
      $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
      if $0.tag == 0 {
        $0.backgroundColor = .gray244
        $0.setTitleColor(.grayText, for: .normal)
        $0.isUserInteractionEnabled = false
      }
      else if $0.tag == 1 {
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.isUserInteractionEnabled = true
      }
      $0.addTarget(self, action: #selector(self.nextButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.detailTextField.snp.leading)
        $0.trailing.equalTo(self.detailTextField.snp.trailing)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38)
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  
  private func layoutseparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  
  private func layoutCountLabel() {
    view.add(countLabel) {
      $0.setupLabel(text: "\(self.textCount)/\(self.maxLength)자",
                    color: .grayText,
                    font: .nanumRoundRegular(fontSize: 12))
      $0.snp.makeConstraints {
        $0.bottom.equalTo(self.detailTextField.snp.bottom).offset(-12)
        $0.trailing.equalTo(self.detailTextField.snp.trailing).offset(-10)
      }
    }
  }
  
  private func layout() {
    layoutNavigationView()
    layoutTitleLabel()
    layoutGenderTitleLabel()
    layoutMaleButton()
    layoutFemaleButton()
    layoutAgeTitleLabel()
    layoutAgeView()
    layoutAgeContextLabel()
    layoutAgeButton()
    layoutAgeUnitLabel()
    layoutDetailTitleLabel()
    layoutDetailTextField()
    layoutDetailTextFieldFooterLabel()
    layoutNextButton()
    layoutseparatorView()
    layoutCountLabel()
  }
  
  // MARK: - Action Helpers
  @objc
  private func nextButtonClicked() {
    let navigation = self.navigationController
    let nextViewController = DetailInformationViewController()
    reviewModel.lessorGender = selectedGender ?? ""
    reviewModel.lessorAge = selectedAge ?? ""
    reviewModel.lessorReview = detailTextField.text ?? ""
    nextViewController.reviewModel = reviewModel
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
  }
  
  @objc
  private func genderButtonClicked(_ sender: UIButton) {
    var notSender: UIButton?
    if sender == self.maleButton {
      selectedGender = "MALE"
      notSender = self.femaleButton
    }
    else {
      selectedGender = "FEMALE"
      notSender = self.maleButton
    }
    sender.backgroundColor = .mainBlue
    sender.setTitleColor(.white, for: .normal)
    notSender?.backgroundColor = .white
    notSender?.setTitleColor(.blackText, for: .normal)
    activateNextButton()
  }
  
  @objc
  private func clickedAgeButton() {
    let ageVC = LessorAgePopupViewController()
    ageVC.modalPresentationStyle = .overFullScreen
    ageVC.resultClosure = { (first, second) in
      weak var `self` = self
      self?.ageContextLabel.text = first
      self?.selectedAge = second
      print(first, second)
    }
    self.present(ageVC, animated: true, completion: nil)
  }
  @objc
  private func textDidChange(_ notification: Notification) {
    if let textview = notification.object as? UITextView {
      if let text = textview.text {
        if text.isEmpty == false {
          var count = text.count
          if text.count > maxLength {
            count = maxLength
          }
          self.textCount = count
          self.countLabel.text = "\(self.textCount)/\(maxLength)자"
        }
        if text.count > self.maxLength {
          textview.resignFirstResponder()
        }
        if text.count >= maxLength {
          let index = text.index(text.startIndex, offsetBy: maxLength)
          let newString = text[text.startIndex..<index]
          textview.text = String(newString)
        }
      }
      if textview.hasText == false {
        self.textCount = 0
        self.countLabel.text = "\(self.textCount)/\(maxLength)자"
      }
    }
  }
  
  // MARK: - General Helpers
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
  
  private func activateNextButton() {
    if selectedGender != nil &&
        selectedAge != nil &&
        detailTextField.hasText != false {
      nextButton.backgroundColor = .mainBlue
      nextButton.setTitleColor(.white, for: .normal)
      nextButton.isUserInteractionEnabled = true
    }
  }
    
    private func addGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.clickedAgeButton))
        ageView.addGestureRecognizer(gesture)
    }
    
    private func configTextView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        detailTextField.typingAttributes = attributes
    }
  
  private func notifyTextView() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.textDidChange(_:)),
      name: UITextView.textDidChangeNotification,
      object: self.detailTextField)
  }
}

// MARK: - UITextView Delegate
extension LenderInformationViewController: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    activateNextButton()
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let text = textView.text else { return false }
    if text.count >= self.maxLength &&
        range.length == 0 &&
        range.location < self.maxLength {
      return false
    }
    return true
  }
}
