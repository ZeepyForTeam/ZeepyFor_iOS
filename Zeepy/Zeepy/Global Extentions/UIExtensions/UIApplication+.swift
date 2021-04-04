//
//  UIApplication+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/04.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        
        if let top = (base as? UINavigationController)?.topViewController {
            return topViewController(top)
        }
        if let selected = (base as? UITabBarController)?.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
       let base = base ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
       
       if let top = (base as? UINavigationController)?.topViewController {
           return topViewController(top)
       }
       if let selected = (base as? UITabBarController)?.selectedViewController {
           return topViewController(selected)
       }
       if let presented = base?.presentedViewController {
           return topViewController(presented)
       }
       return base
   }
}
