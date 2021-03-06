//
//  ParticipateCollectionViewCell.swift
//  Zeepy
//
//  Created by κΉνν on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa

class TapCell: UICollectionViewCell {
  private let refreshController = UIRefreshControl()
  
  var viewModel: CommunityViewModel!
  var disposeBag = DisposeBag()
  var currentTab: Int!
  private var postCollectionView : UICollectionView!
  private let refreshTrigger = PublishSubject<Void>()
  private var currentPage: Int? = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension TapCell {
  private func refreshCell() {
    refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    postCollectionView.refreshControl = refreshController
  }
  @objc
  private func refreshData() {
    if let communityVC = UIApplication.shared.topViewController() as? CommunityViewController {
      communityVC.selectedType.onNext(.total)
    }
    refreshController.endRefreshing()
  }
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
  func bind(output : CommunityViewModel.Output, dispose : DisposeBag) {
    refreshCell()
    output.postUsecase
      .map{ items -> [PostModel] in
        if items.isEmpty {
          return [.init(id: -1, type: .deal, status: false, postTitle: "", postConent: "", postedAt: "")]
        }
        else {
          return items
        }
      }
      .bind(to: postCollectionView.rx
              .items(cellIdentifier: postSimpleCollectionViewCell.identifier,
                     cellType: postSimpleCollectionViewCell.self)) {[weak self] row, data, cell in
        if data.id == -1 {
          cell.bindEmpty()
        }
        else {
          cell.bindCell(model: data)
          if row > 18 * ((self?.currentPage ?? 0) + 1) {
            if let communityVC = UIApplication.shared.topViewController() as? CommunityViewController {
              communityVC.pagenation.onNext((self?.currentPage ?? 0) + 1)
            }
          }
        }
      }.disposed(by: dispose)
    if let communityVC = UIApplication.shared.topViewController() as? CommunityViewController {
      communityVC.pagenation.bind{[weak self] page in
        self?.currentPage = page
      }.disposed(by: disposeBag)
    }
    
    postCollectionView.rx.modelSelected(PostModel.self)
      .bind{[weak self] model in
        if model.id == -1 {
          let vc = PostViewController()
          vc.hidesBottomBarWhenPushed = true
          vc.navigationController?.setNavigationBarHidden(true, animated: false)
          UIApplication.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        else {
          if let vc = PostDetailViewControlelr(nibName: nil, bundle: nil, postId: model.id) {
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
          }
        }
      }.disposed(by: dispose)
  }
}
