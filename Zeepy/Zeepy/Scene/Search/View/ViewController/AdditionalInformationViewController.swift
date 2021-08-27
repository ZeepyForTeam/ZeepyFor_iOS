//
//  AdditionalInformationViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/05/10.
//
import UIKit

import SnapKit
import Then

class AdditionalInformationViewController: BaseViewController {
  
  // MARK: - Components
  private let navigationView = CustomNavigationBar()
  private let titleLabel = UILabel()
  private let reviewTitleLabel = UILabel()
  private let reviewTextField = UITextView()
  private let assessTitleLabel = UILabel()
  private let assessTableView = UITableView()
  private let nextButton = UIButton()
  private let separatorView = UIView()
  private let countLabel = UILabel()
  
  // MARK: - Varaibles
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
  
  var assessTextList = [("다음에도 여기 살고 싶어요!", "GOOD"),
                        ("완전 추천해요!", "SOSO"),
                        ("그닥 추천하지 않아요.", "BAD")]
  
  var selectedNumber = 100
  private final let maxLength = 1500
  private var textCount = 0
  private let titleLabelNumberOfLine = 2
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    register()
    assessTableView.delegate = self
    assessTableView.dataSource = self
    setupNavigation()
    notifyTextView()
  }
  
  
}

// MARK: - Extensions
extension AdditionalInformationViewController {
  
  // MARK: - Layout Helpers
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
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

    self.view.add(self.titleLabel) {
      $0.attributedText = titleText
      $0.numberOfLines = self.titleLabelNumberOfLine
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.top.equalTo(self.navigationView.snp.bottom).offset(16)
      }
    }
  }
  func layoutReviewTitleLabel() {
    self.view.add(reviewTitleLabel) {
      $0.text = "상세리뷰"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(32)
      }
    }
  }
  func layoutReviewTextField() {
    self.view.add(self.reviewTextField) {
      $0.textColor = .blackText
      $0.font = .nanumRoundRegular(fontSize: 14)
      $0.setRounded(radius: 8)
      $0.setBorder(borderColor: .grayText, borderWidth: 1)
      $0.backgroundColor = .clear
      $0.textAlignment = .left
      $0.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
      $0.autocapitalizationType = .none
      $0.autocorrectionType = .no
      $0.delegate = self
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.reviewTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.reviewTitleLabel.snp.bottom).offset(12)
        $0.height.equalTo(self.view.frame.height*163/812)
      }
    }
  }
  func layoutAssessTitleLabel() {
    self.view.add(assessTitleLabel) {
      $0.text = "종합평가"
      $0.textColor = .blackText
      $0.font = .nanumRoundExtraBold(fontSize: 18)
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.titleLabel.snp.leading)
        $0.top.equalTo(self.reviewTextField.snp.bottom).offset(32)
      }
    }
  }
  func layoutAssessTableView() {
    self.view.add(assessTableView) {
      $0.estimatedRowHeight = UITableView.automaticDimension
      $0.backgroundColor = .clear
      $0.separatorStyle = .none
      $0.isScrollEnabled = false
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.assessTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.top.equalTo(self.assessTitleLabel.snp.bottom).offset(12)
//        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-120)
        $0.height.equalTo(168)
      }
    }
  }
  func layoutNextButton() {
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
        $0.leading.equalTo(self.reviewTitleLabel.snp.leading)
        $0.centerX.equalTo(self.view.snp.centerX)
        $0.bottom.equalTo(self.view.snp.bottom).offset(-38)
        $0.height.equalTo(self.view.frame.height*52/812)
      }
    }
  }
  
  func layoutSeparatorView() {
    self.view.add(self.separatorView) {
      $0.backgroundColor = .gray244
      $0.snp.makeConstraints {
        $0.width.equalTo(self.view.snp.width)
        $0.height.equalTo(1)
        $0.bottom.equalTo(self.nextButton.snp.top).offset(-12)
      }
    }
  }
  
  func layoutCountLabel() {
    view.add(countLabel) {
      $0.setupLabel(text: "\(self.textCount)/\(self.maxLength)자",
                    color: .grayText,
                    font: .nanumRoundRegular(fontSize: 12))
      $0.snp.makeConstraints {
        $0.bottom.equalTo(self.reviewTextField.snp.bottom).offset(-12)
        $0.trailing.equalTo(self.reviewTextField.snp.trailing).offset(-10)
      }
    }
  }
  func layout() {
    layoutNavigationView()
    layoutTitleLabel()
    layoutReviewTitleLabel()
    layoutReviewTextField()
    layoutAssessTitleLabel()
    layoutAssessTableView()
    layoutNextButton()
    layoutSeparatorView()
    layoutCountLabel()
  }
  
  // MARK: - General Helpers
  func register() {
    assessTableView.register(AssessTableViewCell.self, forCellReuseIdentifier: AssessTableViewCell.identifier)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "리뷰작성")
  }
  
  private func activateNextButton() {
    if reviewTextField.hasText != false && selectedNumber != 100 {
      nextButton.backgroundColor = .mainBlue
      nextButton.setTitleColor(.white, for: .normal)
      nextButton.isUserInteractionEnabled = true
    }
    else {
      nextButton.backgroundColor = .gray244
      nextButton.setTitleColor(.grayText, for: .normal)
      nextButton.isUserInteractionEnabled = false
    }
  }
  
  private func notifyTextView() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.textDidChange(_:)),
      name: UITextView.textDidChangeNotification,
      object: self.reviewTextField)
  }
  
  // MARK: - Action Helpers
  @objc func nextButtonClicked() {
    
    
    
    let navigation = self.navigationController
    reviewModel.totalEvaluation = assessTextList[selectedNumber].1
    reviewModel.review = reviewTextField.text ?? ""
    guard let nextViewController = AddPhotoViewController(nibName: nil, bundle: nil, viewModel: nil, reviewModel: reviewModel) else {return}
    nextViewController.hidesBottomBarWhenPushed = false
    navigation?.pushViewController(nextViewController, animated: false)
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
}

// MARK: - UITableView Delegate
extension AdditionalInformationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
}
// MARK: - UITableView DataSource
extension AdditionalInformationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return assessTextList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let assessCell = tableView.dequeueReusableCell(withIdentifier: AssessTableViewCell.identifier, for: indexPath) as? AssessTableViewCell else { return UITableViewCell() }
    assessCell.awakeFromNib()
    if selectedNumber == indexPath.row {
      assessCell.assessLabel.setupLabel(text: assessTextList[indexPath.row].0, color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
      assessCell.containerView.backgroundColor = .white
      assessCell.containerView.setBorder(borderColor: .mainBlue, borderWidth: 1)
    }
    else {
      assessCell.assessLabel.setupLabel(text: assessTextList[indexPath.row].0, color: .blackText, font: .nanumRoundRegular(fontSize: 14))
      assessCell.containerView.backgroundColor = .gray244
      assessCell.containerView.layer.borderColor = UIColor.clear.cgColor
    }
    return assessCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedNumber = indexPath.row
    activateNextButton()
    tableView.reloadData()
  }
}

// MARK: - UITextView Delegate
extension AdditionalInformationViewController: UITextViewDelegate {
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
