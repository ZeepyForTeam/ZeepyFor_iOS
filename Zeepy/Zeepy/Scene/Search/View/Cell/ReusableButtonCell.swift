//
//  ReusableButtonCell.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/04/29.
//

import UIKit
import SnapKit
import Then
import DLRadioButton

class ReusableButtonCell: UICollectionViewCell {
    
    let circleButton = UIButton().then{
        $0.frame.size = CGSize(width: 82, height: 82)
        //$0.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
    }
    let buttonTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(circleButton)
        self.addSubview(buttonTitle)
        
        circleButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        buttonTitle.snp.makeConstraints{
            $0.centerX.equalTo(circleButton)
            $0.top.equalTo(circleButton.snp.bottom).offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func onTapButton() {
        print("Button was tapped.")
    }
}
