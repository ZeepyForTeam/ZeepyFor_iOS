//
//  tendencyButton.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/05/08.
//

import UIKit

class tendencyButton: UIView {

    var circleButton = UIButton()
    
    var buttonTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }

    func makeButton(imageName: String, buttonName: String) {
        circleButton.setImage(UIImage(named: imageName), for: .normal)
        buttonTitle.text = buttonName
    }
    
}
