//
//  mapSearchViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/21.
//

import UIKit

import Moya
import SnapKit
import Then
import Alamofire
import SwiftyJSON
import RxSwift
import Moya

class MapSearchViewController: BaseViewController {
  
  private let s3service = S3Service(
    provider: MoyaProvider<S3Router>(
      plugins: [NetworkLoggerPlugin(verbose: true)]))
  
  private var kakaoAddressModel: ResponseKakaoAddressModel?
  /// history = 0, search = 1
  var historyOrSearch = 0
  
  private let navigationView = CustomNavigationBar()
  var selectedName = ""
  var searchRecordLatitude: [Double] = []
  var searchRecordLongitude: [Double] = []
  var searchRecordList: [MTMapPointGeo] = []
  var searchRecordPlaceList: [String] = []
  //    var searchRecommendList = ["잠실새내역", "잠실종합운동장역", "잠실역"]
  
  var searchView = UIView().then{
    $0.backgroundColor = .white
    $0.setRounded(radius: 15)
    $0.setBorder(borderColor: .mainBlue, borderWidth: 2)
  }
  
  var betweenBackgroundView = UIView().then {
    $0.backgroundColor = .whiteGray
  }
  
  var searchImageView = UIImageView().then{
    $0.frame.size = CGSize(width: 5, height: 5)
    $0.image = UIImage(named: "iconSearch")
  }
  
  var searchTextField = UITextField().then{
    $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 12.0)
    $0.attributedPlaceholder = NSAttributedString(
      string: "지역, 동, 지하철역으로 입력해주세요.",
      attributes: [.font: UIFont.nanumRoundRegular(fontSize: 12),
                   .foregroundColor: UIColor.blackText])
  }
  
  var searchButton = UIButton().then{
    $0.setTitle("검색", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
  }
  
  var searchRecordTableView = UITableView().then{
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.rowHeight = UITableView.automaticDimension
    $0.separatorStyle = .none
    $0.isScrollEnabled = false
  }
  var shadowView = UIView().then{
    $0.backgroundColor = .mainBlue
  }
  //    var deleteTableViewCell = UITableViewCell().then{
  //        $0.backgroundColor = .white
  //    }
  //
  //    var deleteTableViewCellLabel = UILabel().then{
  //        $0.text = "최근 검색 기록 삭제"
  //    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.searchRecordTableView.delegate = self
    self.searchRecordTableView.dataSource = self
    self.view.backgroundColor = .white
    navigationView.naviTitle.text = "지도"
    self.view.adds([navigationView, searchView, betweenBackgroundView, searchRecordTableView])
    addConstraints()
    self.view.bringSubviewToFront(searchView)
    cellsRegister()
    lastRegister()
    fetchHistory()
    searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: .touchUpInside)
  }
  
  func cellsRegister() {
    self.searchRecordTableView.register(MapSearchTableViewCell.self, forCellReuseIdentifier: MapSearchTableViewCell.identifier)
  }
  func lastRegister() {
    self.searchRecordTableView.register(LastTableViewCell.self, forCellReuseIdentifier: LastTableViewCell.identifier)
  }
  func returnSearchContent(searchContent: String) -> String{
    return searchContent
  }
  func reloadTableView() {
    self.searchRecordTableView.reloadData()
  }
  func addConstraints(){
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    searchView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(19)
      $0.trailing.equalToSuperview().offset(-13)
      $0.top.equalTo(navigationView.snp.bottom).offset(5)
      $0.height.equalTo(40)
    }
    searchView.addSubview(searchImageView)
    searchView.addSubview(searchTextField)
    searchView.addSubview(searchButton)
    
    searchImageView.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(12)
      $0.width.height.equalTo(16)
    }
    searchTextField.snp.makeConstraints{
      $0.top.bottom.equalTo(searchView)
      $0.leading.equalTo(searchImageView.snp.trailing).offset(5)
    }
    searchButton.snp.makeConstraints{
      $0.top.bottom.equalTo(searchView)
      $0.trailing.equalToSuperview().inset(15)
    }
    betweenBackgroundView.snp.makeConstraints {
      $0.top.equalTo(self.searchView.snp.centerY)
      $0.leading.trailing.equalTo(self.searchView)
      $0.height.equalTo(30)
    }
    searchRecordTableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    searchRecordTableView.layer.cornerRadius = 16
    searchRecordTableView.snp.makeConstraints{
      $0.leading.trailing.equalTo(self.searchView)
      $0.top.equalTo(betweenBackgroundView.snp.bottom)
      $0.bottom.equalToSuperview()
    }
    //        makeDeleteTableViewCell()
  }
  
  private func fetchAddress() {
    s3service.fetchKakaoAddress(keyword: self.searchTextField.text ?? "")
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ResponseKakaoAddressModel.self,
                                          from: response.data)
            self.kakaoAddressModel = data
            self.historyOrSearch = 1
            self.searchRecordTableView.reloadData()
          }
          catch {
            print(error)
          }
        }
      }, onError: { error in
        print(error)
      }, onCompleted: {}).disposed(by: disposeBag)
  }
  
  private func fetchHistory() {
    self.searchRecordList = UserDefaultHandler.history ?? []
    self.searchRecordLongitude = UserDefaultHandler.historyLongitude ?? []
    self.searchRecordLatitude = UserDefaultHandler.historyLatitude ?? []
    self.searchRecordPlaceList = UserDefaultHandler.historyName ?? []
    print("history :\n \(self.searchRecordPlaceList)")
    self.reloadTableView()
  }
  @objc func TableViewCellSelected(sender: UIButton)-> String{
    sender.backgroundColor = UIColor(red: 95.0 / 255.0, green: 134.0 / 255.0, blue: 241.0 / 255.0, alpha: 0.15)
    //        sender.addSubview(shadowView)
    //        shadowView.snp.makeConstraints(){
    //            $0.top.bottom.leading.trailing.equalToSuperview()
    //        }
    return (sender.titleLabel?.text!)!
  }
  
  @objc func searchButtonClicked() {
    fetchAddress()
    print("yes")
  }
}

