//
//  LoadingHud.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/04.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public class LoadingHUD {
    private static let sharedInstance = LoadingHUD()
    
    private var backgroundView: UIView?
    private var spinningCircleView: SpinningCircleView?
    
    class func show() {
        let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        let spinningView = SpinningCircleView()
        spinningView.configure()
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(backgroundView)
            window.addSubview(spinningView)
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            spinningView.center = window.center
            
            sharedInstance.backgroundView?.removeFromSuperview()
            sharedInstance.spinningCircleView?.removeFromSuperview()
            sharedInstance.backgroundView = backgroundView
            sharedInstance.spinningCircleView = spinningView
        }
    }
    
    class func hide() {
        if let spinningView = sharedInstance.spinningCircleView,
           let backgroundView = sharedInstance.backgroundView {
            spinningView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
}


extension LoadingHUD: ReactiveCompatible { }
public extension Reactive where Base: LoadingHUD {
    static var loadingHUD: LoadingHUD {
        return LoadingHUD()
    }
    
    static var isAnimating: Binder<Bool> {
        return .init(
            UIApplication.shared,
            scheduler: MainScheduler.asyncInstance,
            binding: { hud, isVisible in
                if isVisible {
                    LoadingHUD.show()
                }
                else {
                    LoadingHUD.hide()
                }
            }
        )
    }
}

public class SpinningCircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let spinningCircle = CAShapeLayer()
    
    func configure() {
        frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.mainBlue.cgColor
        spinningCircle.lineWidth = 2.5
        spinningCircle.strokeEnd = 0.25
        spinningCircle.lineCap = .round
        layer.addSublayer(spinningCircle)
        
        let v = UIApplication.topViewController()?.view ?? UIView()
        v.addSubview(self)
        
        animate()
    }
    
    func animate() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi)
            }, completion: { _ in
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        self.transform = CGAffineTransform(rotationAngle: 0)
                    }) { completed in
                    self.animate()
                }
            })
    }
}
