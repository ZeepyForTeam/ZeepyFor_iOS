//
//  ConditionViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/04/27.
//

import UIKit
import SnapKit
import Then
import RangeSeekSlider
import Moya

class ConditionViewController: UIViewController {
    // MARK: - Structs
    struct ListModel {
        var title : String
        var englishName : String?
        var image : String
        var selected : Bool
    }
    
    struct OptionModel {
        var name = String()
        var englishName = String()
        var selected = Bool()
    }
    struct PriceRangeModel {
        var depositMin: Int?
        var depositMax: Int?
        var rentMin: Int?
        var rentMax: Int?
    }
    
    struct MoneyModel {
        var price : Int?
        var name : String?
    }
    
    // MARK: - Arrays
    var buildingList: [ListModel] = [ListModel(title: "전체", englishName: nil, image: "btnOption1", selected: true),
                                     ListModel(title: "연립다세대", englishName: "ROWHOUSE", image: "btnOption2", selected: false),
                                     ListModel(title: "오피스텔", englishName: "OFFICETEL", image: "btnOption3", selected: false)]
    
    var transactionList: [ListModel] = [ListModel(title: "전체", englishName : nil , image: "btnOption1", selected: true),
                                        ListModel(title: "월세", englishName: "MONTHLY", image: "btnOption2", selected: false),
                                        ListModel(title: "전세", englishName : "JEONSE", image: "btnOption3", selected: false),
                                        ListModel(title: "매매", englishName : "DEAL", image: "btnReady", selected: false),
    ]
    
    var optionList : [OptionModel] = [OptionModel(name: "에어컨",englishName: "AIRCONDITIONAL", selected: false),
                                      OptionModel(name: "세탁기",englishName: "WASHINGMACHINE", selected: false),
                                      OptionModel(name: "침대",englishName: "BED", selected: false),
                                      OptionModel(name: "옷장",englishName: "CLOSET", selected: false),
                                      OptionModel(name: "책상",englishName: "DESK", selected: false),
                                      OptionModel(name: "냉장고",englishName: "REFRIDGERATOR", selected: false),
                                      OptionModel(name: "인덕션",englishName: "INDUCTION", selected: false),
                                      OptionModel(name: "가스레인지",englishName: "BURNER", selected: false),
                                      OptionModel(name: "전자레인지",englishName: "MICROWAVE", selected: false)]
    
    var priceRange : [PriceRangeModel] = [PriceRangeModel(depositMin: 0, depositMax: 6, rentMin: 0, rentMax: 6)]
    
    var depositRange : [MoneyModel] = [MoneyModel(price: nil, name: nil),
                                       MoneyModel(price: 5000000, name: "5백만"),
                                       MoneyModel(price: 10000000, name: "1천만"),
                                       MoneyModel(price: 25000000, name: "2천5백만"),
                                       MoneyModel(price: 50000000, name: "5천만"),
                                       MoneyModel(price: 100000000, name: "1억"),
                                       MoneyModel(price: nil, name: nil)]
    
