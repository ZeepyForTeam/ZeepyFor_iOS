//
//  mapSearchViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/21.
//

import UIKit
import SnapKit
import Then

class mapSearchViewController: UIViewController {
    
    var searchRecordList = ["잠실새내역", "잠실종합운동장역", "잠실역"]
//    var searchRecommendList = ["잠실새내역", "잠실종합운동장역", "잠실역"]
    
    var searchView = UIView().then{
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchRecordTableView.delegate = self
        self.searchRecordTableView.dataSource = self
        self.view.backgroundColor = .white
        self.view.adds([searchView, searchRecordTableView])
        addConstraints()
        register()
    }
    func register() {
      self.searchRecordTableView.register(MapSearchTableViewCell.self, forCellReuseIdentifier: MapSearchTableViewCell.identifier)
    }
    
    func addConstraints(){
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
        searchRecordTableView.snp.makeConstraints{
            
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
    }
}
    
extension mapSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
}

extension mapSearchViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.searchRecordList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapSearchTableViewCell.identifier, for: indexPath) as? MapSearchTableViewCell else { return UITableViewCell() }
    MapSearchTableViewCell.searchRecordLabel.setupLabel(text: self.searchRecordList[indexPath.row], color: .blackText, font: .nanumRoundRegular(fontSize: 14))
    print("this is searchRecordList")
    print(searchRecordList[indexPath.row])
    MapSearchTableViewCell.awakeFromNib()
    return MapSearchTableViewCell
  }
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let MapSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapSearchTableViewCell.identifier, for: indexPath) as? MapSearchTableViewCell
////    MapSearchTableViewCell?.cellBackgroundView.backgroundColor = .black
//    tableView.reloadData()
//    tableView.awakeFromNib()
//  }
}

