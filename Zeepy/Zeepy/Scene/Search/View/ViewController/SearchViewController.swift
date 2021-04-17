//
//  SearchViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/04/05.
//

import Foundation
import UIKit
class SearchViewController : BaseViewController {
  var MapView : MTMapView?
  override func viewDidLoad() {
    super.viewDidLoad()
    MapView = MTMapView(frame: self.view.bounds)
    if let mapView = MapView {
      mapView.baseMapType = .standard
      self.view.add(mapView)
    }
  }
}
