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

class ConditionViewController: UIViewController {
    // MARK: - Structs
    struct ListModel {
        var title = String()
        var image = String()
        var selected = Bool()
    }
    
    struct OptionModel {
        var name = String()
        var selected = Bool()
    }
    // MARK: - Arrays
    var buildingList: [ListModel] = [ListModel(title: "원룸", image: "btnOption1", selected : true), ListModel(title: "투룸", image: "btnOption2", selected : true), ListModel(title: "오피스텔", image: "btnReady", selected : true)]
    
    var transactionList: [ListModel] = [ListModel(title: "월세", image: "btnOption1"), ListModel(title: "전세", image: "btnOption2"), ListModel(title: "매매", image: "btnOption3")]
    
    var optionList : [OptionModel] = [OptionModel(name: "에어컨", selected : true),OptionModel(name: "세탁기", selected : true),OptionModel(name: "침대", selected : true),OptionModel(name: "옷장", selected : true),OptionModel(name: "책상", selected : true),OptionModel(name: "냉장고", selected : true),OptionModel(name: "인덕션", selected : true),OptionModel(name: "가스레인지", selected : true),OptionModel(name: "전자레인지", selected : true)]
    
    // MARK: - Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let buildingTitle = UILabel().then {
        $0.text = "건물유형"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let buildingCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.isPagingEnabled = true
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let size:CGSize = UIScreen.main.bounds.size
        
