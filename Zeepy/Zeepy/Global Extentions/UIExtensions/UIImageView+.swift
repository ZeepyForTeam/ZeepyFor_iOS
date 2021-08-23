//
//  UIImageView+.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/06.
//

import Foundation
import UIKit

import Kingfisher

extension UIImageView {
  
  func setImage(from url : String, _ defaultImage : UIImage) {
  }
  public func urlToImage(_ urlString : String?, defaultImgPath : String?) {
    
  }
  
  public func imageFromUrl(_ urlString: String?, defaultImageName: String?) {
    
    let tmpUrl: String?
    if urlString == nil {
      tmpUrl = ""
    } else  {
      tmpUrl = urlString
    }
    if let url = tmpUrl,
       let defaultURL: String = defaultImageName {
      if url.isEmpty {
        self.image = UIImage(named: defaultURL)
      } else {
        self.kf.setImage(with: URL(string: url),
                         options: [.transition(ImageTransition.fade(0.5))])
      }
    }
  }
}
