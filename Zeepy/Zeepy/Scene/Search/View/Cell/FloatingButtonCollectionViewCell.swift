//

//  FloatingButtonCollectionViewCell.swift

//  Zeepy

//

//  Created by JUEUN KIM on 2021/05/16.

//

 

import UIKit

 

class FloatingButtonCollectionViewCell: UICollectionViewCell {

    

    var circleButton = UIButton().then{
        $0.isSelected = true
        $0.isUserInteractionEnabled = false
    }

    var buttonTitle = UILabel().then{

        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)

        $0.textColor = .black

    }

 

    func makeButton(imageName: String, buttonName: String) {

        self.backgroundColor = .mainYellow

        circleButton.setImage(UIImage(named: imageName), for: .normal)

        buttonTitle.text = buttonName

    }

    

    override init(frame: CGRect) {

        super.init(frame: frame)

        setUpCollectionViewCell()

        if circleButton.isFocused {
            self.backgroundColor = .mainYellow
        }
    }

    

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }

    

    func setUpCollectionViewCell(){

        self.addSubview(circleButton)

        self.addSubview(buttonTitle)

        circleButton.snp.makeConstraints(){

            $0.top.left.right.equalToSuperview()

        }

        buttonTitle.snp.makeConstraints(){

            $0.top.equalTo(circleButton.snp.bottom)

            $0.centerX.equalTo(circleButton)

            $0.bottom.equalToSuperview()

        }

    }

}

 
