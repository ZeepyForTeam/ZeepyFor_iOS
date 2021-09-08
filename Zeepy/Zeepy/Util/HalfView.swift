//
//  HalfView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/25.
//

import UIKit
import Foundation
class HalfAppearView: UIView {
    static let shared = HalfAppearView()
    var addedSubView: UIView!
    private var viewCenter: CGPoint?
    private var customAction : (() -> Void)?
    lazy var blackView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.alpha = 0.5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        return $0
    }(UIView(frame: .zero))
    let halfView: UIView = {
        $0.backgroundColor = .white
        $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView(frame: .zero))
    let gestureHandler: UIView = {
        $0.backgroundColor = .white
        let handlerView: UIView = {
            $0.backgroundColor = .gray249
            $0.layer.cornerRadius = 4
            return $0
        }(UIView(frame: .zero))
        $0.addSubview(handlerView)
        handlerView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(87)
            $0.height.equalTo(8)
            $0.bottom.equalToSuperview()
        }
        return $0
    }(UIView(frame: .zero))
    override init(frame:CGRect) {
        super.init(frame: frame)
        //initializeMainView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension HalfAppearView {
    func initializeMainView(_ halfViewHeight : Int? = nil) {
        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) {
            window.endEditing(true)
            halfView.alpha = 1
            blackView.alpha = 0.5
            blackView.frame = window.frame
            window.addSubview(blackView)
            window.addSubview(halfView)
            halfView.addSubview(gestureHandler)
            halfView.snp.remakeConstraints{
                $0.leading.trailing.bottom.equalToSuperview()
                if let height = halfViewHeight {
                    $0.height.equalTo(height)
                }
                else {
                    $0.height.equalTo(blackView.frame.size.height / 2.0)
                }
            }
            gestureHandler.snp.remakeConstraints{
                $0.top.centerX.equalToSuperview()
                $0.height.equalTo(24)
                $0.width.equalTo(100)
            }
            gestureHandler.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(scrollDown)))

        }
    }
    @objc
    func scrollDown(gesture : UIPanGestureRecognizer) {
        let target = gesture.view?.superview
        switch gesture.state {
        case .began :
          viewCenter = target?.center
        case .changed :
          let translation = gesture.translation(in: self.halfView)
          if translation.y > 0 {
            target?.center = CGPoint(x: viewCenter!.x, y: viewCenter!.y + translation.y)
          }
        case .ended :
          let translation = gesture.translation(in: self.halfView)
            let height = self.halfView.frame.size.height
          if translation.y > height * 0.3 {
            dissmissFromSuperview()
          }
          else if translation.y > 0 {
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                           target?.center = CGPoint(x: self.viewCenter!.x, y: self.viewCenter!.y)
                           }, completion: nil)
          }
        default : print("")
        }
    }
    @objc func dismiss(gesture: UITapGestureRecognizer) {
        dissmissFromSuperview()
    }
    @objc
    func dissmissFromSuperview() {
        if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
            let transform = CGAffineTransform(translationX: 0, y: 200)
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: { [unowned self] in
                            self.halfView.transform = transform
                            self.halfView.alpha = 0
                            self.blackView.alpha = 0
                           }, completion: { _ in
                            self.blackView.removeFromSuperview()
                            self.halfView.removeFromSuperview()
                            self.addedSubView.removeFromSuperview()
                            self.addedSubView = nil
                           })
        }
    }
    func dissmissWithAction(action: @escaping () -> Void) {
        if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
            self.customAction = action
            let transform = CGAffineTransform(translationX: 0, y: 200)
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: { [unowned self] in
                            self.halfView.transform = transform
                            self.halfView.alpha = 0
                            self.blackView.alpha = 0
                           }, completion: { _ in
                            self.blackView.removeFromSuperview()
                            self.halfView.removeFromSuperview()
                            self.customAction!()
                            self.addedSubView.removeFromSuperview()
                            self.addedSubView = nil

                           })
        }
    }
}
extension HalfAppearView {
    func appearHalfView(subView: UIView, _ halfViewHeight : Int? = nil) {
        initializeMainView(halfViewHeight)
        addedSubView = subView
        halfView.addSubview(addedSubView)
        addedSubView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(gestureHandler.snp.bottom)
        }
        if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
            let transform = CGAffineTransform(translationX: 0, y: 300)
            halfView.transform = transform
            blackView.alpha = 0
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.blackView.alpha = 0.5
                            self.halfView.transform = .identity
                           }, completion: nil)
        }
    }
}
