//
//  PostDetailViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/23.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift


typealias DataSource = RxTableViewSectionedReloadDataSource
typealias CommentSectionType = AnimatableSectionModel<CommentSectionModel, CommentSectionModel>
class PostDetailViewControlelr : BaseViewController {
  private let disposeBag = DisposeBag()
  private let viewModel = PostDetailViewModel()
  private let naviView = UIView().then{
    $0.backgroundColor = .white
    $0.addUnderBar()
  }
  private let backBtn = UIButton().then {
    $0.setImage(UIImage(named:"btnBack"), for: .normal)
    $0.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
  }
  private let naviTitle = UILabel().then{
    $0.text = "커뮤니티"
    $0.font = .nanumRoundExtraBold(fontSize: 20)
  }
  private let likeBtn = UIButton().then{
    $0.setImage(UIImage(named:"btnLikeUnselected"), for: .normal)
    $0.setImage(UIImage(named:"btnLike"), for: .selected)
  }
  private let commentField = UIView().then {
    $0.backgroundColor = .white
  }
  private let commentCheckBox = UIButton().then {
    $0.setImage(UIImage(named: "checkBoxOutlineBlank"), for: .normal)
    $0.setImage(UIImage(named: "checkBoxSelected"), for: .selected)
    $0.isSelected = false
  }
  private let commentNoti = UILabel().then {
    $0.setupLabel(text: "쉿! 비밀 이야기에요.", color: .blackText, font: .nanumRoundBold(fontSize: 12))
  }
  private let commentTextField = UITextField().then {
    $0.setRounded(radius: 18)
    $0.backgroundColor = .gray249
    $0.addLeftPadding(as: 20)
  }
  private let addCommentButton = UIButton().then {
    $0.setTitle("작성", for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 14)
    $0.setTitleColor( .communityGreen, for: .normal)
  }
  
