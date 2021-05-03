//
//  ConditionViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/04/27.
//

import UIKit
import SnapKit
import Then

class ConditionViewController: UIViewController {
    let cellName = "ReusableButtonCell"
    let optionCellName = "ReusableOptionCell"
    
    //    let OptioncellWidth : CGFloat = (self.view.frame.width - 60) / 3
    //    let OptioncellHeight : CGFloat = (self.view.frame.height -300) / 3
    
    struct ListModel {
        var title = String()
        var image = String()
        //var selected = Bool //?이거 추가하가
    }
    
    struct OptionModel {
        var name = String()
    }
    
    var buildingList: [ListModel] = [ListModel(title: "원룸", image: "btnOption1"), ListModel(title: "투룸", image: "btnOption2"), ListModel(title: "오피스텔", image: "btnReady")]
    
    let transactionList: [ListModel] = [ListModel(title: "월세", image: "btnOption1"), ListModel(title: "전세", image: "btnOption2"), ListModel(title: "매매", image: "btnOption3")]
    
    var optionList : [OptionModel] = [OptionModel(name: "에어컨"),OptionModel(name: "세탁기"),OptionModel(name: "침대"),OptionModel(name: "옷장"),OptionModel(name: "책상"),OptionModel(name: "냉장고"),OptionModel(name: "인덕션"),OptionModel(name: "가스레인지"),OptionModel(name: "전자레인지")]
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let buildingTitle = UILabel().then {
        $0.text = "건물유형"
        $0.font = UIFont.systemFont(ofSize: 16)
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
    let priceShowView = UIView().then{
        $0.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        $0.setRounded(radius: 20)
    }
    
    let priceLabel = UILabel().then{
        $0.text = "0000부터"
        $0.textColor = .black
        $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    let priceSliderView = UIView()
    
    let priceSlider = RangeSlider().then{
        //        $0.layer.masksToBounds = false
        $0.minimumValue = 0
        $0.maximumValue = 10
        $0.upperValue = 0.5
        $0.lowerValue = 0
        $0.thumbImage = UIImage(named: "togglePriceMedium")
        $0.trackHighlightTintColor = .mainBlue
        $0.trackTintColor = .mainYellow
    }
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
    let nextButton = UIButton().then {
        $0.frame.size = CGSize(width: 2, height: 300) // 엥 이거 반영이 안돼
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 16.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView) // 메인뷰에
        addConstraint()
        self.initCollectionView()
    }
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20
        let width = view.bounds.width - 2 * margin
        let height: CGFloat = 30
        
        priceSlider.frame = CGRect(x: 0, y: 0,
                                   width: width, height: height)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func addConstraint()
    {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        _ = [buildingTitle,buildingCollectionView,transactionTitle,transactionCollectionView,priceTitle,priceShowView,priceSliderView,optionTitle,optionCollectionView,nextButton].map { self.contentView.addSubview($0)}
        
        
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
        
        priceShowView.addSubview(priceLabel)
        
        priceShowView.snp.makeConstraints {
            $0.top.equalTo(priceTitle.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(30)
            $0.width.equalTo(100) // ?이렇게 안하면 아예 안뜨는데 이렇게 하면 ~부터 ~까지 이렇게 할 때 안 좋은데.. sizetofix이 잇으면 좋겠다
        }
        priceLabel.snp.makeConstraints {
            $0.center.equalTo(priceShowView)
            $0.trailing.leading.top.bottom.equalTo(priceShowView).inset(3)
        }
        
        priceSliderView.snp.makeConstraints {
            $0.top.equalTo(priceShowView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.height.equalTo(80)
        }
        
        priceSliderView.addSubview(priceSlider)
        priceSlider.addTarget(self, action: #selector(SliderValuechanged), for: .valueChanged)
        
        priceSlider.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        optionTitle.snp.makeConstraints {
            $0.top.equalTo(priceSliderView.snp.bottom)
            $0.leading.trailing.equalToSuperview().offset(16)
        }
        
        optionCollectionView.snp.makeConstraints {
            $0.top.equalTo(optionTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(180)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(optionCollectionView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func setPriceLabel(price : Float) {
        priceLabel.text = "\(String(price))부터"
    }
    @objc func onTapBuildingButton(sender: UIButton) {
        print("BuildingButton was tapped.")
        sender.isSelected.toggle()
        buildingCollectionView.reloadInputViews()
    }
    
    @objc func onTapTransactionButton(sender: UIButton) {
        print("TransactionButton was tapped.")
        sender.isSelected.toggle()
        transactionCollectionView.reloadInputViews()
    }
    @objc func onTapOptionButton(sender: UIButton) {
        print("OptionButton was tapped.")
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .mainYellow
        } else
        {sender.backgroundColor = .mainBlue}
        optionCollectionView.reloadInputViews()
    }
    //    @objc func SliderValuechanged(sender: UISlider) {
    //        print("slider value changed")
    //        print(sender.value)
    //        setPriceLabel(price: sender.value)
    //    }
    @objc func SliderValuechanged(sender: RangeSlider) {
        let values = "(\(priceSlider.lowerValue) \(priceSlider.upperValue))"
        print("Range slider value changed: \(values)")
    }
}

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
        self.buildingCollectionView.register(ReusableButtonCell.self, forCellWithReuseIdentifier: self.cellName)
        
        self.transactionCollectionView.dataSource = self
        self.transactionCollectionView.delegate = self
        self.transactionCollectionView.register(ReusableButtonCell.self, forCellWithReuseIdentifier: self.cellName)
        
        self.optionCollectionView.dataSource = self
        self.optionCollectionView.delegate = self
        self.optionCollectionView.register(ReusableOptionCell.self, forCellWithReuseIdentifier: self.optionCellName)
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
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: self.cellName, for:indexPath) as? ReusableButtonCell)
            cell?.circleButton.setImage(UIImage(named: buildingList[indexPath.row].image), for: .normal)
            cell?.circleButton.setImage(UIImage(named: "\(buildingList[indexPath.row].image)Inact"), for: .selected)
            cell?.buttonTitle.text = buildingList[indexPath.row].title
            cell?.circleButton.addTarget(self, action: #selector(onTapBuildingButton), for: .touchUpInside)
            return cell!
            //
        }
        else if(collectionView == self.transactionCollectionView){
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: self.cellName, for:indexPath) as? ReusableButtonCell)
            cell?.circleButton.setImage(UIImage(named: transactionList[indexPath.row].image), for: .normal)
            cell?.circleButton.setImage(UIImage(named: "\(transactionList[indexPath.row].image)Inact"), for: .selected)
            cell?.buttonTitle.text = transactionList[indexPath.row].title
            cell?.circleButton.addTarget(self, action: #selector(onTapTransactionButton), for: .touchUpInside)
            return cell!
        }
        else if(collectionView == self.optionCollectionView){
            optioncell = (collectionView.dequeueReusableCell(withReuseIdentifier: self.optionCellName, for:indexPath) as? ReusableOptionCell)
            optioncell?.buttonTitle.text = optionList[indexPath.row].name
            optioncell?.squareButton.addTarget(self, action: #selector(onTapOptionButton), for: .touchUpInside)
            return optioncell!
        }
        return UICollectionViewCell()
    }
}
