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
  let contentView = UIView()
  let infoTitle = UILabel().then{
    $0.font = .nanumRoundBold(fontSize: 12)
  }
  let infoTextFieldBackGroundView = UIView().then{
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  let infoTextField = UITextField().then{
    $0.font = .nanumRoundBold(fontSize: 12)
    $0.attributedPlaceholder = NSAttributedString(
      string: "placeholder text",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayText])
  }
  let validationResult = UILabel().then {
    $0.setupLabel(text: "", color: .heartColor, font: .nanumRoundBold(fontSize: 10))
    $0.isHidden = true
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(contentView)
    contentView.snp.makeConstraints{
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
    contentView.adds([infoTitle,
                      infoTextFieldBackGroundView,
                      validationResult])
    
    infoTitle.snp.makeConstraints{
      $0.leading.equalToSuperview()
    }
    infoTextFieldBackGroundView.snp.makeConstraints{
      $0.top.equalTo(infoTitle.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
    }
    infoTextFieldBackGroundView.adds([infoTextField])
    infoTextField.snp.makeConstraints{
      $0.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(42)
    }
    validationResult.snp.makeConstraints{
      $0.trailing.equalTo(infoTextFieldBackGroundView)
      $0.bottom.equalTo(infoTitle.snp.bottom).offset(2)
    }
  }
}
