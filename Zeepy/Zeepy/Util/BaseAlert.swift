//
//  BaseAlert.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/05.
//

import Foundation
import UIKit

class BaseAlert: UIView {
    lazy var blackView: UIView = { [weak self] in
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.black
        $0.alpha = 0.5
        return $0
    }(UIView(frame: .zero))
    
    let alertView: UIView = {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView(frame: .zero))
    
    let titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel(frame: .zero))
    
    let grantButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = UIColor.white
        $0.setTitleColor(UIColor.mainBlue, for: .normal)
        $0.setTitle("", for: .normal)
        return $0
    }(UIButton(frame: .zero))
    
    let denyButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = UIColor.white
        $0.setTitleColor(UIColor.mainBlue, for: .normal)
        $0.setTitle("", for: .normal)
        return $0
    }(UIButton(frame: .zero))
    
    lazy var buttonStackView: UIStackView = { [weak self] in
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addArrangedSubview(denyButton)
        $0.addArrangedSubview(grantButton)
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = 10
        return $0
    }(UIStackView(frame: .zero))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseAlert {
    func initializeMainView() {
        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) {
            window.endEditing(true)
            alertView.alpha = 1
            blackView.alpha = 0.5
            
            blackView.frame = window.frame
            window.addSubview(blackView)
            window.addSubview(alertView)
            alertView.addSubview(titleLabel)
            alertView.addSubview(buttonStackView)
            
            NSLayoutConstraint.activate([
                alertView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                alertView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
                alertView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
                
                titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
                titleLabel.widthAnchor.constraint(equalTo: alertView.widthAnchor, constant: -32),
                titleLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor, constant: -24),
                
                buttonStackView.heightAnchor.constraint(equalToConstant: 48),
                buttonStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0),
                buttonStackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0),
                buttonStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0)
            ])
        }
    }
}
