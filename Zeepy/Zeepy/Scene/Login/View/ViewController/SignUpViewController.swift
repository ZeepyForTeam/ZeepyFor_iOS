//
//  SignUpViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Moya

class SignUpViewController: BaseViewController {  
  let contentView = UIView()
  private let navigationView = CustomNavigationBar()
  let getName = InputBoxView().then {
    $0.infoTitle.text = "이름"
    $0.infoTextField.autocapitalizationType = .none
    $0.infoTextField.autocorrectionType = .no
    $0.infoTextField.placeholder = "이름을 입력해주세요"
  }
  let getNickname = InputBoxView().then {
    $0.infoTitle.text = "닉네임"
    $0.infoTextField.autocapitalizationType = .none
    $0.infoTextField.autocorrectionType = .no
    $0.infoTextField.placeholder = "사용하실 닉네임을 입력해주세요"
  }
  let checkNicknameButton = UIButton().then {
    $0.setupButton(
      title: "중복확인",
      color: .blackText,
      font: .nanumRoundBold(fontSize: 12),
      backgroundColor: .gray244,
      state: .normal,
      radius: 8)
  }
  let nicknameCheckImage = UIImageView().then {
    $0.image = UIImage(named: "check")
    $0.isHidden = true
  }
  let getEmail = InputBoxView().then {
    $0.infoTitle.text = "이메일"
    $0.infoTextField.keyboardType = .emailAddress
    $0.infoTextField.autocapitalizationType = .none
    $0.infoTextField.autocorrectionType = .no
    $0.infoTextField.placeholder = "이메일ID를 입력해주세요"
    $0.validationResult.text = "이미 가입된 이메일입니다"
  }
  let checkEmailButton = UIButton().then {
    $0.setupButton(
      title: "중복확인",
      color: .blackText,
      font: .nanumRoundBold(fontSize: 12),
      backgroundColor: .gray244,
      state: .normal,
      radius: 8)

  }
  let emailCheckImage = UIImageView().then {
    $0.image = UIImage(named: "check")
    $0.isHidden = true
  }
  let getPW = InputBoxView().then {
    $0.infoTitle.text = "비밀번호"
    $0.infoTextField.placeholder = "비밀번호를 입력해주세요"
    $0.infoTextField.autocapitalizationType = .none
    $0.infoTextField.autocorrectionType = .no
    $0.infoTextField.isSecureTextEntry = true
    $0.validationResult.text = "최소 8글자 이상의 비밀번호를 입력해주세요."
  }
  let surePW = InputBoxView().then {
    $0.infoTitle.text = "비밀번호 확인"
    $0.infoTextField.placeholder = "비밀번호를 다시 입력해주세요"
    $0.infoTextField.autocapitalizationType = .none
    $0.infoTextField.autocorrectionType = .no
    $0.infoTextField.isSecureTextEntry = true
    $0.validationResult.text = "비밀번호가 일치하지 않습니다."
  }
  let pwCheckImage = UIImageView().then {
    $0.image = UIImage(named: "check")
    $0.isHidden = true
  }
  let serviceTermsCheckBox = UIButton().then {
    $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    $0.setImage(UIImage(named: "checkBox"), for: .selected)
    $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
  }
  let serviceTermsLabel = UILabel().then {
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
    $0.text = "ZEEPY에서 제공하는 서비스 약관에 동의합니다."
  }
  let viewServiceTerms = UIButton().then {
    $0.setTitle("약관보기", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 11.0)
    $0.addTarget(self, action: #selector(clickedServiceTermsButton), for: .touchUpInside)
  }
  let personalTermsCheckBox = UIButton().then {
    $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    $0.setImage(UIImage(named: "checkBox"), for: .selected)
    $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
  }
  let personalTermsLabel = UILabel().then {
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
    $0.text = "ZEEPY에서 제공하는 개인정보 처리방침에 동의합니다."
  }
  let viewPersonalTerms = UIButton().then {
    $0.setTitle("약관보기", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 11.0)
    $0.addTarget(self, action: #selector(clickedPersonalTermsButton), for: .touchUpInside)
  }
  let newsCheckBox = UIButton().then {
    $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    $0.setImage(UIImage(named: "checkBox"), for: .selected)
    $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
  }
  let newsLabel = UILabel().then {
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
    $0.text = "ZEEPY 서비스에 대한 소식을 이메일로 받아봅니다.(선택)"
  }
  let signUpfinishButton = UIButton().then {
    $0.setTitle("가입완료", for: .normal)
    $0.backgroundColor = .mainBlue
    $0.setRounded(radius: 6)
    $0.alpha = 0.1
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 16.0)
  }
  
  @objc func determineButtonImage(sender: UIButton) {
    sender.isSelected.toggle()
  }
  
  @objc func clickedServiceTermsButton() {
    let view = ServiceTermsViewController()
    self.navigationController?.pushViewController(view, animated: true)
  }
  
  @objc func clickedPersonalTermsButton() {
    let view = PersonalTermsViewController()
    self.navigationController?.pushViewController(view, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(contentView)
    contentView.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    addConstraints()
    bind()
    setupNavigation()
  }
  private func setupNavigation() {
    navigationView.naviTitle.text = "회원가입"
  }
  private let viewModel = SignUpViewModel()
  
  func bind() {
    
    let inputs = SignUpViewModel.Input(
      emailText: self.checkEmailButton.rx.controlEvent(.touchUpInside)
        .map { [weak self] in self?.getEmail.infoTextField.text ?? "" }
        .asObservable(),
      passwordText: getPW.infoTextField.rx.controlEvent(.editingDidEnd)
        .map { [weak self] in self?.getPW.infoTextField.text ?? "" }
        .asObservable(),
      passwordCheck: surePW.infoTextField.rx.controlEvent(.editingDidEnd)
        .map { [weak self] in self?.surePW.infoTextField.text ?? "" }
        .asObservable(),
      nicknameText: self.checkNicknameButton.rx.controlEvent(.touchUpInside)
        .map{ [weak self] in self?.getNickname.infoTextField.text ?? "" }
        .asObservable(),
      nameText: getName.infoTextField.rx.controlEvent(.editingDidEnd)
        .map { [weak self] in self?.getName.infoTextField.text ?? "" }
        .asObservable(),
      sendMailCheck: newsCheckBox.rx.controlEvent(.touchUpInside)
        .map { [weak self] in self?.newsCheckBox.isSelected ?? false }
        .asObservable(),
      registerButtonDidTap: signUpfinishButton.rx.tap.asObservable())
    
    let output = viewModel.transform(inputs: inputs)
    
    output.emailValidate.bind{[weak self] result in
      if !result {
        self?.getEmail.infoTextField.text = ""
        self?.getEmail.infoTextField.shake()
      }
      else {
        self?.emailCheckImage.isHidden = false
      }
      self?.getEmail.validationResult.isHidden = result
      
      
    }.disposed(by: disposeBag)
    output.nickNameValidate.bind{[weak self] result in
      if !result {
        self?.getNickname.infoTextField.text = ""
        self?.getNickname.infoTextField.shake()
      }
      else {
        self?.nicknameCheckImage.isHidden = false
      }
      self?.getNickname.validationResult.isHidden = result
      
    }.disposed(by: disposeBag)
    output.passwordSame.bind{[weak self] result in
      if !result {
        self?.surePW.infoTextField.text = ""
        self?.pwCheckImage.isHidden = result
        self?.surePW.infoTextField.shake()
      }
      self?.surePW.validationResult.isHidden = result
      self?.pwCheckImage.isHidden = !result
    }.disposed(by: disposeBag)
    output.passwordValidate.bind{[weak self] result in
      if !result {
        self?.getPW.infoTextField.text = ""
        
        self?.getPW.infoTextField.shake()
      }
      self?.getPW.validationResult.isHidden = result
      
    }.disposed(by: disposeBag)
    
    output.registerEnabled.bind(to: signUpfinishButton.rx.isEnabled).disposed(by: disposeBag)
    output.registerEnabled.map{$0 ? 1 : 0.1}.bind(to: signUpfinishButton.rx.alpha).disposed(by: disposeBag)
    output.registerResult.bind{[weak self] result in
      if result {
        print("회원가입 성공")
      }
      else {
        MessageAlertView.shared.showAlertView(title: "회원가입에 실패했습니다.", grantMessage: "확인", okAction: {
          self?.getNickname.infoTextField.text = ""
          self?.getNickname.validationResult.isHidden = true
          self?.getPW.infoTextField.text = ""
          self?.getPW.validationResult.isHidden = true
          self?.getName.infoTextField.text = ""
          self?.getName.validationResult.isHidden = true
          self?.surePW.infoTextField.text = ""
          self?.surePW.validationResult.isHidden = true
          self?.getEmail.infoTextField.text = ""
          self?.getEmail.validationResult.isHidden = true
          
        })
      }
    }.disposed(by: disposeBag)
    
    output.autoLoginResult.bind{[weak self] result in
      switch result {
      case .success(let result) :
        LoginManager.shared.makeLoginStatus(accessToken: result.accessToken, refreshToken: result.refreshToken, loginType: .email, userId: result.userId)
        let rootNav = UINavigationController()
        rootNav.navigationBar.isHidden = true
        let rootVC = TabbarViewContorller()
        
        rootNav.viewControllers = [rootVC]
        rootNav.modalPresentationStyle = .fullScreen
        self?.present(rootNav, animated: true, completion: nil)
        
      case .failure(let errorType) :
        var errMessage : String = ""
        
        switch errorType {
        case .auth :
          errMessage = "잘못된 이메일 혹은 비밀번호입니다."
        case .notfound:
          errMessage = "존재하지 않는 계정입니다."
        case .server:
          errMessage = "서버 점검 중입니다."
        default :
          errMessage = "서버 오류가 발생했습니다."
        }
        MessageAlertView.shared.showAlertView(title: errMessage, grantMessage: "확인",okAction: {
          self?.popViewController()
        })
      }
    }.disposed(by: disposeBag)
  }
  func addConstraints(){
    contentView.adds([navigationView,
                      getName,
                      getNickname,
                      checkNicknameButton,
                      getEmail,
                      checkEmailButton,
                      getPW,
                      surePW,
                      serviceTermsCheckBox,
                      serviceTermsLabel,
                      viewServiceTerms,
                      personalTermsCheckBox,
                      personalTermsLabel,
                      viewPersonalTerms,
                      newsCheckBox,
                      newsLabel,
                      signUpfinishButton ])
    
    navigationView.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
    }
    getName.snp.makeConstraints{
      $0.top.equalTo(self.navigationView.snp.bottom).offset(22)
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(64)
    }
    getNickname.infoTextFieldBackGroundView.addSubview(nicknameCheckImage)
    getNickname.snp.makeConstraints{
      $0.leading.equalToSuperview().inset(24)
      $0.top.equalTo(getName.snp.bottom).offset(20)
      $0.width.equalTo(self.view.frame.width * 259/375)
      $0.height.equalTo(64)
    }
    checkNicknameButton.snp.makeConstraints{
      $0.leading.equalTo(getNickname.snp.trailing).offset(8)
      $0.top.bottom.equalTo(getNickname.infoTextFieldBackGroundView)
      $0.trailing.equalTo(self.getName.snp.trailing)
    }
    nicknameCheckImage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(10)
    }
    getEmail.infoTextFieldBackGroundView.addSubview(emailCheckImage)
    
    getEmail.snp.makeConstraints{
      $0.leading.equalToSuperview().inset(24)
      $0.top.equalTo(getNickname.snp.bottom).offset(20)
      $0.width.equalTo(self.view.frame.width * 259/375)
      $0.height.equalTo(64)
    }
    checkEmailButton.snp.makeConstraints{
      $0.leading.equalTo(getEmail.snp.trailing).offset(8)
      $0.top.bottom.equalTo(getEmail.infoTextFieldBackGroundView)
      $0.trailing.equalTo(self.getName.snp.trailing)
    }
    emailCheckImage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(10)
    }
    getPW.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.top.equalTo(getEmail.snp.bottom).offset(20)
      $0.height.equalTo(64)
    }
    surePW.infoTextFieldBackGroundView.addSubview(pwCheckImage)
    
    surePW.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.top.equalTo(getPW.snp.bottom).offset(20)
      $0.height.equalTo(64)
    }
    pwCheckImage.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(10)
    }
    
    serviceTermsCheckBox.snp.makeConstraints{
      $0.top.equalTo(surePW.snp.bottom).offset(32)
      $0.leading.equalToSuperview().offset(24)
    }
    serviceTermsLabel.snp.makeConstraints{
      $0.leading.equalTo(serviceTermsCheckBox.snp.trailing).offset(6)
      $0.centerY.equalTo(serviceTermsCheckBox)
    }
    viewServiceTerms.snp.makeConstraints{
      $0.leading.equalTo(serviceTermsLabel.snp.trailing).offset(6)
      $0.centerY.equalTo(serviceTermsCheckBox)
    }
    personalTermsCheckBox.snp.makeConstraints{
      $0.top.equalTo(serviceTermsCheckBox.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(24)
    }
    personalTermsLabel.snp.makeConstraints{
      $0.leading.equalTo(personalTermsCheckBox.snp.trailing).offset(6)
      $0.centerY.equalTo(personalTermsCheckBox)
    }
    viewPersonalTerms.snp.makeConstraints{
      $0.leading.equalTo(personalTermsLabel.snp.trailing).offset(6)
      $0.centerY.equalTo(personalTermsCheckBox)
    }
    newsCheckBox.snp.makeConstraints{
      $0.top.equalTo(personalTermsCheckBox.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(24)
    }
    newsLabel.snp.makeConstraints{
      $0.leading.equalTo(newsCheckBox.snp.trailing).offset(6)
      $0.centerY.equalTo(newsCheckBox)
    }
    signUpfinishButton.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(48)
    }
  }
}