    var rentRange : [MoneyModel] = [MoneyModel(price: nil, name: nil),
                                    MoneyModel(price: 250000, name: "25만"),
                                    MoneyModel(price: 500000, name: "50만"),
                                    MoneyModel(price: 750000, name: "75만"),
                                    MoneyModel(price: 1000000, name: "100만"),
                                    MoneyModel(price: 1250000, name: "125만"),
                                    MoneyModel(price: nil, name: nil)]
    func variableForServer() -> BuildingRequest {
            
        print("this is variableForServer")
        
        var selectedDepositMin : Int?
        var selectedDepositMax : Int?
        var selectedRentMin : Int?
        var selectedRentMax : Int?
        
        var selectedBuilding : String?
        var selectedTransaction : String?
        var selectedOptions : [String]?
        
        selectedBuilding = buildingList.filter{$0.selected}.map{$0.englishName ?? ""}.joined()
        selectedTransaction = transactionList.filter{!$0.selected}.map{$0.englishName ?? ""}.joined()
        selectedOptions = optionList.filter{$0.selected}.map{$0.englishName}
        
        selectedDepositMin = priceRange[0].depositMin
        selectedDepositMax = priceRange[0].depositMax
        selectedRentMin = priceRange[0].rentMin
        selectedRentMax = priceRange[0].rentMax
        
        print("eqRoomCount" , selectedBuilding)
        print("neType", selectedTransaction)
        print("in Furniture", selectedOptions)
        print("le Deposit", selectedDepositMax)
        print("ge Deposit", selectedDepositMin)
        print("le Monthly", selectedRentMax)
        print("ge Monthly", selectedRentMin)
        
        var buildingRequest = BuildingRequest(eqRoomCount: selectedBuilding, geDeposit: selectedDepositMin, geMonthly: selectedRentMin, inFurnitures: selectedOptions, leDeposit: selectedDepositMax, leMonthly: selectedRentMax, neType: selectedTransaction)
        return buildingRequest
    }
    // MARK: - Variable
//    var selectedNumber = 100

    var dealSelectedNumber = 0
    var buildingSelectedNumber = 0
    var resultClosure: ((BuildingRequest) -> ())?
    
