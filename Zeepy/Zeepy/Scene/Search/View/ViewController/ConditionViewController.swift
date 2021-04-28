//
//  ConditionViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/04/27.
//

import UIKit
import SnapKit
import Then

class ConditionViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let buildingTitle = UILabel().then {
        $0.text = "건물유형"
        $0.font = UIFont(name: "NanumSquareRoundOTF-ExtraBold", size: 16.0)
    }
    let buildingStackView = UIStackView().then {
        $0.backgroundColor = .orange
    }
    let transactionTitle = UILabel().then {
        $0.text = "거래종류"
        $0.font = UIFont(name: "NanumSquareRoundOTF-ExtraBold", size: 16.0)
    }
    let transactionStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.distribution = .fillEqually
        
    }
    let priceTitle = UILabel().then {
        $0.text = "가격"
        $0.font = UIFont(name: "NanumSquareRoundOTF-ExtraBold", size: 16.0)
    }
    let priceShowView = UIView().then {
        $0.backgroundColor = .green
    }
    
    let priceView = UIView()
    let optionTitle = UILabel().then {
        $0.text = "가구옵션"
        $0.font = UIFont(name: "NanumSquareRoundOTF-ExtraBold", size: 16.0)
    }
    let optionStackView = UIView()
    let nextButton = UIButton().then {
        $0.frame.size = CGSize(width: 342,height: 52)
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setTitle("다음으로", for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView) // 메인뷰에
        addConstraint()
        
    }
    func addConstraint()
    {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        _ = [buildingTitle,buildingStackView,transactionTitle,transactionStackView,priceTitle,priceShowView,priceView,optionTitle,optionStackView,nextButton].map { self.contentView.addSubview($0)}
        
        
        buildingTitle.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        buildingStackView.snp.makeConstraints {
            $0.top.equalTo(buildingTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
//            $0.addArrangedSubview(blueView1)
//            $0.addArrangedSubview(redView1)
            $0.height.equalTo(300)
        }
        
        transactionTitle.snp.makeConstraints {
            $0.top.equalTo(buildingStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        transactionStackView.snp.makeConstraints {
            $0.top.equalTo(transactionTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        priceTitle.snp.makeConstraints {
            $0.top.equalTo(transactionStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        priceShowView.snp.makeConstraints {
            $0.top.equalTo(priceTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        priceView.snp.makeConstraints {
            $0.top.equalTo(priceShowView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        optionTitle.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        optionStackView.snp.makeConstraints {
            $0.top.equalTo(optionTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(optionStackView.snp.bottom)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
}
