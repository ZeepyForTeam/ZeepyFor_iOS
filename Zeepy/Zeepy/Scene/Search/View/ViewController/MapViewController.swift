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
import SwiftyJSON

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    // MARK: - Struct
    struct collectionViewCellModel {
        var imageName = String()
        var englishName = String()
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
        var count = Int()
    }
    // MARK: - Array
    var collectionViewCellList : [collectionViewCellModel] = [collectionViewCellModel(imageName: "emoji1", englishName: "BUSINESS", buttonTitle: "비즈니스형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji2",
                                                                                      englishName: "KIND",
                                                        buttonTitle: "친절형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji3", englishName: "GRAZE",buttonTitle: "방목형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji4",
                                                                                      englishName: "SOFTY",buttonTitle: "츤데레형", selected: true),
                                                              collectionViewCellModel(imageName: "emoji5",
                                                                                      englishName: "BAD",buttonTitle: "할많하않", selected: true)]
    
    var mapDetailModel = mapDetailViewModel(id: 0,
                                            address: "",
                                            buildingDetail: [""],
                                            owner: "",
                                            soundProofImageName: "",
                                            cleanlinessImageName: "",
                                            sunLightImageName: "",
                                            waterPressureImageName: "",
                                            overallLabel: "",
                                            count : 0)
    
    
    // MARK: - variable
    var selectedName = ""
    // MARK: - Components
  
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "지도")
  }
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
    //[ BUSINESS, KIND, GRAZE, SOFTY, BAD ]
    var items = [MTMapPOIItem]()
    var businessItems = [MTMapPOIItem]()
    var kindItems = [MTMapPOIItem]()
    var grazeItems = [MTMapPOIItem]()
    var softyItems = [MTMapPOIItem]()
    var badItems = [MTMapPOIItem]()
    var showItems = [MTMapPOIItem]()
    var currentMarkers = [MTMapPOIItem]()
    var selectedList = [String]()
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
    func makeLookingAroundButton(count : Int){
        lookingAroundButton.setTitle("건물리뷰 " + String(count) + "건 보러가기", for: .normal)
    }
    var locationManager:CLLocationManager!
    private let buildingService = BuildingService(provider: MoyaProvider<BuildingRouter>(plugins:[NetworkLoggerPlugin()]))
    
    func poiItem(id: Int, latitude: Double, longitude: Double, imageName: String) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.tag = id
        item.markerType = .customImage
        item.customImage = UIImage(named: imageName)
        item.markerSelectedType = .customImage
        item.customSelectedImage = UIImage(named: "iconMapAct")
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        return item
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        fetchMapDetail(id: poiItem.tag)
        tendencyImage.image = poiItem.customImage
        return false
    }

    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        mapDetailView.isHidden = true
        closedFloatingView.isHidden = false
    }
    func englishToKorean(name : String) -> String{
        if name == "AIRCONDITIONAL"{
            return "에어컨"
        }else if name == "WASHINGMACHINE"{
            return "세탁기"
        }else if name == "BED"{
            return "침대"
        }else if name == "CLOSET"{
            return "옷장"
        }else if name == "DESK"{
            return "책상"
        }else if name == "REFRIDGERATOR"{
            return "냉장고"
        }else if name == "INDUCTION"{
            return "인덕션"
        }else if name == "BURNER"{
            return "가스레인지"
        }else if name == "MICROWAVE"{
            return "전자레인지"
        }
        return ""
    }
    func stringToTotalEvaluation(name: String) -> String{
        if name == "GOOD"{
            return "다음에도 여기 살고 싶어요!"
        }else if name == "SOSO"{
            return "완전 추천해요!"
        }else if name == "BAD"{
            return "그닥 추천하지 않아요"
        }
        return " "
    }
    func stringToImageNameForCondition(name: String)-> String{
        if name == "GOOD"{
            return "iconSmile"
        }else if name == "PROPER"{
            return "iconSoso"
        }else if name == "BAD"{
            return "iconAngry"
        }
        return " "
    }
    func stringToImageNameForTotal(name: String)-> String{
        if name == "GOOD"{
            return "iconSmile"
        }else if name == "SOSO"{
            return "iconSoso"
        }else if name == "BAD"{
            return "iconAngry"
        }
        return " "
    }
    private func detailDataBinding(){
        addressLabel.text = mapDetailModel.address
        var detailList = ""
        for i in 0...mapDetailModel.buildingDetail.count - 1 {
            if i != mapDetailModel.buildingDetail.count - 1{
                detailList += englishToKorean(name: mapDetailModel.buildingDetail[i]) + ","
            }else {
                detailList += englishToKorean(name: mapDetailModel.buildingDetail[i])
            }
        }
        buildingDetail.text = detailList
        owner.text = mapDetailModel.owner
        soundProof.image = UIImage(named: mapDetailModel.soundProofImageName)
        cleanliness.image = UIImage(named: mapDetailModel.cleanlinessImageName)
        sunLight.image = UIImage(named: mapDetailModel.sunLightImageName)
        waterPressure.image = UIImage(named: mapDetailModel.waterPressureImageName)
        overall.text = mapDetailModel.overallLabel
        openFloatingCollectionView.isHidden = true
        closedFloatingView.isHidden = true
      lookingAroundButton.tag = mapDetailModel.id
        makeLookingAroundButton(count: mapDetailModel.count)
    }
    func stringtoLessorImageName(name: String)-> String{
        if name == "SOFTY"{
            return "emoji4Map"
        }else if name == "KIND"{
            return "emoji2Map"
        }else if name == "GRAZE"{
            return "emoji3Map"
        }else if name == "BUSINESS"{
            return "emoji1Map"
        }else if name == "BAD"{
            return "emoji5Map"
        }
        return " "
    }
    
    private func fetchMapPoints() {
        buildingService.fetchAllBuildings()
            .subscribe(onNext: { response in
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode([buildingAllListModel].self, from: response.data)
                        var count = 0
                        for ele in data {
                            if ele.reviews.count != 0{
                                count += 1
                            }
                            if ele.reviews.count != 0{
                                if ele.reviews[0].communcationTendency == "BUSINESS"{
                                    self.businessItems.append(self.poiItem(id: ele.id, latitude: ele.latitude, longitude: ele.longitude, imageName: self.stringtoLessorImageName(name: ele.reviews[0].communcationTendency)))
                                }
                                if ele.reviews[0].communcationTendency == "KIND"{
                                    self.kindItems.append(self.poiItem(id: ele.id, latitude: ele.latitude, longitude: ele.longitude, imageName: self.stringtoLessorImageName(name: ele.reviews[0].communcationTendency)))
                                }
                                if ele.reviews[0].communcationTendency == "GRAZE"{
                                    self.grazeItems.append(self.poiItem(id: ele.id, latitude: ele.latitude, longitude: ele.longitude, imageName: self.stringtoLessorImageName(name: ele.reviews[0].communcationTendency)))
                                }
                                if ele.reviews[0].communcationTendency == "SOFTY"{
                                    self.softyItems.append(self.poiItem(id: ele.id, latitude: ele.latitude, longitude: ele.longitude, imageName: self.stringtoLessorImageName(name: ele.reviews[0].communcationTendency)))
                                }
                                if ele.reviews[0].communcationTendency == "BAD"{
                                    self.badItems.append(self.poiItem(id: ele.id, latitude: ele.latitude, longitude: ele.longitude, imageName: self.stringtoLessorImageName(name: ele.reviews[0].communcationTendency)))
                                }
                            }
                            
                            self.items += (self.businessItems + self.kindItems + self.grazeItems + self.softyItems + self.badItems)
                        }
                        self.findCurrentMarker()
                        print("count의 갯수는", count)
                    }
                    catch {
                        print("fetchMapPointError")
                        print(error)
                    }
                }
            }, onError: { error in
                print(error)
            }, onCompleted: {}).disposed(by: disposeBag)
    }
    
    private func fetchMapDetail(id : Int) { //이거는 선택됐을 때 실행하자.
        buildingService.fetchBuildingDetail(id: id)
            .subscribe(onNext: { response in
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(buildingAllListModel.self,
                                                      from: response.data)
                        self.mapDetailModel = mapDetailViewModel(id: data.id, address: data.shortAddress, buildingDetail: data.reviews[0].furnitures, owner: data.reviews[0].lessorReview, soundProofImageName: self.stringToImageNameForCondition(name: data.reviews[0].soundInsulation), cleanlinessImageName: self.stringToImageNameForCondition(name: data.reviews[0].pest), sunLightImageName: self.stringToImageNameForCondition(name: data.reviews[0].lightning), waterPressureImageName: self.stringToImageNameForCondition(name: data.reviews[0].waterPressure), overallLabel: self.stringToTotalEvaluation(name: data.reviews[0].totalEvaluation),count : data.reviews.count)
                        self.detailDataBinding()
                        self.layoutModalView()
                    }
                    catch {
                        print(error)
                    }
                }
            }, onError: { error in
                print(error)
            }, onCompleted: {}).disposed(by: disposeBag)
    }
    
    func returnList(index : Int) -> Array<String>{
        selectedList = collectionViewCellList.filter{$0.selected}.map{$0.englishName}
        filterItemsToShowItems(theTag: index)
        return selectedList
    }
    
    func filterItemsToShowItems(theTag: Int){
        showItems = []
        if selectedList.contains("BUSINESS") {
            showItems += businessItems
        }
        if selectedList.contains("KIND") {
            showItems += kindItems
        }
        if selectedList.contains("GRAZE") {
            showItems += grazeItems
        }
        if selectedList.contains("BAD") {
            showItems += badItems
        }
        if selectedList.contains("SOFTY") {
            showItems += softyItems
        }
        
        items = showItems
        mapView.removeAllPOIItems()
        mapView.addPOIItems(items)
        print("this is showItems")
        print(showItems)
        print("this is businessItems")
        print(businessItems)
        findCurrentMarker()
    }
    
    func reAdjustMapCenter(name: String){
        print("여기서 서버 불러와서 center 다시 잡자.")
    }
    
    private func findCurrentMarker() { //현재 보이는 맵에 있는 Marker들만 보여주기~!!
        let bounds = self.mapView.mapBounds
        let southWest = bounds?.bottomLeft
        let northEast = bounds?.topRight
        for marker in items {
            if marker.mapPoint.mapPointGeo().latitude > (southWest?.mapPointGeo().latitude)! &&
                marker.mapPoint.mapPointGeo().latitude < (northEast?.mapPointGeo().latitude)! &&
                marker.mapPoint.mapPointGeo().longitude > (southWest?.mapPointGeo().longitude)! &&
                marker.mapPoint.mapPointGeo().longitude < (northEast?.mapPointGeo().longitude)! {
                currentMarkers.append(marker)
            }
        }
        print("currentMarker개수는?")
        print(currentMarkers.count)
        mapView.removeAllPOIItems()
        mapView.addPOIItems(currentMarkers)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.add(searchView)
        self.view.add(mapView)
        self.view.add(mapDetailView)
        self.view.add(closedFloatingView)
        self.view.add(openFloatingCollectionView)
      self.view.add(naviView)
        initMapView()
        addConstraints()
        initCollectionview()
        searchTextField.rx.tap.bind{[weak self] in
            let vc = MapSearchViewController()
            self?.navigationController?.pushViewController(vc, animated: false)
        }.disposed(by: disposeBag)
        fetchMapPoints()
        
        //    fetchMapDetail()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    func addConstraints() {
      naviView.snp.makeConstraints{
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
        searchView.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview()
          $0.top.equalTo(naviView.snp.bottom)//?
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
    
    @objc func myLocationButtonTapped(){
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
        print("change center")
//        self.mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.587493119, longitude: 127.034183377)), zoomLevel: 4, animated: true)
        findCurrentMarker()
        
        func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
            print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
        }
    }
    
  @objc func lookingAroundButtonTapped(sender: UIButton){
    if let vc = LookAroundDetailViewController(nibName: nil, bundle: nil, model: sender.tag) {
      self.navigationController?.pushViewController(vc, animated: true)
    }
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
  override func swipeRecognizer() {
    print("여기선 안씀")
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
        if collectionViewCellList[indexPath.row].selected == true {
            cell?.backgroundColor = .mainYellow
            selectedTag = indexPath.row
            filterItemsToShowItems(theTag: selectedTag)
        }else if collectionViewCellList[indexPath.row].selected != true {
            cell?.backgroundColor = .white
        }
        print("selected된 것만 보여줘잇~~")
        returnList(index : selectedTag)
        print(collectionViewCellList.filter{$0.selected}.map{$0.englishName})
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
