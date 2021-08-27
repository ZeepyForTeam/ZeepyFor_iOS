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
  
  private let navigationView = CustomNavigationBar()
  var selectedName = ""
  var searchRecordList = ["잠실새내역", "잠실종합운동장역", "잠실역"]
  //    var searchRecommendList = ["잠실새내역", "잠실종합운동장역", "잠실역"]
  
  var searchView = UIView().then{
    $0.backgroundColor = .white
    $0.setRounded(radius: 15)
    $0.setBorder(borderColor: .mainBlue, borderWidth: 2)
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
  
  var searchRecordTableView = UITableView().then{
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.rowHeight = UITableView.automaticDimension
    $0.separatorStyle = .none
    $0.isScrollEnabled = false
    $0.setRounded(radius: 16)
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
    self.view.adds([navigationView, searchView, searchRecordTableView])
    addConstraints()
    self.view.bringSubviewToFront(searchView)
    cellsRegister()
    lastRegister()
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
  func addConstraints(){
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    searchView.snp.makeConstraints{
      $0.trailing.leading.equalToSuperview().inset(16)
      $0.top.equalTo(self.navigationView.snp.bottom).offset(12)//?
      $0.height.equalTo(32)
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
    searchRecordTableView.snp.makeConstraints{
      $0.leading.trailing.equalTo(self.searchView)
      $0.top.equalTo(searchView.snp.centerY)
      $0.bottom.equalToSuperview()
    }
    //        makeDeleteTableViewCell()
  }
  
  private func fetchAddress() {
    print("여기야여기")
    print(self.searchTextField.text)
    s3service.fetchKakaoAddress(keyword: self.searchTextField.text ?? "")
      .subscribe(onNext: { response in
        if response.statusCode == 200 {
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ResponseKakaoAddressModel.self,
                                          from: response.data)
            self.kakaoAddressModel = data
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
    return 40
  }
}

extension MapSearchViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.searchRecordList.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row < searchRecordList.count {
      guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapSearchTableViewCell.identifier, for: indexPath) as? MapSearchTableViewCell else { return UITableViewCell() }
      let list = self.kakaoAddressModel?.documents[indexPath.row]
      MapSearchTableViewCell.addConstraints()
      MapSearchTableViewCell.cellContentView.setTitle(list?.placeName, for: .normal)
      MapSearchTableViewCell.cellContentView.setTitleColor(.clear, for: .normal)
      MapSearchTableViewCell.searchRecordLabel.setupLabel(text: list?.placeName ?? "", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
      MapSearchTableViewCell.cellContentView.addTarget(self, action: #selector(TableViewCellSelected), for: .touchUpInside)
      return MapSearchTableViewCell
      
    }
    else {
      guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LastTableViewCell.identifier, for: indexPath) as? LastTableViewCell else { return UITableViewCell() }
      MapSearchTableViewCell.addConstraints()
      return MapSearchTableViewCell
    }
    tableView.reloadData()
    tableView.reloadInputViews()
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row < searchRecordList.count {
      let list = self.kakaoAddressModel?.documents[indexPath.row]
      let navigationCount = (self.navigationController?.children.count)!
      let mapVC = self.navigationController?.children[navigationCount-2] as? MapViewController
      let docs = self.kakaoAddressModel?.documents[indexPath.row]
      if let doc = docs {
        mapVC?.searchCoordinates = MTMapPointGeo(latitude: Double(doc.x)!, longitude: Double(doc.y)!)
        mapVC?.reAdjustMapCenter()
        self.selectedName = list?.placeName ?? ""
        self.navigationController?.popViewController(animated: true)
      }
    }
    else {
      let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: LastTableViewCell.identifier, for: indexPath) as? LastTableViewCell
      MapSearchTableViewCell!.backgroundColor = .mainBlue
      searchRecordList.removeAll()
    }
    //        returnSearchContent(searchContent: searchRecordList[indexPath.row])
    tableView.reloadData()
    tableView.awakeFromNib()
  }
}