  private func setUpCommentField() {
    self.view.addSubview(commentField)
    commentField.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
    }
    commentField.adds([commentCheckBox, commentNoti,commentTextField,addCommentButton])
    commentCheckBox.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(8)
      $0.width.height.equalTo(20)
    }
    commentNoti.snp.makeConstraints{
      $0.centerY.equalTo(commentCheckBox)
      $0.leading.equalTo(commentCheckBox.snp.trailing).offset(4)
    }
    commentTextField.snp.makeConstraints{
      $0.top.equalTo(commentCheckBox.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(16)
      $0.height.equalTo(36)
      $0.trailing.equalTo(addCommentButton.snp.leading)
      $0.bottom.equalToSuperview().offset(-44)
    }
    addCommentButton.snp.makeConstraints{
      $0.centerY.equalTo(commentTextField)
      $0.trailing.equalToSuperview().offset(-12)
      $0.width.equalTo(52)
      $0.height.equalTo(36)
    }
  }
  private func setUpNavi() {
    self.view.add(naviView)
    naviView.snp.makeConstraints{
      $0.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    naviView.adds([naviTitle,backBtn,likeBtn])
    naviTitle.snp.makeConstraints{
      $0.bottom.equalToSuperview().offset(-20)
      $0.centerX.equalToSuperview()
    }
    backBtn.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(44)
      $0.leading.equalToSuperview()
    }
    likeBtn.snp.makeConstraints{
      $0.centerY.equalTo(naviView)
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  private let postDetail = PostDetailView()
  private let achivementView = AchivementRateView()
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let commentView = CommentAreaView()
  private func setUpLayout() {
    self.view.add(scrollView)
    scrollView.snp.makeConstraints{
      $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.equalTo(naviView.snp.bottom)
    }
    scrollView.add(contentView)
    contentView.snp.makeConstraints{
      $0.width.leading.trailing.top.bottom.equalToSuperview()
      $0.height.equalToSuperview().priority(.low)
    }
    contentView.adds([postDetail,
                      achivementView,
                      commentView])
    postDetail.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(contentView)
    }
    postDetail.addUnderBar()
    achivementView.snp.makeConstraints{
      $0.top.equalTo(postDetail.snp.bottom).offset(1)
      $0.leading.trailing.equalToSuperview()
    }
    commentView.snp.makeConstraints{
      $0.top.equalTo(achivementView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-116)
    }
  }
  lazy var dataSource = DataSource<CommentSectionType> (
    configureCell: configureCell
  )
}
extension PostDetailViewControlelr : UITableViewDelegate {
  private func setupTableView() {
    commentView.commentTableView.register(SubCommentTableViewCell.self, forCellReuseIdentifier: SubCommentTableViewCell.identifier)
    commentView.commentTableView.register(CommentView.self, forHeaderFooterViewReuseIdentifier: CommentView.identifier)
    commentView.commentTableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    commentView.commentTableView.backgroundColor = .white
    commentView.commentTableView.rowHeight = UITableView.automaticDimension
    commentView.commentTableView.estimatedRowHeight = 100
    commentView.commentTableView.estimatedSectionHeaderHeight = 100
    commentView.commentTableView.sectionHeaderHeight = UITableView.automaticDimension
  }
  func tableView(
      _ tableView: UITableView,
      viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentView.identifier) as? CommentView else {
      return nil
    }
    view.profileBtn.setImage(UIImage(named: dataSource[section].model.profile),for: .normal)
    view.userName.text = dataSource[section].model.userName
    view.commentLabel.text = dataSource[section].model.comment
    view.commentedAt.text = dataSource[section].model.postedAt.asDate(format: .yyyyMMddDot)?.detailTime
    view.addSubcommentBtn.rx.tap
      .takeUntil(view.rx.methodInvoked(#selector(UITableViewHeaderFooterView.prepareForReuse)))
      .bind{ [weak self] in
        print(self?.dataSource[section].model.identity)
      }.disposed(by: disposeBag)
    return view
  }
  private var configureCell: DataSource<CommentSectionType>.ConfigureCell {
    return {[weak self] ds, tableView, indexPath, item -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(withIdentifier: SubCommentTableViewCell.identifier, for: indexPath) as! SubCommentTableViewCell
      cell.bindCell(model: item)
      return cell
    }
  }
  
}
extension PostDetailViewControlelr {
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNavi()
    setUpLayout()
    setUpCommentField()
    setUpKeyboard()
    setupTableView()
    bind()
    self.achivementView.emptyAchivement.isHidden = false
  }
  private func bind() {
    let inputs = PostDetailViewModel.Input(loadView: Observable.just(()))
    let outputs = viewModel.transform(input: inputs)
    
    outputs.commentUsecase
      .bind(to: commentView.commentTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    commentView.commentTableView.rx.observeWeakly(CGSize.self, "contentSize")
      .compactMap{$0?.height}
      .distinctUntilChanged()
      .bind{[weak self] h in
        self?.commentView.commentTableView.snp.updateConstraints{
          $0.height.equalTo(h)
        }
      }.disposed(by: disposeBag)
    achivementView.participateBtn.rx.tap.bind{[weak self] in
      var view : ModifyJoinView? = ModifyJoinView()
      PopUpView.shared.appearPopUpView(subView: view!)
      view!.resultClosure = { value in
        print(value)
        view = nil
      }
    }.disposed(by: disposeBag)
  }
}
//MARK:- 키보드관리
extension PostDetailViewControlelr {
  func setUpKeyboard() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(commentkeyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(commentkeyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  @objc func commentkeyboardWillShow(_ notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      
      self.commentField.snp.updateConstraints{
        $0.bottom.equalToSuperview().offset(-keyboardHeight)
      }
      
    }
  }
  @objc func commentkeyboardWillHide(_ notification: Notification) {
    self.commentField.snp.updateConstraints{
      $0.bottom.equalToSuperview()
    }
  }
}

internal class PostDetailView : UIView{
  let profileImage = UIButton().then {
    $0.setRounded(radius: 13.5)
    $0.backgroundColor = .gray196
  }
  let profileName = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundBold(fontSize: 12))
  }
  private let typeView = UIView().then {
    $0.backgroundColor = .communityGreen
    $0.setRounded(radius: 12)
  }
  let typeLabel = UILabel().then {
    $0.setupLabel(text: "", color: .white, font: .nanumRoundExtraBold(fontSize: 12))
  }
  let postedAt = UILabel().then {
    $0.setupLabel(text: "", color: .grayText, font: .nanumRoundRegular(fontSize: 12))
  }
  let postTitle = UILabel().then{
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 18))
  }
  let postContent = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
    $0.numberOfLines = 0
  }
  var postImageCollectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    layout.minimumLineSpacing = 8
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.showsHorizontalScrollIndicator = false
    cv.showsVerticalScrollIndicator = false
    cv.backgroundColor = .white
    cv.register(ReusableSimpleImageCell.self, forCellWithReuseIdentifier: ReusableSimpleImageCell.identifier)
    return cv
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.adds([profileImage,
               profileName,
               typeView,
               postedAt,
               postTitle,
               postContent,
               postImageCollectionView])
    typeView.add(typeLabel)
    profileImage.snp.makeConstraints{
      $0.top.leading.equalTo(16)
      $0.width.height.equalTo(27)
    }
    profileName.snp.makeConstraints{
      $0.centerY.equalTo(profileImage)
      $0.leading.equalTo(profileImage.snp.trailing).offset(8)
    }
    postedAt.snp.makeConstraints{
      $0.centerY.equalTo(profileImage)
      $0.leading.equalTo(profileName.snp.trailing).offset(4)
    }
    typeView.snp.makeConstraints{
      $0.centerY.equalTo(profileImage)
      $0.height.equalTo(36)
      $0.trailing.equalToSuperview().offset(-16)
    }
    typeLabel.snp.makeConstraints{
      $0.centerY.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(5)
      $0.leading.equalToSuperview().offset(12)
    }
    postTitle.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(profileImage.snp.bottom).offset(24)
    }
    postContent.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(postTitle.snp.bottom).offset(14)
      $0.trailing.equalToSuperview().offset(-16)
    }
    postImageCollectionView.snp.makeConstraints{
      $0.top.equalTo(postContent.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(100)
      $0.bottom.equalToSuperview().offset(-24)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
internal class AchivementRateView : UIView{
  private let titlelabel = UILabel().then {
    $0.setupLabel(text: "달성률", color: .blackText, font: .nanumRoundExtraBold(fontSize: 16))
  }
  let emptyAchivement = UILabel().then {
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
    $0.setupLabel(text: "목표를 설정하지 않은 글이에요!", color: .blackText, font: .nanumRoundExtraBold(fontSize: 12),align: .center)
    $0.isHidden = true
  }
  let participateBtn = UIButton().then{
    $0.borderWidth = 1
    $0.borderColor = .communityGreen
    $0.setRounded(radius: 8)
    $0.setTitle("공구 참여하기", for: .normal)
    $0.setTitleColor(.communityGreen, for: .normal)
    $0.titleLabel?.font = .nanumRoundExtraBold(fontSize: 16)
    
  }
  let currentPrice = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  let targetPrice = UILabel().then {
    $0.setupLabel(text: "/", color: .grayText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private let priceView = UIView().then {
    $0.backgroundColor = .gray249
    $0.setRounded(radius: 14)
  }
  private let targetAmountView = UIView().then {
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 8)
  }
  let currentAmountView = UIView().then {
    $0.backgroundColor = .communityGreen
    $0.setRounded(radius: 8)
  }
  let currentPriceIndicator = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 10))
  }
  let targetPriceIndicator = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 10))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.adds([titlelabel,
               priceView,
               targetAmountView,
               currentAmountView,
               targetPriceIndicator,
               currentPriceIndicator,
               participateBtn,
               emptyAchivement])
    priceView.adds([currentPrice,targetPrice])
    titlelabel.snp.makeConstraints{
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    priceView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(titlelabel.snp.bottom).offset(12)
      $0.height.equalTo(28)
    }
    currentPrice.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(12)
      $0.top.equalTo(6)
      $0.trailing.equalTo(targetPrice.snp.leading)
    }
    targetPrice.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-12)
      $0.top.equalTo(6)
    }
    targetAmountView.snp.makeConstraints{
      $0.top.equalTo(priceView.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(16)
    }
    currentAmountView.snp.makeConstraints{
      $0.leading.top.bottom.equalTo(targetAmountView)
      $0.width.equalTo(targetAmountView.snp.width).multipliedBy(0.5)
    }
    currentPriceIndicator.snp.makeConstraints{
      $0.top.equalTo(targetAmountView.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(16)
    }
    targetPriceIndicator.snp.makeConstraints{
      $0.top.equalTo(targetAmountView.snp.bottom).offset(12)
      $0.trailing.equalToSuperview().offset(-16)
    }
    emptyAchivement.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(priceView)
      $0.bottom.equalTo(targetPriceIndicator)
    }
    participateBtn.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(targetPriceIndicator.snp.bottom).offset(15)
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
internal class CommentAreaView : UIView{
  private let commentTitle = UILabel().then{
    $0.setupLabel(text: "댓글", color: .blackText, font: .nanumRoundExtraBold(fontSize: 16))
  }
  let commentTableView = UITableView().then {
    $0.isScrollEnabled = false
    $0.separatorStyle = .none
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.adds([commentTitle,
               commentTableView])
    commentTitle.snp.makeConstraints{
      $0.top.equalToSuperview().offset(32)
      $0.leading.equalToSuperview().offset(16)
    }
    commentTableView.snp.makeConstraints{
      $0.top.equalTo(commentTitle.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(400)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
