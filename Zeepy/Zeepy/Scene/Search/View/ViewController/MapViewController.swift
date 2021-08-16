//
//  MapViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/05/06.
//

import UIKit
import Then
import SnapKit
import Moya
import CoreLocation

class MapViewController: BaseViewController, CLLocationManagerDelegate {
  // MARK: - Struct
  struct collectionViewCellModel {
    var imageName = String()
    var buttonTitle = String()
    var selected = Bool()
  }
  
  struct mapDetailViewModel {
    var id = Int()
    var address = String()
    var buildingDetail = [String]()
    var owner = String()
    var soundProofImageName = String()
    var cleanlinessImageName = String()
    var sunLightImageName = String()
    var waterPressureImageName = String()
    var overallLabel = String()
  }
  // MARK: - Array
  var collectionViewCellList : [collectionViewCellModel] = [collectionViewCellModel(imageName: "emoji1", buttonTitle: "비즈니스형", selected: true),
                                                            collectionViewCellModel(imageName: "emoji2", buttonTitle: "친절형", selected: true),
                                                            collectionViewCellModel(imageName: "emoji3", buttonTitle: "방목형", selected: true),
                                                            collectionViewCellModel(imageName: "emoji4", buttonTitle: "츤데레형", selected: true),
                                                            collectionViewCellModel(imageName: "emoji5", buttonTitle: "할많하않", selected: true)]
  
