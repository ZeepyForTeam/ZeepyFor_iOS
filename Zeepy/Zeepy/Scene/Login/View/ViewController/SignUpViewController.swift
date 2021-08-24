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
  let getName = InputBoxView().then {
    $0.infoTitle.text = "이름"
    $0.infoTextField.placeholder = "이름을 입력해주세요"
    $0.validationResult.text = "이미 존재하는 이름입니다"
  }
  let getID = InputBoxView().then {
    $0.infoTitle.text = "아이디"
    $0.infoTextField.placeholder = "아이디를 입력해주세요"
  }
  let checkIDButton = UIButton().then {
    $0.setupButton(title: "중복확인", color: .blackText, font: UIFont(name: "NanumSquareRoundOTFR", size: 14.0)!, backgroundColor: .white, state: .normal, radius: 10)
    $0.borderColor = .gray196
    $0.borderWidth = 2
  }
  let idCheckImage = UIImageView().then {
    $0.image = UIImage(named: "check")
    $0.isHidden = true
  }
  let getEmail = InputBoxView().then {
    $0.infoTitle.text = "이메일"
    $0.infoTextField.placeholder = "이메일을 입력해주세요"
    $0.validationResult.text = "이미 존재하는 메일입니다"
  }
  let checkEmailButton = UIButton().then {
    $0.setupButton(title: "중복확인", color: .blackText, font: UIFont(name: "NanumSquareRoundOTFR", size: 14.0)!, backgroundColor: .white, state: .normal, radius: 10)
    $0.borderColor = .gray196
    $0.borderWidth = 2
  }
  let emailCheckImage = UIImageView().then {
    $0.image = UIImage(named: "check")
    $0.isHidden = true
  }
  let passWordRuleLabel = UILabel().then {
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    $0.textColor = UIColor(white: 202.0 / 255.0, alpha: 1.0)
    $0.text = "*최소 8글자 이상의 비밀번호를 입력해주세요."
  }
  let getPW = InputBoxView().then {
    $0.infoTitle.text = "비밀번호"
    $0.infoTextField.placeholder = "비밀번호를 입력해주세요"
    $0.validationResult.text = "비밀번호는 2~8자 한글, 숫자, 특수문자를 포함해야합니다."
  }
  let surePW = InputBoxView().then {
    $0.infoTitle.text = "비밀번호 확인"
    $0.infoTextField.placeholder = "비밀번호를 다시 입력해주세요"
    $0.validationResult.text = "비밀번호가 일치하지 않습니다."
  }
  let pwCheckImage = UIImageView().then {
    $0.image = UIImage(named: "check")
    $0.isHidden = true
  }
  let newsCheckBox = UIButton().then {
    $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
  }
  let newsLabel = UILabel().then {
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
    $0.text = "ZEEPY 서비스에 대한 소식을 이메일로 받아봅니다.(선택)"
  }
  let termsCheckBox = UIButton().then {
    $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
  }
  let termsLabel = UILabel().then {
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
    $0.text = "ZEEPY에서 제공하는 서비스 약관에 동의합니다.(필수)"
  }
  let viewTerms = UIButton().then {
    $0.setTitle("약관보기", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 11.0)
  }
  let signUpfinishButton = UIButton().then {
    $0.setTitle("가입완료", for: .normal)
    $0.backgroundColor = .mainBlue
    $0.setRounded(radius: 6)
    $0.alpha = 0.1
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 16.0)
  }
  
  @objc func determineButtonImage(sender: UIButton) {
    if termsCheckBox.isTouchInside{
      termsCheckBox.isSelected.toggle()
    }
    if newsCheckBox.isTouchInside{
      newsCheckBox.isSelected.toggle()
    }
    
    if !termsCheckBox.isSelected && !newsCheckBox.isSelected {
      termsCheckBox.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
      newsCheckBox.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    }
    if !termsCheckBox.isSelected && newsCheckBox.isSelected{
      termsCheckBox.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
      newsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
    }
    if termsCheckBox.isSelected && !newsCheckBox.isSelected{
      termsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
      newsCheckBox.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    }
    if termsCheckBox.isSelected && newsCheckBox.isSelected{
      termsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
      newsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
    }
    reloadInputViews()
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
    self.setupNavigationBar(.white)
    self.setupNavigationItem(titleText: "회원가입")
  }
  private let viewModel = SignUpViewModel()
  func bind() {
    
    let inputs = SignUpViewModel.Input(emailText: getEmail.infoTextField.rx.controlEvent(.editingDidEnd).map{[weak self] in self?.getEmail.infoTextField.text ?? ""}.asObservable(),
                                       passwordText: getPW.infoTextField.rx.controlEvent(.editingDidEnd).map{[weak self] in self?.getPW.infoTextField.text ?? ""}.asObservable(),
                                       passwordCheck: surePW.infoTextField.rx.controlEvent(.editingDidEnd).map{[weak self] in self?.surePW.infoTextField.text ?? ""}.asObservable(),
                                       nicknameText: getName.infoTextField.rx.controlEvent(.editingDidEnd).map{[weak self] in self?.getName.infoTextField.text ?? ""}.asObservable(),
                                       registerButtonDidTap: signUpfinishButton.rx.tap.asObservable())
    let output = viewModel.transform(inputs: inputs)
    output.emailValidate.bind{[weak self] result in
      if !result {
        self?.getEmail.infoTextField.text = ""
        self?.getEmail.infoTextField.shake()
      }
      self?.getEmail.validationResult.isHidden = result
      
      
    }.disposed(by: disposeBag)
    output.nickNameValidate.bind{[weak self] result in
      if !result {
        self?.getName.infoTextField.text = ""
        self?.getName.infoTextField.shake()
      }
      self?.getName.validationResult.isHidden = result
      
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
          self?.getID.infoTextField.text = ""
          self?.getID.validationResult.isHidden = true
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
        UserManager.shared.userId = result.userId
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
    contentView.adds([getName, getID, checkIDButton, getEmail,checkEmailButton, getPW, surePW, newsCheckBox, newsLabel, termsCheckBox,termsLabel,viewTerms, signUpfinishButton ])
    
    getName.snp.makeConstraints{
      $0.top.equalToSuperview().offset(60)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(90)
    }
    getID.snp.makeConstraints{
      $0.leading.equalToSuperview()
      $0.top.equalTo(getName.snp.bottom).offset(30)
      $0.height.equalTo(90)
    }
    checkIDButton.snp.makeConstraints{
      $0.leading.equalTo(getID.snp.trailing)
      $0.top.bottom.equalTo(getID)
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalTo(getID.infoTextField)
      $0.height.equalTo(45)
      $0.width.equalTo(90)
    }
    getEmail.snp.makeConstraints{
      $0.leading.equalToSuperview()
      $0.top.equalTo(getID.snp.bottom).offset(30)
      $0.height.equalTo(90)
    }
    checkEmailButton.snp.makeConstraints{
      $0.leading.equalTo(getEmail.snp.trailing)
      $0.top.bottom.equalTo(getEmail)
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalTo(getEmail.infoTextField)
      $0.height.equalTo(45)
      $0.width.equalTo(90)
    }
    getPW.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(getEmail.snp.bottom).offset(30)
      $0.height.equalTo(90)
    }
    getPW.addSubview(passWordRuleLabel)
    passWordRuleLabel.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(getPW.infoTextField.snp.bottom).offset(8)
    }
    surePW.infoTextFieldBackGroundView.addSubview(pwCheckImage)
    
    surePW.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(getPW.snp.bottom).offset(30)
    }
    pwCheckImage.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(10)
    }
    newsCheckBox.snp.makeConstraints{
      $0.top.equalTo(surePW.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(24)
    }
    newsLabel.snp.makeConstraints{
      $0.leading.equalTo(newsCheckBox.snp.trailing).offset(6)
      $0.centerY.equalTo(newsCheckBox)
      $0.top.equalTo(newsCheckBox)
    }
    termsCheckBox.snp.makeConstraints{
      $0.top.equalTo(newsLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(24)
    }
    termsLabel.snp.makeConstraints{
      $0.leading.equalTo(termsCheckBox.snp.trailing).offset(6)
      $0.centerY.equalTo(termsCheckBox)
      $0.top.equalTo(termsCheckBox)
    }
    viewTerms.snp.makeConstraints{
      $0.leading.equalTo(termsLabel.snp.trailing).offset(6)
      $0.centerY.equalTo(termsCheckBox)
      $0.top.equalTo(termsCheckBox)
    }
    signUpfinishButton.snp.makeConstraints{
      $0.top.equalTo(termsCheckBox.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(40)
    }
  }
}
