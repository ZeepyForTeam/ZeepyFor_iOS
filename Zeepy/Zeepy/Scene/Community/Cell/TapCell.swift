//
//  ParticipateCollectionViewCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa

class TapCell: UICollectionViewCell {
  var viewModel: CommunityViewModel!
  var disposeBag = DisposeBag()
  var currentTab: Int!
  private var postCollectionView : UICollectionView!
  private let refreshTrigger = PublishSubject<Void>()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension TapCell {
  func layout() {
    self.contentView.add(postCollectionView)
    postCollectionView.snp.remakeConstraints{
      $0.top.leading.trailing.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
    }
    print(self.contentView.safeAreaLayoutGuide.snp.height)

  }
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()

    postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    postCollectionView.backgroundColor = .white
    postCollectionView.register(postSimpleCollectionViewCell.self,
                            forCellWithReuseIdentifier: postSimpleCollectionViewCell.identifier)
    //    collectionView.register(MyPackageCollectionViewCell.self, forCellWithReuseIdentifier: MyPackageCollectionViewCell.identifier)
    postCollectionView.showsHorizontalScrollIndicator = false
    postCollectionView.showsVerticalScrollIndicator = false
  }
  func changeCollectionViewSection(tab : Int) {
    if tab == 0 {
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 8
      layout.scrollDirection = .vertical
      layout.sectionInset = UIEdgeInsets(top: 46, left: 16, bottom: 0, right: 16)
      layout.itemSize = UICollectionViewFlowLayout.automaticSize
      layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 32, height:  UIScreen.main.bounds.height)
      postCollectionView.collectionViewLayout = layout
      postCollectionView.isScrollEnabled = true
    }
    else {
      let layout = UICollectionViewFlowLayout()

      layout.minimumLineSpacing = 8
      layout.scrollDirection = .vertical
      layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
      layout.itemSize = UICollectionViewFlowLayout.automaticSize
      layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 32, height:  UIScreen.main.bounds.height)
      postCollectionView.collectionViewLayout = layout
    }
  }
  func bind(output : CommunityViewModel.Output) {
    output.postUsecase.bind(to: postCollectionView.rx
                              .items(cellIdentifier: postSimpleCollectionViewCell.identifier,
                                     cellType: postSimpleCollectionViewCell.self)) {row, data, cell in
      cell.bindCell(model: data)
    }.disposed(by: disposeBag)
  }
}