    var mapDetailViewList : [mapDetailViewModel] = [mapDetailViewModel(id : 1, address: "주소1", buildingDetail: ["디테일1"], owner: "집주인1", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가1"),
                                                    mapDetailViewModel(id : 2,address: "주소2", buildingDetail: ["디테일2"], owner: "집주인1", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가2"),
                                                    mapDetailViewModel(id : 3,address: "주소3", buildingDetail: ["디테일1"], owner: "집주인1", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가1"),
                                                    mapDetailViewModel(id : 4,address: "주소4", buildingDetail: ["디테일1"], owner: "집주인1", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가1"),
                                                    mapDetailViewModel(id : 5,address: "주소5", buildingDetail: ["디테일1"], owner: "집주인1", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가1")]
  // MARK: - Components
  var tendencyButton = UIView().then{
    $0.frame.size = CGSize(width: 60, height: 70)
  }
  
  var circleButton = UIButton()
  
  var buttonTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
  }
  
  func makeButton(imageName: String, buttonName: String) {
    circleButton.setImage(UIImage(named: imageName), for: .normal)
    buttonTitle.text = buttonName
  }
  
  var items = [MTMapPOIItem]()
  var showItems = [MTMapPOIItem]()
  var currentMarkers = [MTMapPOIItem]()
  
  var searchView = UIView().then{
    $0.setRounded(radius: 15)
    $0.setBorder(borderColor: .mainBlue, borderWidth: 2)
  }
  
  var searchImageView = UIImageView().then{
    $0.frame.size = CGSize(width: 5, height: 5)
    $0.image = UIImage(named: "iconSearch")
  }
  
  var searchTextField = UIButton().then{
    $0.setTitle("지역, 동, 지하철역으로 입력해주세요.", for: .normal) 
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFR", size: 12.0)
    $0.setTitleColor(.gray244, for: .normal)
  }
  
  var searchButton = UIButton().then{
    $0.setTitle("검색", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
  }
  
  var mapView = MTMapView().then{
    $0.baseMapType = .standard
  }
  
  var closedFloatingView = UIView().then{
    $0.backgroundColor = .white
    $0.setRounded(radius: 5)
  }
  
  var closedFloatingButton = UIButton().then{
    $0.setImage(UIImage(named: "moreVert"), for: .normal)
    $0.addTarget(self, action: #selector(openTendencyCollectionView), for: .touchUpInside)
  }
  
  var closedFloatingLabel = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    $0.text = "소통유형별"
  }
  
  var openFloatingCollectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    struct mapDetailViewModel {
        var address = String()
        var buildingDetail = String()
        var owner = String()
        var soundProofImageName = String()
        var cleanlinessImageName = String()
        var sunLightImageName = String()
        var waterPressureImageName = String()
        var overallLabel = String()
    }
    // MARK: - Array
    var collectionViewCellList : [collectionViewCellModel] = [collectionViewCellModel(imageName: "emoji1", buttonTitle: "비즈니스형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji2", buttonTitle: "친절형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji3", buttonTitle: "방목형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji4", buttonTitle: "츤데레형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji5", buttonTitle: "할많하않", selected: true)]

    var mapDetailViewList : [mapDetailViewModel] = [mapDetailViewModel(address: "주소1", buildingDetail: "디테일1",owner: "집주인1", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가1"),
        
                                                    mapDetailViewModel(address: "주소2", buildingDetail: "디테일2", owner: "집주인2", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가2"),
        
                                                    mapDetailViewModel(address: "주소3", buildingDetail: "디테일3", owner: "집주인3", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가3"),
        
                                                    mapDetailViewModel(address: "주소4", buildingDetail: "디테일4", owner: "집주인4", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가4"),
        
                                                    mapDetailViewModel(address: "주소5", buildingDetail: "디테일5", owner: "집주인5", soundProofImageName: "iconSmile", cleanlinessImageName: "iconSmile", sunLightImageName: "iconSmile", waterPressureImageName: "iconSmile", overallLabel: "종합평가5")]
    // MARK: - Components
    
    var tendencyButton = UIView().then{
        $0.frame.size = CGSize(width: 60, height: 70)
    }
    
    var circleButton = UIButton()

    var buttonTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }

    func makeButton(imageName: String, buttonName: String) {
        circleButton.setImage(UIImage(named: imageName), for: .normal)
        buttonTitle.text = buttonName
    }
 
    var items = [MTMapPOIItem]()
    var showItems = [MTMapPOIItem]()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.isHidden = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.setRounded(radius: 10)
    collectionView.backgroundColor = .white
    collectionView.setBorder(borderColor: .gray244, borderWidth: 3)
    collectionView.isUserInteractionEnabled = true
    return collectionView
  }()
    let myLocationView = UIView().then{
        $0.frame.size = CGSize(width: 100, height: 100)
        $0.setRounded(radius: 5)
        $0.backgroundColor = .pale
    }

    let myLocationButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named:"iconMyLocation"), for: .normal)
        $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }
    
  let mapDetailView = UIView().then{
    $0.layer.cornerRadius = 15
    $0.backgroundColor = .white
    $0.isHidden = true
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  var tendencyImage = UIImageView().then(){
    $0.image = UIImage(named: "emoji1Map")
  }
  
  var addressLabel = UILabel().then{
    $0.text = "주소"
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 18.0)
    $0.textColor = .black
  }
  
  var buildingDetailTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "건물 상세"
  }
  
  var buildingDetail = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 14.0)
  }
  
  var ownerTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "임대인"
  }
  
  var owner = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 14.0)
  }
  
  var soundProofTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "방음"
  }
  
  var soundProof = UIImageView().then(){
    $0.image = UIImage(named: "iconSmile")
  }
  
  var cleanlinessTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "청결"
  }
  
  var cleanliness = UIImageView().then(){
    $0.image = UIImage(named: "iconSmile")
  }
  
  var sunLightTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "채광"
  }
  
  var sunLight = UIImageView().then(){
    $0.image = UIImage(named: "iconSmile")
  }
  
  var waterPressureTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "수압"
  }
  
  var waterPressure = UIImageView().then(){
    $0.image = UIImage(named: "iconSmile")
  }
  
  var overallTitle = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.textColor = .mainBlue
    $0.text = "종합 평가"
  }
  var overall = UILabel().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 14.0)
  }
  
  var lookingAroundButton = UIButton().then(){
    $0.backgroundColor = .mainBlue
    $0.setTitle("건물 리뷰 25건 보러가기", for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    $0.titleLabel?.textColor = .white
    $0.setRounded(radius: 10)
    $0.addTarget(self, action: #selector(lookingAroundButtonTapped), for: .touchUpInside)
  }

    private let buildingService = BuildingService(provider: MoyaProvider<BuildingRouter>(plugins:[NetworkLoggerPlugin()]))
    
  func poiItem(id: Int, latitude: Double, longitude: Double, imageName: String) -> MTMapPOIItem {
    let item = MTMapPOIItem()
    item.markerType = .customImage
    item.customImage = UIImage(named: imageName)
    item.markerSelectedType = .customImage
    item.customSelectedImage = UIImage(named: "iconMapAct")
    item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
    item.showAnimationType = .noAnimation
    return item
  }
  
  func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
    for i in 0 ..< items.count{
      if items[i].itemName == poiItem.itemName{
        tendencyImage.image = poiItem.customImage
        addressLabel.text = mapDetailViewList[i].address
        buildingDetail.text = mapDetailViewList[i].buildingDetail.joined()
        owner.text = mapDetailViewList[i].owner
        soundProof.image = UIImage(named: mapDetailViewList[i].soundProofImageName)
        cleanliness.image = UIImage(named: mapDetailViewList[i].cleanlinessImageName)
        sunLight.image = UIImage(named: mapDetailViewList[i].sunLightImageName)
        waterPressure.image = UIImage(named: mapDetailViewList[i].waterPressureImageName)
        overall.text = mapDetailViewList[i].overallLabel
      }
    }
    layoutModalView()
    openFloatingCollectionView.isHidden = true
    closedFloatingView.isHidden = true
    return false
  }
  
  func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
    mapDetailView.isHidden = true
    closedFloatingView.isHidden = false
  }
    
  
