//
//  LoginViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/06/29.
//

import UIKit
import Then
import UIKit

class LoginViewController: UIViewController {

    let loginTitle = UILabel().then{
        $0.text = "Login"
    }
    let idTitle = UILabel().then{
        $0.text = "아이디"
    }
    let idTextField = UITextField().then{
        $0.placeholder = "아이디를 입력해주세요"
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 12.0)
    }
    let passwordTitle = UILabel().then{
        $0.text = "비밀번호"
    }
    let passwordTextField = UITextField().then{
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 12.0)
    }
    let socialLogin = UILabel().then{
        $0.text = "소셜로그인"
    }
    let snsOptionButton = UIButton().then{
        $0.setImage(UIImage(named: "btnOption1"), for: .normal)
    }
    let loginButton = UIButton().then{
        $0.setTitle("로그인", for: .normal)
    }
    let signInButton = UIButton().then{
        $0.setTitle("회원가입", for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loginTitle)
        self.view.backgroundColor = .white
        addConstraints()
    }

    func addConstraints(){
        loginTitle.adds([idTitle])
        loginTitle.snp.makeConstraints{
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(16)
        }
        idTitle.snp.makeConstraints{
            $0.top.equalTo(loginTitle.snp.bottom).inset(10)
            $0.leading.equalTo(loginTitle)
            $0.bottom.equalToSuperview()
        }
    }
}
