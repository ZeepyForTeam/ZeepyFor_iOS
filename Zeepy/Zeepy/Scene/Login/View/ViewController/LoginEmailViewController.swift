//
//  loginEmailViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/05.
//

import UIKit
import SnapKit
import Then

class LoginEmailViewController: UIViewController {
     
    let contentView = UIView()
    
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "btnBack"), for: .normal)
    }
    let viewTitle = UIImageView().then{
        $0.image = UIImage(named: "group926")
    }
    let signInTitle = UILabel().then{
        $0.text = "Sign in"
        $0.font = UIFont(name: "Gilroy-ExtraBold", size: 16.0)
    }
    let idTextFieldBackGroundView = UIView().then{
        $0.backgroundColor = .gray244
        $0.setRounded(radius: 10)
    }
    let idTextField = UITextField().then{
        $0.placeholder = "아이디를 입력해주세요."
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
    }
    let pwTextFieldBackGroundView = UIView().then{
        $0.backgroundColor = .gray244
        $0.setRounded(radius: 10)
    }
    let pwTextField = UITextField().then{
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
    }
    let findIDButton = UIButton().then{
        $0.setTitle("아이디찾기", for: .normal)
        $0.setTitleColor(.grayText, for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }
    let findPWButton = UIButton().then{
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(.grayText, for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }
    let signUpButton = UIButton().then{
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.grayText, for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }
    let loginButton = UIButton().then{
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .mainBlue
        $0.titleLabel?.textColor = .white
        $0.setRounded(radius: 10)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
    }
    let seperateBar = UIView().then{
        $0.backgroundColor = .gray244
    }
    let snsLoginLabel = UILabel().then{
        $0.text = "SNS Login"
        $0.font = UIFont(name: "Gilroy-ExtraBold", size: 16.0)
    }
    
    let snsStackView = UIStackView()
    let appleLoginButton = UIButton().then{
        $0.setImage(UIImage(named: "logoApple"), for: .normal)
    }
    let kakaoLoginButton = UIButton().then{
        $0.setImage(UIImage(named: "logoCacao"), for: .normal)
    }
    let naverLoginButton = UIButton().then{
        $0.setImage(UIImage(named: "logoNaver"), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        addContraints()
    }

    func addContraints(){
        contentView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        contentView.adds([backButton,viewTitle,signInTitle,idTextFieldBackGroundView,pwTextFieldBackGroundView,findIDButton,findPWButton,signUpButton,loginButton,seperateBar,snsLoginLabel,snsStackView])
        
        backButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(15)
        }
        viewTitle.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalTo(backButton).offset(30)
            $0.height.equalTo(70)
            $0.width.equalTo(220)
        }
        
        signInTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(viewTitle.snp.bottom).offset(100)
        }
        idTextFieldBackGroundView.addSubview(idTextField)
        idTextFieldBackGroundView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.top.equalTo(signInTitle.snp.bottom).offset(8)
            $0.height.equalTo(50)
        }
        idTextField.snp.makeConstraints{
            $0.center.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        pwTextFieldBackGroundView.addSubview(pwTextField)
        pwTextFieldBackGroundView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.top.equalTo(idTextField.snp.bottom).offset(16)
            $0.height.equalTo(50)
        }
        pwTextField.snp.makeConstraints{
            $0.center.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        findPWButton.snp.makeConstraints{
            $0.centerX.equalTo(pwTextField)
            $0.top.equalTo(pwTextField.snp.bottom).offset(8)
        }
        findIDButton.snp.makeConstraints{
            $0.trailing.equalTo(findPWButton.snp.leading).offset(-15)
            $0.top.equalTo(pwTextField.snp.bottom).offset(8)
        }
        signUpButton.snp.makeConstraints{
            $0.leading.equalTo(findPWButton.snp.trailing).offset(15)
            $0.top.equalTo(pwTextField.snp.bottom).offset(8)
        }
        loginButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        seperateBar.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(5)
        }
        snsLoginLabel.snp.makeConstraints{
            $0.top.equalTo(seperateBar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
        }
        snsStackView.adds([appleLoginButton, kakaoLoginButton, naverLoginButton])
        snsStackView.snp.makeConstraints{
            $0.top.equalTo(snsLoginLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(125)
            $0.trailing.equalToSuperview().inset(125)
        }
        
        appleLoginButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        kakaoLoginButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalTo(appleLoginButton.snp.trailing).offset(10)
        }
        naverLoginButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