        layout.itemSize = CGSize(width: 82, height: 125)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .white
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        return collectionView
    }()
    
    let transactionTitle = UILabel().then {
        $0.text = "거래종류"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let transactionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.isPagingEnabled = false
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let size:CGSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: 82, height: 125)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    let priceTitle = UILabel().then {
        $0.text = "가격"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let depositTitle = UILabel().then{
        $0.text = "보증금"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
        $0.textColor = .mainBlue
    }
    let depositPriceShowView = UIView().then{
        $0.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        $0.setRounded(radius: 20)
    }
    let depositPriceLabel = UILabel().then{
        $0.text = "보증금 무관"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    
    let depositPriceSliderView = UIView()
    
    let depositPriceSlider = RangeSeekSlider().then{
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
    
    let depositFirstSection = UILabel().then{
        $0.text = "최소"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }

    let depositSecondSection = UILabel().then{
        $0.text = "1천만"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let depositThirdSection = UILabel().then{
        $0.text = "5천만"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let depositFourthSection = UILabel().then{
        $0.text = "최대"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .blackText
    }
    
    let depositPriceRange = UIView()
    
    let rentTitle = UILabel().then{
        $0.text = "월세"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 12.0)
        $0.textColor = .mainBlue
    }
    
    let rentPriceShowView = UIView().then{
        $0.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        $0.setRounded(radius: 20)
    }
    let rentPriceLabel = UILabel().then{
        $0.text = "월세 무관"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let rentPriceSliderView = UIView()
    let rentPriceSlider = RangeSeekSlider().then{
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
    let rentFirstSection = UILabel().then{
        $0.text = "최소"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
    }
    let rentSecondSection = UILabel().then{
        $0.text = "50만원"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let rentThirdSection = UILabel().then{
        $0.text = "100만원"
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
        $0.textColor = .grayText
    }
    let rentFourthSection = UILabel().then{
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
    let seperateLine = UIView().then{
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
    }
//    override func viewDidLayoutSubviews() {
//        let margin: CGFloat = 20
//        let width = view.bounds.width - 2 * margin
//        let height: CGFloat = 30
//
//        depositPriceSlider.frame = CGRect(x: 0, y: 0,
//                                   width: width, height: height)
//    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints()
    {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        _ = [buildingTitle,buildingCollectionView,transactionTitle,transactionCollectionView,priceTitle,depositTitle,depositPriceShowView,depositPriceSliderView,depositPriceRange, rentTitle,rentPriceShowView,rentPriceSliderView,rentPriceRange,optionTitle,optionCollectionView,seperateLine,nextButton].map { self.contentView.addSubview($0)}
        
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
        depositPriceRange.snp.makeConstraints{
            $0.top.equalTo(depositPriceSliderView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }
        let screenWidth = UIScreen.main.bounds.size.width

        depositPriceRange.adds([depositFirstSection,depositSecondSection,depositThirdSection,depositFourthSection])
        
        depositFirstSection.snp.makeConstraints{
            $0.centerY.leading.equalToSuperview()
        }
        depositSecondSection.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(depositFirstSection.snp.trailing).offset((screenWidth-40)/4)
        }
        depositThirdSection.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(depositSecondSection.snp.trailing).offset((screenWidth-40)/4)
        }
        depositFourthSection.snp.makeConstraints{
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
        rentPriceSliderView.snp.makeConstraints{
            $0.top.equalTo(rentPriceShowView.snp.bottom)
            $0.centerX.equalTo(depositPriceSliderView)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }

        rentPriceSliderView.addSubview(rentPriceSlider)

        rentPriceSlider.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        rentPriceRange.snp.makeConstraints{
            $0.top.equalTo(rentPriceSliderView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }

        rentPriceRange.adds([rentFirstSection,rentSecondSection,rentThirdSection,rentFourthSection])
        
        rentFirstSection.snp.makeConstraints{
            $0.centerY.leading.equalToSuperview()
        }
        rentSecondSection.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rentFirstSection.snp.trailing).offset((screenWidth-40)/4)
        }
        rentThirdSection.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rentSecondSection.snp.trailing).offset((screenWidth-40)/4)
        }
        rentFourthSection.snp.makeConstraints{
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
        
        seperateLine.snp.makeConstraints{
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
    
    func setDepositPriceLabel(minValue: Int, maxValue: Int) {
        var minimum = ""
        var maximum = ""
        if minValue == 0 {
           minimum = "0원"
        }else if minValue == 1 {
            minimum = "1천만"
        }else if minValue == 2 {
            minimum = "5천만"
        }
        
        if maxValue == 1 {
            maximum = "1천만"
        }else if maxValue == 2 {
            maximum = "5천만"
        }
        depositPriceLabel.halfTextColorChange(fullText: "\(minimum)부터 \(maximum)까지", changeText: ["부터","까지"])
        if maxValue == 3 {
            depositPriceLabel.text = "\(minimum)부터"
        }
        if minValue == maxValue {
            depositPriceLabel.text = "\(minimum)"
            if maxValue == 3 {
                depositPriceLabel.text = "유효한 값을 선택해주세요"
            }
        }
        if minValue == 0 {
            depositPriceLabel.text = "\(maximum)까지"
            if maxValue == 3 {
                depositPriceLabel.text = "보증금 무관"
            }
            if maxValue == 0 {
                depositPriceLabel.text = "유효한 값을 선택해주세요"
            }
        }
    }
    
    func setRentPriceLabel(minValue: Int, maxValue: Int) {
        var minimum = ""
        var maximum = ""
        if minValue == 0 {
           minimum = "0원"
        }else if minValue == 1 {
            minimum = "50만"
        }else if minValue == 2 {
            minimum = "100만"
        }
        
        if maxValue == 1 {
            maximum = "50만"
        }else if maxValue == 2 {
            maximum = "100만"
        }
        rentPriceLabel.text = "\(minimum)부터 \(maximum)까지"
        
        if maxValue == 3 {
            rentPriceLabel.text = "\(minimum)부터"
            if minValue == 3 {
                rentPriceLabel.text = "유효한 값을 선택해주세요"
            }
        }
        if minValue == 0 {
            rentPriceLabel.text = "\(maximum)까지"
            if maxValue == 3 {
                rentPriceLabel.text = "월세 무관"
            }
            if maxValue == 0 {
                rentPriceLabel.text = "유효한 값을 선택해주세요"
            }
        }
        if minValue == maxValue {
            rentPriceLabel.text = "\(minimum)"
            if maxValue == 3 {
                rentPriceLabel.text = "유효한 값을 선택해주세요"
            }
        }
    }
    
    @objc func onTapBuildingButton(sender: UIButton) {
        print("BuildingButton was tapped.")
        sender.isSelected.toggle()
        buildingCollectionView.reloadInputViews()
        
        print(buildingList)
    }
    
    @objc func onTapTransactionButton(sender: UIButton, indexNumber: Int) {
        print("TransactionButton was tapped.")
        sender.isSelected.toggle()
        transactionList[sender.tag].selected = sender.isSelected
        if transactionList[0].selected {
            rentPriceShowView.isHidden = true
            rentPriceSliderView.isHidden = true
            rentTitle.isHidden = true
            optionTitle.snp.remakeConstraints{
                $0.top.equalTo(depositPriceSliderView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().offset(16)
            }
        }else {
            rentPriceShowView.isHidden = false
            rentPriceSliderView.isHidden = false
            rentTitle.isHidden = false
            addConstraints()
            optionTitle.snp.remakeConstraints{
                $0.top.equalTo(rentPriceSliderView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().offset(16)
            }
        transactionCollectionView.reloadInputViews()
    }
    }
    
    @objc func onTapOptionButton(sender: UIButton) {
        print("OptionButton was tapped.")
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .mainYellow
        } else {
            sender.backgroundColor = .mainBlue
        }
        optionCollectionView.reloadInputViews()
    }

    @objc func sliderDepositValuechanged(sender: RangeSeekSlider) {
        
        setDepositPriceLabel(minValue: Int(sender.selectedMinValue), maxValue: Int(sender.selectedMaxValue))
        
        depositPriceLabel.reloadInputViews()
    }
    @objc func sliderRentValuechanged(sender: RangeSeekSlider) {
        
        setRentPriceLabel(minValue: Int(sender.selectedMinValue), maxValue: Int(sender.selectedMaxValue))
        rentPriceLabel.reloadInputViews()
    }
    
}
// MARK: - Extensions
extension ConditionViewController: UICollectionViewDelegateFlowLayout{
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
        
        if(collectionView == self.buildingCollectionView){
            count = self.buildingList.count
        }
        else if(collectionView == self.transactionCollectionView){
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

        
        if(collectionView == self.buildingCollectionView){
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableButtonCell.identifier, for:indexPath) as? ReusableButtonCell
            cell?.circleButton.setImage(UIImage(named: buildingList[indexPath.row].image), for: .normal)
            cell?.circleButton.setImage(UIImage(named: "\(buildingList[indexPath.row].image)Inact"), for: .selected)
            cell?.buttonTitle.text = buildingList[indexPath.row].title
            cell?.circleButton.addTarget(self, action: #selector(onTapBuildingButton), for: .touchUpInside)
            return cell!

        }
        else if(collectionView == self.transactionCollectionView){
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: ReusableButtonCell.identifier, for:indexPath) as? ReusableButtonCell)
            cell?.circleButton.setImage(UIImage(named: transactionList[indexPath.row].image), for: .normal)
            cell?.circleButton.tag = indexPath.row
            cell?.circleButton.setImage(UIImage(named: "\(transactionList[indexPath.row].image)Inact"), for: .selected)
            cell?.buttonTitle.text = transactionList[indexPath.row].title
            cell?.circleButton.addTarget(self, action: #selector(onTapTransactionButton), for: .touchUpInside)
            
            return cell!
        }
        else if(collectionView == self.optionCollectionView){
            optioncell = (collectionView.dequeueReusableCell(withReuseIdentifier: ReusableOptionCell.identifier, for:indexPath) as? ReusableOptionCell)
            optioncell?.buttonTitle.text = optionList[indexPath.row].name
            optioncell?.squareButton.addTarget(self, action: #selector(onTapOptionButton), for: .touchUpInside)
            if optioncell!.squareButton.isTouchInside {
                optionList[indexPath.row].selected.toggle()
            }
            return optioncell!
        }
        return UICollectionViewCell()
    }
}
