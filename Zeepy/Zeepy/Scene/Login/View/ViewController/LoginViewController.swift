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
    
    let contentView = UIView().then{
        $0.backgroundColor = .white
    }
    let viewTitle = UIImageView().then{
        $0.image = UIImage(named: "group926")
    }
    let logoImage = UIImageView().then{
        $0.image = UIImage(named: "0408Character1")
    }
    let signUpLabel = UILabel().then{
        $0.text = "Sign up"
        $0.font = UIFont(name: "Gilroy-ExtraBold", size: 16.0)
    }
    let emailButton = UIButton().then{
        $0.setImage(UIImage(named: "group920"), for: .normal)
    }
    let kakaoButton = UIButton().then{
        $0.setImage(UIImage(named: "group921"), for: .normal)
    }
    let naverButton = UIButton().then{
        $0.setImage(UIImage(named: "group922"), for: .normal)
    }
    let alredyAccount = UIButton().then{
        $0.setTitle("이미 계정이 있으신가요?", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.setTitleColor(.mainBlue, for: .normal)
    }
    let findIDButton = UIButton().then{
        $0.setTitle("아이디 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.titleLabel?.textColor = .black
        $0.setTitleColor(.grayText, for: .normal)
    }
    let findPWButton = UIButton().then{
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.setTitleColor(.grayText, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.view.backgroundColor = .white
        addConstraints()
    }
    func addConstraints(){
        contentView.adds([viewTitle,logoImage,signUpLabel,emailButton,kakaoButton,naverButton,alredyAccount,findIDButton,findPWButton])
        viewTitle.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(25)
            $0.height.equalTo(70)
            $0.width.equalTo(200)
        }
        logoImage.snp.makeConstraints{
            $0.top.equalTo(viewTitle.snp.bottom)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(200)
            $0.width.equalTo(200)
        }
        signUpLabel.snp.makeConstraints{
            $0.top.equalTo(logoImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(40)
            $0.height.equalTo(50)
            
        }
        emailButton.snp.makeConstraints{
            $0.top.equalTo(signUpLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        kakaoButton.snp.makeConstraints{
            $0.top.equalTo(emailButton.snp.bottom).offset(8)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        naverButton.snp.makeConstraints{
            $0.top.equalTo(kakaoButton.snp.bottom).offset(8)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        alredyAccount.snp.makeConstraints{
            $0.top.equalTo(naverButton.snp.bottom).offset(8)
            $0.leading.equalTo(naverButton.snp.leading).offset(50)
            $0.bottom.equalToSuperview().offset(-90)
        }
        findPWButton.snp.makeConstraints{
            $0.top.equalTo(alredyAccount.snp.top).offset(8)
            $0.trailing.equalTo(naverButton.snp.trailing).offset(-50)
            $0.bottom.equalToSuperview().offset(-90)
        }
        findIDButton.snp.makeConstraints{
            $0.top.equalTo(alredyAccount.snp.top).offset(8)
            $0.trailing.equalTo(findPWButton.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().offset(-90)
        }
    }
}

