//
//  snsOptionButtonCell.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/04.
//

import UIKit
import SnapKit
import Then

class snsOptionButtonCell: UIButton {
    var snsImage = UIImageView()
    var snsContentLabel = UILabel()
    
    func setSNSButton(imageName: String, snsTitle: String){
        if snsTitle == "이메일" :
            self.backgroundColor =
        if snsTitle ==
        snsImage.image = UIImage(named: imageName)
        snsContentLabel.text = "\(snsTitle)로 간편가입"
    }
    
    func addConstraints(){
    }
}
