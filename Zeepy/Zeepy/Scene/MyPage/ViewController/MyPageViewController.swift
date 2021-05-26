//
//  MyPageViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/05.
//

import Foundation
import UIKit
class MyPageViewController : BaseViewController {
  let point : UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))

    let path = UIBezierPath()
    path.move(to: CGPoint(x: 7.5, y: 0))
    path.addLine(to: CGPoint(x: 15, y: 15))
    path.addLine(to: CGPoint(x: 0, y: 15))
    path.close()
    
    let layer = CAShapeLayer()
    layer.frame = view.bounds
    layer.path = path.cgPath
    layer.fillColor = UIColor.white.cgColor
    layer.lineWidth = 0
    view.layer.addSublayer(layer)
    view.backgroundColor = .red
    return view
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(point)
    point.snp.makeConstraints{
      $0.width.height.equalTo(15)
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
