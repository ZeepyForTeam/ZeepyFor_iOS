//
//  MapViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/05/06.
//

import UIKit
import MapKit
import Then
import SnapKit

class MapViewController: UIViewController {
    
    var items = [MTMapPOIItem]()
    
    func poiItem(name: String, latitude: Double, longitude: Double, imageName: String, tag: Int) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.customImage = UIImage(named: imageName)
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        item.tag = tag
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)
        
        return item
    }
    
    func makeMarkerArray(){
        items.append(poiItem(name: "달봉이네", latitude: 37.4981688, longitude: 127.0484572, imageName: "iconMapAct", tag: 1))
        mapView.addPOIItems(items)
        mapView.fitAreaToShowAllPOIItems()
    }
    
    
    var searchView = UIView().then{
        $0.setRounded(radius: 15)
        $0.borderWidth = 3
        $0.borderColor = .mainBlue
    }
    
    var searchImageView = UIImageView().then{
        $0.frame.size = CGSize(width: 5, height: 5)
        $0.image = UIImage(named: "iconSearch")
    }
    
    var searchTextField = UITextField().then{
        $0.placeholder = "지역, 동, 지하철역으로 입력해주세요."
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 12.0)
    }
    
    var searchButton = UIButton().then{
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
    }
    
    var mapView = MTMapView().then{
        $0.baseMapType = .standard
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.add(searchView)
        self.view.add(mapView)
        //initMapView()
        addConstraint()
        makeMarkerArray()
    }
    
    func addConstraint() {
    
        searchView.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(100)
            $0.height.equalTo(30)
        }
        searchView.addSubview(searchImageView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchButton)
        
        searchImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        searchTextField.snp.makeConstraints{
            $0.top.bottom.equalTo(searchView)
            $0.leading.equalTo(searchImageView.snp.trailing).offset(5)
        }
        searchButton.snp.makeConstraints{
            $0.top.bottom.equalTo(searchView)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        mapView.snp.makeConstraints{
            $0.top.equalTo(searchView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            
        }
    }
}

extension MapViewController : MTMapViewDelegate{
    private func initMapView(){
        self.mapView.delegate = self
    }
}