extension MapSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if historyOrSearch == 0 && indexPath.row == searchRecordPlaceList.count-1 {
      return 21
    }
    else if historyOrSearch == 1 && indexPath.row == 5 {
      return 21
    }
    else {
      return 30
    }
  }
}

extension MapSearchViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if historyOrSearch == 0 && self.searchRecordPlaceList.count >= 5 {
      return 6
    }
    else if historyOrSearch == 0 && self.searchRecordPlaceList.count < 5 {
      return self.searchRecordPlaceList.count + 1
    }
    else {
      return 6
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if historyOrSearch == 0 && indexPath.row == searchRecordPlaceList.count {
      guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LastTableViewCell.identifier, for: indexPath) as? LastTableViewCell else { return UITableViewCell() }
      MapSearchTableViewCell.addConstraints()
      return MapSearchTableViewCell
    }
    
    else if historyOrSearch == 1 && indexPath.row == 5 {
      guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LastTableViewCell.identifier, for: indexPath) as? LastTableViewCell else { return UITableViewCell() }
      MapSearchTableViewCell.addConstraints()
      return MapSearchTableViewCell
    }
    
    else if historyOrSearch == 1 {
      guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapSearchTableViewCell.identifier, for: indexPath) as? MapSearchTableViewCell else { return UITableViewCell() }
      let list = self.kakaoAddressModel?.documents[indexPath.row]
      MapSearchTableViewCell.addConstraints()
      MapSearchTableViewCell.rootViewController = self
      MapSearchTableViewCell.selectionStyle = .blue
      MapSearchTableViewCell.cellContentView.setTitle(list?.placeName, for: .normal)
      MapSearchTableViewCell.cellContentView.setTitleColor(.clear, for: .normal)
      MapSearchTableViewCell.searchRecordLabel.setupLabel(text: list?.placeName ?? "", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
      MapSearchTableViewCell.cellContentView.addTarget(self, action: #selector(TableViewCellSelected), for: .touchUpInside)
      return MapSearchTableViewCell
      
    }
    
    else if historyOrSearch == 0 {
      guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapSearchTableViewCell.identifier, for: indexPath) as? MapSearchTableViewCell else { return UITableViewCell()
      }
      let list = self.searchRecordPlaceList[indexPath.row]
      MapSearchTableViewCell.addConstraints()
      MapSearchTableViewCell.rootViewController = self
      MapSearchTableViewCell.selectionStyle = .blue
      MapSearchTableViewCell.cellContentView.setTitle(list, for: .normal)
      MapSearchTableViewCell.cellContentView.setTitleColor(.clear, for: .normal)
      MapSearchTableViewCell.searchRecordLabel.setupLabel(text: list, color: .blackText, font: .nanumRoundRegular(fontSize: 14))
      MapSearchTableViewCell.cellContentView.addTarget(self, action: #selector(TableViewCellSelected), for: .touchUpInside)
      return MapSearchTableViewCell
    }
    else {
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let navigationCount = (self.navigationController?.children.count)!
    let mapVC = self.navigationController?.children[navigationCount-2] as? MapViewController
    
    if indexPath.row < 5 && historyOrSearch == 1 {
      let docs = self.kakaoAddressModel?.documents[indexPath.row]
      if let doc = docs {
        let geo = MTMapPointGeo(latitude: Double(doc.x)!, longitude: Double(doc.y)!)
        let geoPlace = doc.placeName
        mapVC?.searchCoordinates = geo
        mapVC?.reAdjustMapCenter()
        self.searchRecordLatitude.append(Double(doc.x)!)
        self.searchRecordLongitude.append(Double(doc.y)!)
        UserDefaultHelper<[Double]>.set(self.searchRecordLatitude, forKey: .historyLatitude)
        UserDefaultHelper<[Double]>.set(self.searchRecordLongitude, forKey: .historyLongitude)
      
        self.searchRecordPlaceList.append(geoPlace)
        print(geoPlace)
        UserDefaultHelper<[String]>.set(self.searchRecordPlaceList, forKey: .historyName)
        print(UserDefaultHandler.historyName as? [String])
        self.navigationController?.popViewController(animated: true)
      }
    }
    
    else if indexPath.row < searchRecordLatitude.count && historyOrSearch == 0 {
      let lat = self.searchRecordLatitude[indexPath.row]
      let lon = self.searchRecordLongitude[indexPath.row]
      mapVC?.searchCoordinates = MTMapPointGeo(latitude: lat, longitude: lon)
      mapVC?.reAdjustMapCenter()
        self.navigationController?.popViewController(animated: true)
    }
    else {
      let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LastTableViewCell.identifier, for: indexPath) as? LastTableViewCell
      MapSearchTableViewCell!.backgroundColor = .mainBlue
      searchRecordList.removeAll()
      searchRecordPlaceList.removeAll()
      UserDefaultHelper<[Double]>.set(self.searchRecordLatitude, forKey: .historyLatitude)
      UserDefaultHelper<[Double]>.set(self.searchRecordLongitude, forKey: .historyLongitude)
      UserDefaultHelper<[String]>.set(self.searchRecordPlaceList, forKey: .historyName)
      fetchHistory()
    }
    //        returnSearchContent(searchContent: searchRecordList[indexPath.row])
  }
}

