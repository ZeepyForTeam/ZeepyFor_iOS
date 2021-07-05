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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.adds([contentView, getName, getID, getEmail, getPW, surePW])
        contentView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        addConstraints()
    }
    
    func addConstraints(){
        contentView.adds([getName, getID, getEmail, getPW, surePW])
        
        getName.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
        }
//        getID.snp.makeConstraints{
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalTo(getName.snp.bottom)
//        }
//        getEmail.snp.makeConstraints{
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalTo(getID.snp.bottom)
//        }
//        getPW.snp.makeConstraints{
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalTo(getEmail.snp.bottom)
//        }
//        surePW.snp.makeConstraints{
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalTo(getPW.snp.bottom)
//        }
    }

}
