//
//  SignUpViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/05.
//

import UIKit
import SnapKit
import Then

class SignUpViewController: UIViewController {

    let contentView = UIView()
    let getName = InputBoxView().then{
        $0.infoTitle.text = "이름"
        $0.infoTextField.placeholder = "이름을 입력해주세요"
    }
    let getID = InputBoxView().then{
        $0.infoTitle.text = "아이디"
        $0.infoTextField.placeholder = "아이디을 입력해주세요"
    }
    let getEmail = InputBoxView().then{
        $0.infoTitle.text = "이메일"
        $0.infoTextField.placeholder = "이메일을 입력해주세요"
    }
    let getPW = InputBoxView().then{
        $0.infoTitle.text = "비밀번호"
        $0.infoTextField.placeholder = "비밀번호를 입력해주세요"
    }
    let surePW = InputBoxView().then{
        $0.infoTitle.text = "비밀번호 확인"
        $0.infoTextField.placeholder = "비밀번호를 다시 입력해주세요"
    }
    let pwNotSame = UILabel().then{
        $0.textColor = .mainBlue //salmon color가 왜 안나오지?...
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
        $0.setImage(UIImage(named: "checkBox"), for: .normal)
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
        if !termsCheckBox.isSelected {
            termsCheckBox.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
        }
        else if termsCheckBox.isSelected {
            termsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
        }
        if !newsCheckBox.isSelected {
            termsCheckBox.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
        }
        else if newsCheckBox.isSelected {
            termsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        addConstraints()
    }
    

    func addConstraints(){
        contentView.adds([getName, getID, getEmail, getPW, surePW, newsCheckBox, newsLabel, termsCheckBox,termsLabel,viewTerms, signUpfinishButton ])

        getName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
        getID.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(getName.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(90)
        }
        getEmail.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(getID.snp.bottom)
            $0.height.equalTo(90)
        }
        getPW.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(getEmail.snp.bottom)
            $0.height.equalTo(90)
        }
        surePW.contentView.addSubview(pwNotSame)
        surePW.infoTextFieldBackGroundView.addSubview(pwCheckImage)
        surePW.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(getPW.snp.bottom)
        }
        pwNotSame.snp.makeConstraints{
            $0.top.trailing.equalToSuperview().inset(6)
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
