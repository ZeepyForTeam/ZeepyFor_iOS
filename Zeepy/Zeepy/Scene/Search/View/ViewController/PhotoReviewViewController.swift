//
//  PhotoReviewViewController.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/07/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhotoReviewViewController : BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    layout()
    //dummy()
  }
  private let naviView = CustomNavigationBar().then {
    $0.setUp(title: "포토리뷰")
  }
  private var collectionView : UICollectionView!
}
extension PhotoReviewViewController {
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 109, height: 109)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 9
    layout.minimumInteritemSpacing = 9
    layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.collectionView.backgroundColor = .white
    self.collectionView.register(ReusableSimpleImageCell.self,
                                 forCellWithReuseIdentifier: ReusableSimpleImageCell.identifier)
  }
  private func layout() {
    self.view.adds([naviView, collectionView])
    naviView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(68)
    }
    collectionView.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-16)
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(naviView.snp.bottom).offset(16)
    }
  }
  private func dummy() {
    let temp = Observable.just(["","","","","",""])
    temp.bind(to: collectionView.rx.items(cellIdentifier: ReusableSimpleImageCell.identifier,
                                     cellType: ReusableSimpleImageCell.self)) {row, data, cell in
      cell.bindCell(model: data)
    }.disposed(by: disposeBag)
//    collectionView.rx.modelSelected(Int.self).bind{[weak self] _ in
//      let vc = DetailReviewViewContoller()
//      self?.navigationController?.pushViewController(vc, animated: true)
//    }.disposed(by: disposeBag)
  }
}