    // MARK: - Components
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "조건 검색")
  }
    let scrollView = UIScrollView()
    let contentView = UIView()
    let buildingTitle = UILabel().then {
        $0.text = "건물유형"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let buildingCollectionView: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let size:CGSize = UIScreen.main.bounds.size
        
        layout.itemSize = CGSize(width: 82, height: 125)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    let transactionTitle = UILabel().then {
        $0.text = "거래종류"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let transactionCollectionView: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let size:CGSize = UIScreen.main.bounds.size
        
        layout.itemSize = CGSize(width: 82, height: 125)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    let priceTitle = UILabel().then {
        $0.text = "가격"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let depositTitle = UILabel().then {
        $0.text = "보증금"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
    }
    let depositPriceShowView = UIView().then {
        $0.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        $0.setRounded(radius: 20)
    }
    let depositPriceLabel = UILabel().then {
        $0.text = "가격상관없이"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let depositPriceSliderView = UIView()
    let depositPriceSlider = RangeSeekSlider().then {
        $0.minValue = 0
        $0.maxValue = 6
        $0.selectedMinValue = 0
        $0.selectedMaxValue = 6
        $0.lineHeight = 10
        $0.colorBetweenHandles = .mainBlue
        $0.tintColor = .mainYellow
        $0.hideLabels = true
        $0.handleImage = UIImage(named:"togglePriceMedium")
        $0.enableStep = true
        $0.step = 1
        $0.setupStyle()
        $0.addTarget(self, action: #selector(sliderDepositValuechanged), for: .touchUpInside)
    }
    
    let depositFirstSection = UILabel().then {
        $0.text = "최소"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }
    
    let depositSecondSection = UILabel().then {
        $0.text = "1천만"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let depositThirdSection = UILabel().then {
        $0.text = "5천만"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let depositFourthSection = UILabel().then {
        $0.text = "최대"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .blackText
    }
    let depositPriceRange = UIView()
    let rentTitle = UILabel().then {
        $0.text = "월세"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
        $0.textColor = .mainBlue
    }
    
    let rentPriceShowView = UIView().then {
        $0.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        $0.setRounded(radius: 20)
    }
    let rentPriceLabel = UILabel().then {
        $0.text = "가격상관없이"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let rentPriceSliderView = UIView()
    let rentPriceSlider = RangeSeekSlider().then {
        $0.minValue = 0
        $0.maxValue = 6
        $0.selectedMinValue = 0
        $0.selectedMaxValue = 6
        $0.lineHeight = 10
        $0.colorBetweenHandles = .mainBlue
        $0.tintColor = .mainYellow
        $0.hideLabels = true
        $0.handleImage = UIImage(named:"togglePriceMedium")
        $0.enableStep = true
        $0.step = 1
        $0.setupStyle()
        $0.addTarget(self, action: #selector(sliderRentValuechanged), for: .touchUpInside)
    }
    let rentFirstSection = UILabel().then {
        $0.text = "최소"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }
    let rentSecondSection = UILabel().then {
        $0.text = "50만원"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let rentThirdSection = UILabel().then {
        $0.text = "100만원"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let rentFourthSection = UILabel().then {
        $0.text = "최대"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .blackText
    }
    let rentPriceRange = UIView()
    let optionTitle = UILabel().then {
        $0.text = "가구옵션"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let optionCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.isPagingEnabled = true
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let size:CGSize = UIScreen.main.bounds.size
        
        layout.itemSize = CGSize(width: 110, height: 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0//엥?
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .white
        collectionView.setCollectionViewLayout(layout, animated: false)
        return collectionView
    }()
    let seperateLine = UIView().then {
        $0.backgroundColor = .gray244
    }
    let nextButton = UIButton().then {
        $0.frame.size = CGSize(width: 2, height: 300) // 엥 이거 반영이 안돼
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        addConstraints()
        self.initCollectionView()
        setupNavigation()
      nextButton.addAction(for: .touchUpInside, closure: {[weak self] _ in
        let model = self?.variableForServer() ?? .init()
        if let closure = self?.resultClosure {
          closure(model)
        }
        self?.popViewController()
      })
    }
    private func setupNavigation() {
        self.setupNavigationBar(.white)
        self.setupNavigationItem(titleText: "조건검색")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints()
    {
      self.view.add(naviView)
      naviView.snp.makeConstraints{
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
          $0.top.equalTo(naviView.snp.bottom)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        _ = [buildingTitle, buildingCollectionView, transactionTitle, transactionCollectionView, priceTitle, depositTitle, depositPriceShowView, depositPriceSliderView, depositPriceRange,  rentTitle, rentPriceShowView, rentPriceSliderView, rentPriceRange, optionTitle, optionCollectionView, seperateLine, nextButton].map { self.contentView.addSubview($0)}
        
        buildingTitle.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().offset(16)
        }
        
        buildingCollectionView.snp.makeConstraints {
            $0.top.equalTo(buildingTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.height.equalTo(150)
        }
        
        transactionTitle.snp.makeConstraints {
            $0.top.equalTo(buildingCollectionView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().offset(16)
        }
        
        transactionCollectionView.snp.makeConstraints {
            $0.top.equalTo(transactionTitle.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(150)
        }
        
        priceTitle.snp.makeConstraints {
            $0.top.equalTo(transactionCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().offset(16)
        }
        
        depositTitle.snp.makeConstraints {
            $0.top.equalTo(priceTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().offset(16)
        }
        
        depositPriceShowView.snp.makeConstraints {
            $0.top.equalTo(depositTitle.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(30)
        }
        
        depositPriceShowView.addSubview(depositPriceLabel)
        
        depositPriceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        depositPriceSliderView.snp.makeConstraints {
            $0.top.equalTo(depositPriceShowView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        
        depositPriceSliderView.addSubview(depositPriceSlider)
        
        depositPriceSlider.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        depositPriceRange.snp.makeConstraints {
            $0.top.equalTo(depositPriceSliderView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        depositPriceRange.adds([depositFirstSection,depositSecondSection,depositThirdSection,depositFourthSection])
        
        depositFirstSection.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        depositSecondSection.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(depositFirstSection.snp.trailing).offset((screenWidth-40)/4)
        }
        depositThirdSection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(depositSecondSection.snp.trailing).offset((screenWidth-40)/4)
        }
        depositFourthSection.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            
        }
        
        rentTitle.snp.makeConstraints {
            $0.top.equalTo(depositPriceRange.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(16)
        }
        rentPriceShowView.snp.makeConstraints {
            $0.top.equalTo(rentTitle.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(20)
        }
        rentPriceShowView.addSubview(rentPriceLabel)
        
        rentPriceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        rentPriceSliderView.snp.makeConstraints {
            $0.top.equalTo(rentPriceShowView.snp.bottom)
            $0.centerX.equalTo(depositPriceSliderView)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        
        rentPriceSliderView.addSubview(rentPriceSlider)
        
        rentPriceSlider.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        rentPriceRange.snp.makeConstraints {
            $0.top.equalTo(rentPriceSliderView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }
        
        rentPriceRange.adds([rentFirstSection,rentSecondSection,rentThirdSection,rentFourthSection])
        
        rentFirstSection.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        rentSecondSection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rentFirstSection.snp.trailing).offset((screenWidth-40)/4)
        }
        rentThirdSection.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rentSecondSection.snp.trailing).offset((screenWidth-40)/4)
        }
        rentFourthSection.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        optionTitle.snp.makeConstraints {
            $0.top.equalTo(rentPriceRange.snp.bottom)
            $0.leading.trailing.equalToSuperview().offset(16)
        }
        
        optionCollectionView.snp.makeConstraints {
            $0.top.equalTo(optionTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(180)
        }
        
        seperateLine.snp.makeConstraints {
            $0.top.equalTo(optionCollectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(seperateLine.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func setDepositRange(PriceRangeLabel: UILabel, minValue: Int, maxValue: Int) {
        var minimum = ""
        var maximum = ""
        
        if minValue > 0 && minValue < 6 {
            minimum = depositRange[minValue].name!
        }
        
        if maxValue > 0 && maxValue < 6{
            maximum = depositRange[maxValue].name!
        }
        PriceRangeLabel.halfTextColorChange(fullText: "\(minimum) ~ \(maximum)", changeText: "~")
        if maxValue == 6 {
            PriceRangeLabel.halfTextColorChange(fullText: "\(minimum)부터", changeText: "부터")
        }
        
        if minValue == maxValue {
            PriceRangeLabel.text = "\(minimum)"
            if maxValue == 6 {
                PriceRangeLabel.text = "유효한 값을 선택해주세요"
            }
        }
        if minValue == 0 {
            PriceRangeLabel.halfTextColorChange(fullText: "\(maximum)까지", changeText: "까지")
            if maxValue == 6 {
                PriceRangeLabel.text = "가격상관없이"
                PriceRangeLabel.textColor = .black
            }
            if maxValue == 0 {
                PriceRangeLabel.text = "유효한 값을 선택해주세요"
            }
        }
        priceRange[0].depositMax = depositRange[maxValue].price
        priceRange[0].depositMin = depositRange[minValue].price
        
    }
    
    func setRentRange(PriceRangeLabel: UILabel, minValue: Int, maxValue: Int) {
        var minimum = ""
        var maximum = ""
        if minValue > 0 && minValue < 6 {
            minimum = rentRange[minValue].name!
        }
        if maxValue > 0 && maxValue < 6{
            maximum = rentRange[maxValue].name!
        }
        PriceRangeLabel.halfTextColorChange(fullText: "\(minimum) ~ \(maximum)", changeText: "~")
        if maxValue == 6 {
            PriceRangeLabel.halfTextColorChange(fullText: "\(minimum)부터", changeText: "부터")
        }
        
        if minValue == maxValue {
            PriceRangeLabel.text = "\(minimum)"
            if maxValue == 6 {
                PriceRangeLabel.text = "유효한 값을 선택해주세요"
            }
        }
        if minValue == 0 {
            PriceRangeLabel.halfTextColorChange(fullText: "\(maximum)까지", changeText: "까지")
            if maxValue == 6 {
                PriceRangeLabel.text = "가격상관없이"
                PriceRangeLabel.textColor = .black
            }
            if maxValue == 0 {
                PriceRangeLabel.text = "유효한 값을 선택해주세요"
            }
        }
        priceRange[0].rentMax = rentRange[maxValue].price
        priceRange[0].rentMin = rentRange[minValue].price
    }
    func activateBuildingButton(index: Int){
        
    }

//    @objc func onTapBuildingButton(sender: UIButton) {
//
//        buildingList[sender.tag].selected.toggle()
//
//        if sender.tag == 0 {
//            buildingList[1].selected = false
//            buildingList[2].selected = false
//        }
//
//        if sender.tag == 1 {
//            buildingList[0].selected = false
//            buildingList[2].selected = false
//        }
//
//        if sender.tag == 2 {
//            buildingList[1].selected = false
//            buildingList[0].selected = false
//        }
////        sender.isSelected.toggle()
//
//        buildingCollectionView.reloadInputViews()
//        buildingCollectionView.reloadData()
////        buildingList[sender.tag].selected.toggle()
//    }
    func determineSlider(index: Int){
        if index == 0 {// 전체를 선택한 경우
            priceTitle.isHidden = true
            rentPriceShowView.isHidden = true
            rentPriceSliderView.isHidden = true
            rentPriceRange.isHidden = true
            rentTitle.isHidden = true
            depositPriceShowView.isHidden = true
            depositPriceSliderView.isHidden = true
            rentPriceShowView.isHidden = true
            depositTitle.isHidden = true
            addConstraints()
            optionTitle.snp.remakeConstraints{
                $0.top.equalTo(transactionCollectionView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().offset(16)
            }
        }
        else if index == 1 { // 월세만 선택했을 경우 // 보증금 월세 모두 보여주기
            rentPriceShowView.isHidden = false
            rentPriceSliderView.isHidden = false
            rentTitle.isHidden = false
            depositPriceShowView.isHidden = false
            depositPriceSliderView.isHidden = false
            depositTitle.isHidden = false
            addConstraints()
            optionTitle.snp.remakeConstraints{
                $0.top.equalTo(rentPriceRange.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().offset(16)
            }
        }
        else if index == 2{ // 전세만 선택한 경우
            rentPriceShowView.isHidden = true
            rentPriceSliderView.isHidden = true
            rentTitle.isHidden = true
            depositPriceShowView.isHidden = false
            depositPriceSliderView.isHidden = false
            depositTitle.isHidden = false
            addConstraints()
            optionTitle.snp.remakeConstraints{
                $0.top.equalTo(depositPriceRange.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().offset(16)
            }
        }

    }
//    @objc func onTapTransactionButton(sender: UIButton, indexNumber: Int) {
//
////        sender.isSelected.toggle()
//        transactionList[sender.tag].selected.toggle()
//
//        if sender.tag == 0 {
//            transactionList[1].selected = false
//            transactionList[2].selected = false
//            transactionList[3].selected = false
//        }
//
//        if sender.tag == 1 {
//            transactionList[0].selected = false
//            transactionList[2].selected = false
//            transactionList[3].selected = false
//        }
//
//        if sender.tag == 2 {
//            transactionList[1].selected = false
//            transactionList[0].selected = false
//            transactionList[3].selected = false
//
//        }
//
//        if sender.tag == 3 {
//            transactionList[1].selected = false
//            transactionList[2].selected = false
//            transactionList[0].selected = false
//        }
//
//        determineSlider(index: indexNumber)
//        transactionCollectionView.reloadInputViews()
//        transactionCollectionView.reloadData()
//    }
    
    @objc func onTapOptionButton(sender: UIButton) {
        optionList[sender.tag].selected.toggle()
        optionCollectionView.reloadData()
    }
    
    @objc func sliderDepositValuechanged(sender: RangeSeekSlider){
        setDepositRange(PriceRangeLabel: depositPriceLabel, minValue: Int(sender.selectedMinValue), maxValue: Int(sender.selectedMaxValue))
        depositPriceLabel.reloadInputViews()
//        priceRange[0].depositMax = Int(sender.selectedMaxValue)
//        priceRange[0].depositMin = Int(sender.selectedMinValue)
    }
    
    @objc func sliderRentValuechanged(sender: RangeSeekSlider){
        setRentRange(PriceRangeLabel: rentPriceLabel, minValue: Int(sender.selectedMinValue), maxValue: Int(sender.selectedMaxValue))
//        priceRange[0].rentMax = Int(sender.selectedMaxValue)
//        priceRange[0].rentMin = Int(sender.selectedMinValue)
        rentPriceLabel.reloadInputViews()
    }
    
}
// MARK: - Extensions
extension ConditionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

extension ConditionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func initCollectionView() {
        self.buildingCollectionView.dataSource = self
        self.buildingCollectionView.delegate = self
        self.buildingCollectionView.register(ReusableButtonCell.self, forCellWithReuseIdentifier: ReusableButtonCell.identifier)
        
        self.transactionCollectionView.dataSource = self
        self.transactionCollectionView.delegate = self
        self.transactionCollectionView.register(ReusableButtonCell.self, forCellWithReuseIdentifier: ReusableButtonCell.identifier)
        
        self.optionCollectionView.dataSource = self
        self.optionCollectionView.delegate = self
        self.optionCollectionView.register(ReusableOptionCell.self, forCellWithReuseIdentifier: ReusableOptionCell.identifier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if(collectionView == self.buildingCollectionView) {
            count = self.buildingList.count
        }
        else if(collectionView == self.transactionCollectionView) {
            count = self.transactionList.count
        }
        else if(collectionView == self.optionCollectionView)
        {
            count = self.optionList.count
        }
        return count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == buildingCollectionView{
            buildingSelectedNumber = indexPath.item
            collectionView.reloadData()
            print(#function)
        }
        else if collectionView == transactionCollectionView{
            if indexPath.item != 3{
            dealSelectedNumber = indexPath.item
            determineSlider(index: indexPath.item)
            collectionView.reloadData()
            print(#function)
            }
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ReusableButtonCell?
        var optioncell: ReusableOptionCell?
        
        if (collectionView == self.buildingCollectionView) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableButtonCell.identifier, for:indexPath) as? ReusableButtonCell
            if indexPath.row == 0 {
                cell?.circleButton.setImage(UIImage(named: buildingList[indexPath.row].image), for: .normal)
            }
            if buildingSelectedNumber == indexPath.item{
                cell?.circleButton.setImage(UIImage(named: buildingList[indexPath.row].image), for: .normal)
                buildingList[buildingSelectedNumber].selected.toggle()
            }
            else {
                cell?.circleButton.setImage(UIImage(named: "\(buildingList[indexPath.row].image)Inact"), for: .normal)
            }
            cell?.buttonTitle.text = buildingList[indexPath.row].title
            cell?.circleButton.tag = indexPath.row
            return cell!
        }
        
        else if (collectionView == self.transactionCollectionView) {
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: ReusableButtonCell.identifier, for:indexPath) as? ReusableButtonCell)
        
            transactionList[indexPath.row].selected.toggle()
            if dealSelectedNumber == indexPath.item {
                cell?.circleButton.setImage(UIImage(named: transactionList[indexPath.row].image), for: .normal)
                transactionList[dealSelectedNumber].selected.toggle()
            }
            else {
                cell?.circleButton.setImage(UIImage(named: "\(transactionList[indexPath.row].image)Inact"), for: .normal)
            }
            cell?.circleButton.tag = indexPath.row
            cell?.buttonTitle.text = transactionList[indexPath.row].title
            
            return cell!
        }
        
        else if(collectionView == self.optionCollectionView) {
            optioncell = (collectionView.dequeueReusableCell(withReuseIdentifier: ReusableOptionCell.identifier, for:indexPath) as? ReusableOptionCell)
            
            if optionList[indexPath.row].selected {
                optioncell?.squareButton.backgroundColor = .mainBlue
                optioncell?.buttonTitle.textColor = .white
            }
            else {
                optioncell?.squareButton.backgroundColor = .whiteGray
                optioncell?.buttonTitle.textColor = .black
            }
            optioncell?.buttonTitle.text = optionList[indexPath.row].name
            optioncell?.squareButton.addTarget(self, action: #selector(onTapOptionButton), for: .touchUpInside)
            optioncell?.squareButton.tag = indexPath.row
            return optioncell!
        }
        return UICollectionViewCell()
    }
    
}
