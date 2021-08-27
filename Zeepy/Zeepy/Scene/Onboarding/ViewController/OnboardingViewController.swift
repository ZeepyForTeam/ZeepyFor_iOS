//
//  OnboardingViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/08/26.
//

import UIKit

import Lottie
import SnapKit
import Then

// MARK: - OnboardingViewController

final class OnboardingViewController: UIViewController {
  
  // MARK: - Lazy Components
  private lazy var backgroundAnimationView: AnimationView = {
    let animationView = AnimationView(name: "zeepy_onboarding")
    animationView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height)
    
    animationView.center = self.view.center
    animationView.contentMode = .scaleAspectFill
    return animationView
  }()
  
  private lazy var onboardingCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame:
                                            CGRect(x: 0,
                                                   y: 0,
                                                   width: self.view.frame.width,
                                                   height: self.view.frame.height),
                                          collectionViewLayout: flowLayout)
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundView?.backgroundColor = .clear
    return collectionView
  }()
  
  private lazy var pagerImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "firstPageIcon")
    return imageView
  }()
  
  // MARK: - Variables
  
  var currentIndex: Int = 0
  
  // MARK: - LifeCycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
    register()
    backgroundAnimationView.loopMode = .repeat(.infinity)
    backgroundAnimationView.animationSpeed = 0.5
    backgroundAnimationView.play()
  }
}

// MARK: - Extensions

extension OnboardingViewController {
  
  // MARK: - Layout Helpers
  
  private func layout() {
    self.view.backgroundColor = .clear
    self.view.adds([backgroundAnimationView,
                    onboardingCollectionView,
                    pagerImageView])
    backgroundAnimationView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    onboardingCollectionView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    pagerImageView.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-64)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(72)
      $0.height.equalTo(15)
      
    }
  }
  
  // MARK: - Genenral Helpers
  
  private func register() {
    onboardingCollectionView.register(
      FirstOnboardingCollectionViewCell.self,
      forCellWithReuseIdentifier:
        FirstOnboardingCollectionViewCell.identifier)
    
    onboardingCollectionView.register(
      SecondOnboardingCollectionViewCell.self,
      forCellWithReuseIdentifier:
        SecondOnboardingCollectionViewCell.identifier)
    
    onboardingCollectionView.register(
      ThirdOnboardingCollectionViewCell.self,
      forCellWithReuseIdentifier:
        ThirdOnboardingCollectionViewCell.identifier)
    
    onboardingCollectionView.delegate = self
    onboardingCollectionView.dataSource = self
  }
  
  func changePager() {
    switch currentIndex {
    case 0:
      pagerImageView.image = UIImage(named: "firstPageIcon")
    case 1:
      pagerImageView.image = UIImage(named: "secondPageIcon")
    case 2:
      pagerImageView.image = UIImage(named: "thirdPageIcon")
    default:
      pagerImageView.image = UIImage(named: "firstPageIcon")
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    currentIndex = Int(scrollView.contentOffset.x) / Int(UIScreen.main.bounds.width)
    changePager()
  }
  
  func joinButtonClicked() {
    let root = LoginEmailViewController()
    let rootNav = UINavigationController()
    rootNav.navigationBar.isHidden = true
    
    rootNav.viewControllers = [root]
    if let window = (UIApplication.shared.delegate as! AppDelegate).window {
      window.rootViewController = rootNav
    }
  }
  
  func lookAroundButtonClicked() {
    let root = TabbarViewContorller()
    let rootNav = UINavigationController()
    rootNav.navigationBar.isHidden = true
    
    rootNav.viewControllers = [root]
    if let window = (UIApplication.shared.delegate as! AppDelegate).window {
      window.rootViewController = rootNav
    }
  }
}
  
  // MARK: - CollectionViewDelegateFlowLayout
  
  extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      return CGSize(width: self.view.frame.width,
                    height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return .zero
    }
  }
  
  // MARK: - CollectionViewDataSource
  
  extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int {
      return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
      
      guard let firstCell = collectionView.dequeueReusableCell(
              withReuseIdentifier: FirstOnboardingCollectionViewCell.identifier, for: indexPath)
              as? FirstOnboardingCollectionViewCell else {
        return UICollectionViewCell()
      }
      guard let secondCell = collectionView.dequeueReusableCell(
              withReuseIdentifier: SecondOnboardingCollectionViewCell.identifier, for: indexPath)
              as? SecondOnboardingCollectionViewCell else {
        return UICollectionViewCell()
      }
      guard let thirdCell = collectionView.dequeueReusableCell(
              withReuseIdentifier: ThirdOnboardingCollectionViewCell.identifier, for: indexPath)
              as? ThirdOnboardingCollectionViewCell else {
        return UICollectionViewCell()
      }
      switch indexPath.item {
      case 0:
        return firstCell
      case 1:
        return secondCell
      case 2:
        thirdCell.rootViewController = self
        return thirdCell
      default:
        return UICollectionViewCell()
      }
    }
    
    
  }
