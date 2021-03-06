//
//  ReusableOptionCell.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/04/30.
//

import UIKit
import SnapKit
import Then

class ReusableOptionCell: UICollectionViewCell {
    
    let squareButton = UIButton().then{
        $0.backgroundColor = .mainBlue
        $0.setRounded(radius: 8)
    }
    let buttonTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
        $0.textColor = .white
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        let cellWidth = UIScreen.main.bounds.width
        self.addSubview(squareButton)
        self.addSubview(buttonTitle)
        
        squareButton.snp.makeConstraints{
            $0.width.equalTo(cellWidth/3) //엥
            $0.height.equalTo(30) //엥
            $0.center.top.trailing.leading.equalToSuperview()
        }
        
        buttonTitle.snp.makeConstraints{
            $0.centerX.equalTo(squareButton)
            $0.centerY.equalTo(squareButton)
            
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func onTapButton() {
        print("Button was tapped.")
    }
}