//  func declarePOIItems(){
//    items.append(poiItem(id: 1,latitude: 37.4981688, longitude: 127.0484572, imageName: "emoji1Map"))
//    items.append(poiItem(id: 2,latitude: 37.4980689, longitude: 127.0484572, imageName: "emoji2Map"))
//    items.append(poiItem(id: 3,latitude: 37.4984686, longitude: 127.0484572, imageName: "emoji3Map"))
//    items.append(poiItem(id: 4,latitude: 37.4985683, longitude: 127.0484572, imageName: "emoji4Map"))
//    items.append(poiItem(id: 5,latitude: 37.4986685, longitude: 127.0484572, imageName: "emoji5Map"))
//
//    showItems = items
//    mapView.addPOIItems(items)
//    mapView.fitAreaToShowAllPOIItems()
//  }
//    private func fetchMapPoints() {
//        buildingService.fetchBuildingList(param: .init())
//            .subscribe(onNext: { response in
//            if response.statusCode == 200 {
//              do {
//                let decoder = JSONDecoder()
//                let data = try decoder.decode(BuildingContent.self, from: response.data)
//                self.items.append(self.poiItem(id: data.id, latitude: data.latitude, longitude: data.longitude, imageName: "emoji1Map"))
//              }
//              catch {
//                print(error)
//              }
//            }
//          }, onError: { error in
//            print(error)
//          }, onCompleted: {}).disposed(by: disposeBag)
////        mapView.addPOIItems(items)
////        mapView.fitAreaToShowAllPOIItems()
//        findCurrentMarker()
//      }
    private func fetchMapDetail() { //이거는 선택됐을 때 실행하자.
        buildingService.fetchBuildingDetail(id: mapDetailViewList[0].id)
          .subscribe(onNext: { response in
            if response.statusCode == 200 {
              do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Review.self,
                                              from: response.data)
                self.mapDetailViewList.append(mapDetailViewModel(id : data.id, address: data.address, buildingDetail: data.furnitures, owner: data.lessorReview, soundProofImageName: data.soundInsulation, cleanlinessImageName: data.pest, sunLightImageName: data.lightning, waterPressureImageName: data.waterPressure, overallLabel: data.review))
              }
              catch {
                print(error)
              }
            }
          }, onError: { error in
            print(error)
          }, onCompleted: {}).disposed(by: disposeBag)
      }
//    //---
//    private func setupCafeInformation(cafeId: String) {
//        mapService.getBuildingPoints(id: mapDetailViewModel)
//          .subscribe(onNext: { response in
//            if response.statusCode == 200 {
//              do {
//                print("success")
//                self.navigationController?.popToRootViewController(animated: true)
//              }
//            }
//          }, onError: { error in
//            print(error)
//          }, onCompleted: {}).disposed(by: disposeBag)
//      }
//    //---
    private func findCurrentMarker() { //현재 보이는 맵에 있는 Marker들만 보여주기~!!
      let bounds = self.mapView.mapBounds
        
        let southWest = bounds?.bottomLeft
        let northEast = bounds?.topRight
      for marker in items {
        if
            marker.mapPoint.mapPointGeo().latitude > (southWest?.mapPointGeo().latitude)! &&
                marker.mapPoint.mapPointGeo().latitude < (northEast?.mapPointGeo().latitude)! &&
                marker.mapPoint.mapPointGeo().longitude > (southWest?.mapPointGeo().longitude)! &&
                marker.mapPoint.mapPointGeo().longitude < (northEast?.mapPointGeo().longitude)! {
            currentMarkers.append(marker)
            mapView.addPOIItems(currentMarkers)
            mapView.fitAreaToShowAllPOIItems()
        }
      }
    }
    var locationManager:CLLocationManager!
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.add(searchView)
    self.view.add(mapView)
    self.view.add(mapDetailView)
    self.view.add(closedFloatingView)
    self.view.add(openFloatingCollectionView)
    initMapView()
    addConstraints()
