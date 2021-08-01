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

class SignUpViewController: BaseViewController {

    let contentView = UIView()
    let nameTextField = InputBoxView().then{
        $0.infoTitle.text = "이름"
        $0.infoTextField.placeholder = "이름을 입력해주세요"
    }
    let idTextField = InputBoxView().then{
        $0.infoTitle.text = "아이디"
        $0.infoTextField.placeholder = "아이디를 입력해주세요"
    }
    let emailTextField = InputBoxView().then{
        $0.infoTitle.text = "이메일"
        $0.infoTextField.placeholder = "이메일을 입력해주세요"
    }
    let passWordTextField = InputBoxView().then{
        $0.infoTitle.text = "비밀번호"
        $0.infoTextField.placeholder = "비밀번호를 입력해주세요"
    }
    let surePassWordTextField = InputBoxView().then{
        $0.infoTitle.text = "비밀번호 확인"
        $0.infoTextField.placeholder = "비밀번호를 다시 입력해주세요"
    }
    let pwNotSame = UILabel().then{
        $0.textColor = .heartColor //salmon color가 왜 안나오지?...
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.font = UIFont(name: "NanumSquareRoundOTFB", size: 11.0)
    }
    let pwCheckImage = UIImageView().then{
        $0.image = UIImage(named: "check")
    }
    let newsCheckBox = UIButton().then{
        $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
        $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
    }
    let newsLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
        $0.text = "ZEEPY 서비스에 대한 소식을 이메일로 받아봅니다.(선택)"
    }
    let termsCheckBox = UIButton().then{
        $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
        $0.addTarget(self, action: #selector(determineButtonImage), for: .touchUpInside)
    }
    let termsLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 11.0)
        $0.text = "ZEEPY에서 제공하는 서비스 약관에 동의합니다.(필수)"
    }
    let viewTerms = UIButton().then{
        $0.setTitle("약관보기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 11.0)
    }
    let signUpfinishButton = UIButton().then{
        $0.setTitle("가입완료", for: .normal)
        $0.backgroundColor = .mainBlue
        $0.setRounded(radius: 6)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFB", size: 16.0)
    }
    
    @objc func determineButtonImage(sender: UIButton){
        if termsCheckBox.isTouchInside{
            termsCheckBox.isSelected.toggle()
        }
        if newsCheckBox.isTouchInside{
            newsCheckBox.isSelected.toggle()
        }
        
        if !termsCheckBox.isSelected && !newsCheckBox.isSelected{
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
    }
    
    // MARK: - Server연결부
//    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private let privacyAgreeSubject = BehaviorSubject<Bool>(value: false)
    private let promotionAgreeSubject = BehaviorSubject<Bool>(value: false)
    private func bind() {
        let input = LoginViewModel.Input(nameText : nameTextField.rx.text.orEmpty.asObservable(),
                                         idText: idTextField.rx.text.orEmpty.asObservable(),
                                         emailText: emailTextField.rx.text.orEmpty.asObservable(),
                                         passwordText: passWordTextField.rx.text.orEmpty.asObservable(),
                                         surePasswordText: surePassWordTextField.rx.text.orEmpty.asObservable(),
                                         registerBtnClicked: signUpfinishButton.rx.tap.asObservable(),
                                         privacyAgree: privacyAgreeSubject,
                                         promotionAgree: promotionAgreeSubject)
    
        let output = viewModel.transform(input: input)
        
        output.registerEnabled
          .bind(to: signUpfinishButton.rx.isEnabled)
          .disposed(by: disposeBag)
        
//        output.registerResult
//          .bind{[weak self] model in
//            self?.result.text = """
//              아이디 : \(model.email)
//              비밀번호 : \(model.passWord)
//              닉네임: \(model.nickName)
//              """
//          }.disposed(by: disposeBag)
        
        termsCheckBox.rx.tap.map{ [weak self] in
          self?.termsCheckBox.isSelected.toggle()
          return self?.termsCheckBox.isSelected ?? false
        }
        .bind(to: privacyAgreeSubject)
        .disposed(by: disposeBag)
        
        newsCheckBox.rx.tap.map{ [weak self] in
          self?.newsCheckBox.isSelected.toggle()
          return self?.newsCheckBox.isSelected ?? false
        }
        .bind(to: promotionAgreeSubject)
        .disposed(by: disposeBag)
      }
    
    

    func addConstraints(){
        contentView.adds([nameTextField, idTextField, emailTextField, passWordTextField, surePassWordTextField, newsCheckBox, newsLabel, termsCheckBox,termsLabel,viewTerms, signUpfinishButton ])

        nameTextField.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
        idTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(90)
        }
        emailTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom)
            $0.height.equalTo(90)
        }
        passWordTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.height.equalTo(90)
        }
        surePassWordTextField.contentView.addSubview(pwNotSame)
        surePassWordTextField.infoTextFieldBackGroundView.addSubview(pwCheckImage)
        surePassWordTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(passWordTextField.snp.bottom)
        }
        pwNotSame.snp.makeConstraints{
            $0.top.trailing.equalToSuperview().inset(6)
        }
        pwCheckImage.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        newsCheckBox.snp.makeConstraints{
            $0.top.equalTo(surePassWordTextField.snp.bottom).offset(20)
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
