//
//  MapDetailModalView.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/05/08.
//

import UIKit

class MapDetailModalView: UIView {
    struct RoomDetail {
        var id : Int
        var address : String
        var scale : Int
        var buildingDetail : String
        var owner : Int
        var soundProofImageName : Int
        var cleanImageName : Int
        var sunlightImageName : Int
        var waterPressureImageName : Int
        var overall : String
        var count : Int
    }
    var roomDetail : [RoomDetail] = [RoomDetail(id: 1, address: "방화동 어느 집" , scale: 32, buildingDetail: "화장실1, 침실1, 에어컨, 세탁기옵션" , owner: 1 , soundProofImageName: 1, cleanImageName: 2, sunlightImageName: 3, waterPressureImageName: 3, overall: "다음에도 여기 살고 싶다", count: 44)]
    var detailCollectionView = UICollectionView()
    
    var firstCell = UICollectionViewCell()
    var tendencyImageView = UIImageView().then{
        $0.image = UIImage(named: "ellipse341") //?
    }
    var addressLabel = UILabel().then(){
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 18.0)
    }
    
    var secondCell = UICollectionViewCell()
    var buildingDetailTitle = UILabel().then(){
        $0.text = "건물 상세"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var buildingDetail = UILabel().then(){
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 14.0)
    }
    
    var thirdCell = UICollectionViewCell()
    var ownerTitle = UILabel().then(){
        $0.text = "임대인"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var owner = UILabel().then(){
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 14.0)
    }
    
    var fourthCell = UICollectionViewCell()
    var soundProofTitle = UILabel().then(){
        $0.text = "방음"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var soundProofImage = UIImageView()
    var cleanTitle = UILabel().then(){
        $0.text = "청결"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var cleanImage = UIImageView()
    var sunLightTitle = UILabel().then(){
        $0.text = "채광"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var sunLightImage = UIImageView()
    var waterPressureTitle = UILabel().then(){
        $0.text = "수압"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var waterPressureImage = UIImageView()
    
    var fifthCell = UICollectionViewCell()
    var overallTitle = UILabel().then(){
        $0.text = "종합평가"
        $0.textColor = .mainBlue
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
    }
    var overall = UILabel().then(){
        $0.font = UIFont(name: "NanumSquareRoundOTFR", size: 14.0)
    }
    
    var lookingAroundButton = UIButton().then(){
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 14.0)
        $0.titleLabel?.textColor = .white
        $0.setRounded(radius: 5)
    }
    
    func fillOutView(){
        lookingAroundButton.titleLabel?.text = "건물 리뷰 \(roomDetail[0].count)건 보러가기"
        buildingDetail.text = roomDetail[0].buildingDetail
        if roomDetail[0].owner == 1 {
            owner.text = "따듯해 녹아내리는 중 친절형1"
        }else if roomDetail[0].owner == 2 {
            owner.text = "따듯해 녹아내리는 중 친절형2"
        }else if roomDetail[0].owner == 3 {
            owner.text = "따듯해 녹아내리는 중 친절형3"
        }else if roomDetail[0].owner == 3 {
            owner.text = "따듯해 녹아내리는 중 친절형4"
        }
    }
    func DetermineImage(value: Int) -> String {
        //var ImageName
        if value == 1{
            return "iconSmile"
        }else if value == 2{
            return "iconSoso"
        }else if value == 3{
            return "iconAngry"
        }
        return "ImageName"
    }
    func makeMapDetailModalView(){
        self.addSubview(detailCollectionView)
        firstCell.adds([tendencyImageView, addressLabel])
        secondCell.adds([buildingDetailTitle, buildingDetail])
        thirdCell.adds([soundProofTitle,soundProofImage,cleanTitle,cleanImage,sunLightTitle,sunLightImage, waterPressureTitle, waterPressureImage])
        fourthCell.adds([overallTitle, overall])
    }
}

extension MapDetailModalView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = firstCell
        if indexPath.section == 0 {
            cell = firstCell
        }else if indexPath.section == 1{
            cell = secondCell
        }else if indexPath.section == 2{
            cell = thirdCell
        }else if indexPath.section == 3{
            cell = fourthCell
        }else if indexPath.section == 4{
            cell = fifthCell
    }
    return cell
}
}