//    declarePOIItems()
    initCollectionview()
    searchTextField.rx.tap.bind{[weak self] in
      let vc = MapSearchViewController()
      self?.navigationController?.pushViewController(vc, animated: false)
    }.disposed(by: disposeBag)
    setupNavigation()
//    fetchMapPoints()
    fetchMapDetail()
    locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
}
private func setupNavigation() {
  self.setupNavigationBar(.white)
  self.setupNavigationItem(titleText: "지도")
}
  func addConstraints() {
    searchView.snp.makeConstraints{
      $0.trailing.leading.equalToSuperview()
      $0.top.equalTo(95)//?
      $0.height.equalTo(40)
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
    mapView.addSubview(myLocationView)
    
    mapView.snp.makeConstraints{
      $0.top.equalTo(searchView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview()
      $0.width.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    operateFloatingButton()
    
    myLocationView.addSubview(myLocationButton)
    
    myLocationView.snp.makeConstraints{
        $0.top.equalTo(searchView.snp.bottom).offset(16)
        $0.leading.equalTo(searchView.snp.leading).offset(16)
    }
    
    myLocationButton.snp.makeConstraints{
        $0.bottom.top.leading.trailing.equalToSuperview().inset(5)
    }
  }
//  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            //location5
//            switch status {
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("GPS 권한 설정됨")
//                locationManager.startUpdatingLocation() // 중요!
//            case .restricted, .notDetermined:
//                print("GPS 권한 설정되지 않음")
//                getLocationUsagePermission()
//            case .denied:
//                print("GPS 권한 요청 거부됨")
//                getLocationUsagePermission()
//            default:
//                print("GPS: Default")
//            }
//        }
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다
        if let coor = manager.location?.coordinate{
            print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
        }
  }
  func operateFloatingButton(){
    if !closedFloatingView.isHidden{
      closedFloatingView.translatesAutoresizingMaskIntoConstraints = false
      closedFloatingView.snp.makeConstraints{
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        $0.width.equalTo(80)
        $0.height.equalTo(90)
      }
      closedFloatingView.addSubview(closedFloatingButton)
      closedFloatingView.addSubview(closedFloatingLabel)
      closedFloatingButton.snp.makeConstraints{
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(10)
      }
      closedFloatingLabel.snp.makeConstraints{
        $0.centerX.equalToSuperview()
        $0.bottom.equalToSuperview().offset(-10)
      }
    }
    if !openFloatingCollectionView.isHidden{
      openFloatingCollectionView.snp.makeConstraints{
        $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(-16)
        $0.height.equalTo(90)
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  @objc func openTendencyCollectionView(sender: UIButton) {
    openFloatingCollectionView.isHidden = false
    closedFloatingView.isHidden = true
    operateFloatingButton()
  }

    @objc func  myLocationButtonTapped(){
        func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
                let currentLocation = location?.mapPointGeo()
            print("현위치")
            print(currentLocation?.latitude)
                if let latitude = currentLocation?.latitude,
                   let longitude = currentLocation?.longitude{
                    print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
                    mapView.setMapCenter(MTMapPoint(geoCoord: currentLocation!), zoomLevel: 4, animated: true)
                }
            }
        func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
                print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
            }
//        mapView.fitAreaToShowAllPOIItems()
    }
  @objc func lookingAroundButtonTapped(){
    print("lookingAroundButtonTapped")
  }
  
  func layoutModalView(){
    mapDetailView.isHidden = false
    mapDetailView.snp.makeConstraints{
      $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
      $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
      $0.height.equalTo(210)
      $0.width.equalTo(self.view.snp.width)
    }
    mapDetailView.adds([tendencyImage, addressLabel, buildingDetailTitle, buildingDetail,ownerTitle, owner, soundProofTitle, soundProof, cleanlinessTitle, cleanliness, sunLightTitle, sunLight, waterPressureTitle, waterPressure, overallTitle, overall, lookingAroundButton])
    
    tendencyImage.snp.makeConstraints{
      $0.leading.top.equalToSuperview().offset(20)
    }
    addressLabel.snp.makeConstraints{
      $0.leading.equalTo(tendencyImage.snp.trailing).offset(15)
      $0.centerY.equalTo(tendencyImage)
    }
    buildingDetailTitle.snp.makeConstraints{
      $0.top.equalTo(addressLabel.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(16)
    }
    buildingDetail.snp.makeConstraints{
      $0.leading.equalTo(buildingDetailTitle.snp.trailing).offset(15)
      $0.centerY.equalTo(buildingDetailTitle)
    }
    ownerTitle.snp.makeConstraints{
      $0.top.equalTo(buildingDetailTitle.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(16)
    }
    owner.snp.makeConstraints{
      $0.leading.equalTo(ownerTitle.snp.trailing).offset(15)
      $0.centerY.equalTo(ownerTitle)
    }
    soundProofTitle.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(ownerTitle.snp.bottom).offset(15)
    }
    soundProof.snp.makeConstraints{
      $0.leading.equalTo(soundProofTitle.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    cleanlinessTitle.snp.makeConstraints{
      $0.leading.equalTo(soundProof.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    cleanliness.snp.makeConstraints{
      $0.leading.equalTo(cleanlinessTitle.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    sunLightTitle.snp.makeConstraints{
      $0.leading.equalTo(cleanliness.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    sunLight.snp.makeConstraints{
      $0.leading.equalTo(sunLightTitle.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    waterPressureTitle.snp.makeConstraints{
      $0.leading.equalTo(sunLight.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    waterPressure.snp.makeConstraints{
      $0.leading.equalTo(waterPressureTitle.snp.trailing).offset(10)
      $0.centerY.equalTo(soundProofTitle)
    }
    overallTitle.snp.makeConstraints{
      $0.top.equalTo(soundProofTitle.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(16)
    }
    overall.snp.makeConstraints{
      $0.top.equalTo(soundProofTitle.snp.bottom).offset(15)
      $0.leading.equalTo(overallTitle.snp.trailing).offset(8)
    }
    lookingAroundButton.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
}

// MARK: - Extensions
extension MapViewController : MTMapViewDelegate{
  private func initMapView(){
    self.mapView.delegate = self
  }
}

extension MapViewController : UICollectionViewDelegate, UICollectionViewDataSource {
  func initCollectionview(){
    self.openFloatingCollectionView.dataSource = self
    self.openFloatingCollectionView.delegate = self
    self.openFloatingCollectionView.register(FloatingButtonCollectionViewCell.self, forCellWithReuseIdentifier: FloatingButtonCollectionViewCell.identifier)
    
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FloatingButtonCollectionViewCell.identifier, for:indexPath) as? FloatingButtonCollectionViewCell
    cell?.setRounded(radius: 10)
    cell?.circleButton.setImage(UIImage(named: collectionViewCellList[indexPath.row].imageName), for: .normal)
    cell?.buttonTitle.text = collectionViewCellList[indexPath.row].buttonTitle
    cell?.circleButton.tag = indexPath.row
    
    var selectedTag = 6
    func filterItemsToShowItems(theTag: Int){
      for i in 0..<items.count{
        if items[i].tag == theTag{
          showItems.append(items[i])
        }
      }
    }
    if collectionViewCellList[indexPath.row].selected == true {
      cell?.backgroundColor = .mainYellow
      selectedTag = indexPath.row
      filterItemsToShowItems(theTag: selectedTag)
    }else if collectionViewCellList[indexPath.row].selected != true {
      cell?.backgroundColor = .white
    }
    mapView.addPOIItems(showItems)
    
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    mapView.removePOIItems(items)
    collectionViewCellList[indexPath.row].selected.toggle()
    showItems = []
    collectionView.reloadData()
  }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 60, height: 70)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 9
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
}
