//
//  InputBoxView.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/05.
//

import UIKit
import SnapKit
import Then

class InputBoxView: UIView {
    let infoTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let infoTextFieldBackGroundView = UIView().then{
        $0.backgroundColor = .gray244
        $0.setRounded(radius: 10)
    }
    let infoTextField = UITextField().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adds([infoTitle,infoTextFieldBackGroundView])
        
        infoTitle.snp.makeConstraints{
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(10)
        }
        infoTextFieldBackGroundView.snp.makeConstraints{
            $0.top.equalTo(infoTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        infoTextFieldBackGroundView.add(infoTextField)
        infoTextField.snp.makeConstraints{
            $0.top.equalTo(infoTitle.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(50)
        }
    }
}
