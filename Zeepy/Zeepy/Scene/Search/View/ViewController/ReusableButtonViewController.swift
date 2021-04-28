//
//  ReusableButtonViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/04/28.
//

import UIKit
import SnapKit
import Then

class ReusableButtonViewController: UIViewController {

    let contentView = UIView()
    let circleButton = UIButton()
    let buttonTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        self.view.addSubview(contentView)
    }

    func makeReusableButtonView(){
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
    }
}
