//
//  ImageViewer.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/08/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
class ImageViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0.7)
        return collectionView
    }()
    var ImageId : Int?
    private let backButton: UIButton = {
        let temp = UIButton()
        temp.setImage(UIImage(named: "btnCloseYel"), for: .normal)
        temp.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return temp
    }()
    private let disposeBag = DisposeBag()
    @objc
    override func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    private let pageControl: UIPageControl = {
        let temp = UIPageControl()
        temp.tintColor = .mainBlue
        temp.pageIndicatorTintColor = .white
        
        temp.currentPageIndicatorTintColor = .mainBlue
        return temp
    }()

    var imageArray: [String]?
    var imageViewArray: [UIImage]?
    var index: Int?
    var idList: [Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()

        collectionView.isUserInteractionEnabled = true
        setCollectionView()
        //collectionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeDown)))

    }
    deinit {
       print("deinit")
    }
    private func layout() {
        view.backgroundColor = .white
        view.add(collectionView) {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.delegate = self
            $0.dataSource = self
            $0.register(ImageCollectionViewCell.self,
                                    forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)

        }
        view.add(backButton) {
            $0.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-10)
                $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
                $0.width.height.equalTo(40)
            }
        }
        view.add(pageControl) {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-(self.view.frame.height - self.view.frame.width)/2 + 50)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(60)
                $0.height.equalTo(20)
            }
            if self.imageArray?.count == 0 {
                $0.numberOfPages = self.imageViewArray?.count ?? 0
                $0.currentPage = 0

            }
            else {
                $0.numberOfPages = self.imageArray?.count ?? 0
                $0.currentPage = 0

            }

        }
        if let i = self.index {
            if let ids = idList {
                if ids[i] != -1 && ids[i] != 0{
                    self.ImageId = ids[i]
                }
            }
        }
    }

    @objc
    private func backButtonDidTap() {

        dismiss(animated: true, completion: nil)
    }

}

extension ImageViewController: UICollectionViewDelegate {

}
extension ImageViewController: UICollectionViewDataSource {
    func setCollectionView() {
        self.collectionView.rx.didScroll.bind{ [weak self] _ in
            let index = Int(((self?.collectionView.contentOffset.x ?? 0) / UIScreen.main.bounds.width).rounded())
            if let indexes = self?.idList {
                self?.ImageId = indexes[index]
            }
        }.disposed(by:disposeBag)
    }
    func collectionView(_ collectionView: UICollectionView,
                                            numberOfItemsInSection section: Int) -> Int {
        if imageArray?.count == 0 || imageArray?.count == nil {
            return imageViewArray?.count ?? 0
        }
        else {
            return imageArray?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        if imageArray?.count == 0 || imageArray == nil{
            guard let realImage = imageViewArray?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.image(realImage)
        }
        else {
            guard let imageURL = imageArray?[indexPath.row] else {
                return UICollectionViewCell()
            }

            cell.image(imageURL)
        }
        return cell
    }
}
extension ImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                                            layout collectionViewLayout: UICollectionViewLayout,
                                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentOffset.x = CGFloat(self.index ?? 0) * collectionView.frame.width
        self.pageControl.currentPage = index ?? 0
        return CGSize(width: view.frame.width,
                                    height: view.frame.height)
    }
}
class ImageCollectionViewCell: UICollectionViewCell {

    let imageView : UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layout() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(saveImage)))
        contentView.add(imageView) {
            $0.snp.makeConstraints {
                $0.centerX.centerY.equalTo(self.contentView)
                $0.width.height.equalTo(self.contentView.frame.width)
            }
        }
    }
    private var viewCenter: CGPoint?

    @objc
    private func saveImage(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { action in
                if let image = self.imageView.image {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError), nil)
                }
                else {
                    MessageAlertView.shared.showAlertView(title: "사진 저장을 실패했습니다.", grantMessage: "확인")
                }
            }))
            UIApplication.topViewController()?.present(alert,animated: true)
        }
    }
    @objc
    private func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            MessageAlertView.shared.showAlertView(title: "사진 저장을 실패했습니다.", grantMessage: "확인")
        }
        else {
            MessageAlertView.shared.showAlertView(title: "사진을 저장했습니다.", grantMessage: "확인")
        }
    }
    @objc
    private func swipeDown(sender : UIPanGestureRecognizer) {

        let target = sender.view
        switch sender.state {
        case .began :
          viewCenter = target?.center
        case .changed :
          let translation = sender.translation(in: self.imageView)
          if translation.y > 0 {
            target?.center = CGPoint(x: viewCenter!.x, y: viewCenter!.y + translation.y)
          }
            if translation.x > 0 {
              target?.center = CGPoint(x: viewCenter!.x + translation.x, y: viewCenter!.y )
            }
        case .ended :
          let translation = sender.translation(in: self.imageView)
            let height = self.contentView.bounds.height
          if translation.y > height * 0.1 {
            UIApplication.shared.topViewController()?.dismiss(animated: true, completion: nil)
          }
          else if translation.y > 0 {
            target?.center = CGPoint(x: viewCenter!.x, y: viewCenter!.y)
          }
        default : print("")
        }

    }
    func image(_ url: String) {
        imageView.kf.setImage(with: URL(string: url))
    }
    func image(_ image: UIImage) {
        imageView.image = image
    }
}
