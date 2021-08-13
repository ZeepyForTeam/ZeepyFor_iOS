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
        var title = String()
        var englishName = String()
        var image = String()
        var selected = Bool()
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
    // MARK: - Arrays
    var buildingList: [ListModel] = [ListModel(title: "원룸", englishName: "ONE", image: "btnOption1", selected: true),
                                     ListModel(title: "투룸", englishName: "TWO", image: "btnOption2", selected: true),
                                     ListModel(title: "오피스텔", englishName: "THREEORMORE", image: "btnReady", selected: true)]
    
    var transactionList: [ListModel] = [ListModel(title: "월세", englishName: "MONTHLY", image: "btnOption1", selected: true),
                                        ListModel(title: "전세", englishName : "JEONSE", image: "btnOption2", selected: true),
                                        ListModel(title: "매매", englishName : "DEAL", image: "btnReady", selected: true)]
    
    var optionList : [OptionModel] = [OptionModel(name: "에어컨",englishName: "AIRCONDITIONAL", selected: true),
                                      OptionModel(name: "세탁기",englishName: "WASHINGMACHINE", selected: true),
                                      OptionModel(name: "침대",englishName: "BED", selected: true),
                                      OptionModel(name: "옷장",englishName: "CLOSET", selected: true),
                                      OptionModel(name: "책상",englishName: "DESK", selected: true),
                                      OptionModel(name: "냉장고",englishName: "REFRIDGERATOR", selected: true),
                                      OptionModel(name: "인덕션",englishName: "INDUCTION", selected: true),
                                      OptionModel(name: "가스레인지",englishName: "BURNER", selected: true),
                                      OptionModel(name: "전자레인지",englishName: "MICROWAVE", selected: true)]
    
    var priceRange : [PriceRangeModel] = [PriceRangeModel(depositMin: 0, depositMax: 3, rentMin: 0, rentMax: 3)]
  func variableForServer() {
    var selectedBuilding = buildingList.filter{$0.selected}.map{$0.englishName}
    var selectedTransaction = transactionList.filter{!$0.selected}.map{$0.englishName}
    var selectedOptions = optionList.filter{$0.selected}.map{$0.englishName}
    
    var selectedDepositMin = depositIndexToNumber(index: priceRange[0].depositMin)
    var selectedDepositMax = depositIndexToNumber(index: priceRange[0].depositMax)
    var selectedRentMin = rentIndexToNumber(index: priceRange[0].rentMin)
    var selectedRentMax = rentIndexToNumber(index: priceRange[0].rentMax)
  }
    // MARK: - Components
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
        $0.textColor = .mainBlue
    }
    let depositPriceShowView = UIView().then {
        $0.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        $0.setRounded(radius: 20)
    }
    let depositPriceLabel = UILabel().then {
        $0.text = "보증금 무관"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let depositPriceSliderView = UIView()
    let depositPriceSlider = RangeSeekSlider().then {
        $0.minValue = 0
        $0.maxValue = 3
        $0.selectedMinValue = 0
        $0.selectedMaxValue = 3
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
        $0.text = "월세 무관"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let rentPriceSliderView = UIView()
    let rentPriceSlider = RangeSeekSlider().then {
        $0.minValue = 0
        $0.maxValue = 3
        $0.selectedMinValue = 0
        $0.selectedMaxValue = 3
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
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        addConstraints()
        self.initCollectionView()
        setupNavigation()
    }
    private func setupNavigation() {
      self.setupNavigationBar(.white)
      self.setupNavigationItem(titleText: "조건검색")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func depositIndexToNumber(index : Int?) -> Int?{
        var number : Int?
        
        if index == 0 {
            number = 0
        }else if index == 1 {
            number = 10000000
        }
        else if index == 2 {
            number = 50000000
        }
        else if index == 3 {
            number = 0
        }
        return number
    }
    
    func rentIndexToNumber(index: Int?) -> Int?{
        var number : Int?
        
        if index == 0 {
            number = 0
        }else if index == 1 {
            number = 500000
        }
        else if index == 2 {
            number = 1000000
        }
        else if index == 3 {
            number = 0
        }
        return number
    }
    
    func addConstraints()
    {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
            $0.leading.trailing.equalToSuperview().offset(16)
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
    
    func setPriceRange(firstSection: String, secondSection: String, thirdSection: String, fourthSection: String, PriceRangeLabel: UILabel, minValue: Int, maxValue: Int) {
        var minimum = ""
        var maximum = ""
        
        if minValue == 0 {
            minimum = firstSection
        }
        if minValue == 1 {
            minimum = secondSection
        }
        if minValue == 2 {
            minimum = thirdSection
        }
        
        if maxValue == 1 {
            maximum = secondSection
        }
        if maxValue == 2 {
            maximum = thirdSection
        }
        PriceRangeLabel.halfTextColorChange(fullText: "\(minimum) ~ \(maximum)", changeText: "~")
        if maxValue == 3 {
            PriceRangeLabel.halfTextColorChange(fullText: "\(minimum)부터", changeText: "부터")
        }
        
        if minValue == maxValue {
            PriceRangeLabel.text = "\(minimum)"
            if maxValue == 3 {
                PriceRangeLabel.text = "유효한 값을 선택해주세요"
            }
        }
        if minValue == 0 {
            PriceRangeLabel.halfTextColorChange(fullText: "\(maximum)까지", changeText: "까지")
            if maxValue == 3 {
                if PriceRangeLabel == depositPriceLabel {
                    PriceRangeLabel.text = "보증금 무관"
                }
                if PriceRangeLabel == rentPriceLabel {
                    PriceRangeLabel.text = "월세 무관"
                }
            }
            if maxValue == 0 {
                PriceRangeLabel.text = "유효한 값을 선택해주세요"
            }
        }
    }
    
    @objc func onTapBuildingButton(sender: UIButton) {
        sender.isSelected.toggle()
        buildingCollectionView.reloadInputViews()
        buildingList[sender.tag].selected.toggle()
    }
    
    @objc func onTapTransactionButton(sender: UIButton, indexNumber: Int) {
        sender.isSelected.toggle()
        transactionList[sender.tag].selected = !sender.isSelected
        if (transactionList[0].selected && !transactionList[1].selected) || (transactionList[0].selected && transactionList[1].selected){ // 월세만 선택하거나 둘 다 모두 선택했을 경우 // 보증금 월세 모두 보여주기
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
        if !transactionList[0].selected && transactionList[1].selected{ // 전세만 선택한 경우
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
        if !transactionList[0].selected && !transactionList[1].selected {// 둘 다 선택하지 않은 경우
            priceTitle.isHidden = true
            rentPriceShowView.isHidden = true
            rentPriceSliderView.isHidden = true
            rentTitle.isHidden = true
            depositPriceShowView.isHidden = true
            depositPriceSliderView.isHidden = true
            depositTitle.isHidden = true
            addConstraints()
            optionTitle.snp.remakeConstraints{
                $0.top.equalTo(transactionCollectionView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().offset(16)
            }
        }
        transactionCollectionView.reloadInputViews()
    }
    @objc func onTapOptionButton(sender: UIButton) {
        optionList[sender.tag].selected.toggle()
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .mainYellow
            
        } else {
            sender.backgroundColor = .mainBlue
        }
        optionCollectionView.reloadInputViews()
    }
    
    @objc func sliderDepositValuechanged(sender: RangeSeekSlider){
        setPriceRange(firstSection: depositFirstSection.text!, secondSection: depositSecondSection.text!, thirdSection: depositThirdSection.text!, fourthSection: depositFourthSection.text!, PriceRangeLabel: depositPriceLabel, minValue: Int(sender.selectedMinValue), maxValue: Int(sender.selectedMaxValue))
        depositPriceLabel.reloadInputViews()
        priceRange[0].depositMax = Int(sender.selectedMaxValue)
        priceRange[0].depositMin = Int(sender.selectedMinValue)
        
    }
    
    @objc func sliderRentValuechanged(sender: RangeSeekSlider){
        setPriceRange(firstSection: rentFirstSection.text!, secondSection: rentSecondSection.text!, thirdSection: rentThirdSection.text!, fourthSection: rentFourthSection.text!, PriceRangeLabel: rentPriceLabel, minValue: Int(sender.selectedMinValue), maxValue: Int(sender.selectedMaxValue))
        priceRange[0].rentMax = Int(sender.selectedMaxValue)
        priceRange[0].rentMin = Int(sender.selectedMinValue)
        rentPriceLabel.reloadInputViews()
    }
    
}
// MARK: - Extensions
extension ConditionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ReusableButtonCell?
        var optioncell: ReusableOptionCell?
        
        
        if(collectionView == self.buildingCollectionView) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableButtonCell.identifier, for:indexPath) as? ReusableButtonCell
            cell?.circleButton.setImage(UIImage(named: buildingList[indexPath.row].image), for: .normal)
            cell?.circleButton.setImage(UIImage(named: "\(buildingList[indexPath.row].image)Inact"), for: .selected)

            cell?.buttonTitle.text = buildingList[indexPath.row].title
            cell?.circleButton.tag = indexPath.row
            cell?.circleButton.addTarget(self, action: #selector(onTapBuildingButton), for: .touchUpInside)
            return cell!
            
        }
        else if(collectionView == self.transactionCollectionView) {
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: ReusableButtonCell.identifier, for:indexPath) as? ReusableButtonCell)
            cell?.circleButton.setImage(UIImage(named: transactionList[indexPath.row].image), for: .normal)
            cell?.circleButton.tag = indexPath.row
            cell?.circleButton.setImage(UIImage(named: "\(transactionList[indexPath.row].image)Inact"), for: .selected)
            cell?.buttonTitle.text = transactionList[indexPath.row].title
            cell?.circleButton.addTarget(self, action: #selector(onTapTransactionButton), for: .touchUpInside)
            
            return cell!
        }
        else if(collectionView == self.optionCollectionView) {
            optioncell = (collectionView.dequeueReusableCell(withReuseIdentifier: ReusableOptionCell.identifier, for:indexPath) as? ReusableOptionCell)
            optioncell?.buttonTitle.text = optionList[indexPath.row].name
            optioncell?.squareButton.addTarget(self, action: #selector(onTapOptionButton), for: .touchUpInside)
            optioncell?.squareButton.tag = indexPath.row
            return optioncell!
        }
        return UICollectionViewCell()
    }
}
