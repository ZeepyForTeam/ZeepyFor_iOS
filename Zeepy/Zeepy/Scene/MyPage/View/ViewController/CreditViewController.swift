//
//  CreditViewController.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/25.
//

import UIKit

import SnapKit
import Then

// MARK: - CreditViewController
class CreditViewController: BaseViewController {
  
  // MARK: - Components
  private let scrollView = UIScrollView()
  private let containerView = UIView()
  private let navigationView = CustomNavigationBar()
  private let planDesignView = UIView()
  private let marketingView = UIView()
  private let serverView = UIView()
  private let clientView = UIView()
  private let planLabel = UILabel()
  private let designLabel = UILabel()
  private let marketingLabel = UILabel()
  private let serverLabel = UILabel()
  private let clientLabel = UILabel()
  private let merinImageView = UIImageView()
  private let sumiImageView = UIImageView()
  private let jazeroImageView = UIImageView()
  private let eunjinImageView = UIImageView()
  private let juyoungImageView = UIImageView()
  private let minkyuImageView = UIImageView()
  private let yenImageView = UIImageView()
  private let hyunjongImageView = UIImageView()
  private let keiImageView = UIImageView()
  private let roksuiImageView = UIImageView()
  private let peaceImageView = UIImageView()
  private let gujilImageView = UIImageView()
  private let jottoImageView = UIImageView()
  private let mushImageView = UIImageView()
  private let merinLabel = UILabel()
  private let sumiLabel = UILabel()
  private let jazeroLabel = UILabel()
  private let eunjinLabel = UILabel()
  private let juyoungLabel = UILabel()
  private let minkyuLabel = UILabel()
  private let yenLabel = UILabel()
  private let hyunjongLabel = UILabel()
  private let keiLabel = UILabel()
  private let roksuiLabel = UILabel()
  private let peaceLabel = UILabel()
  private let gujilLabel = UILabel()
  private let jottoLabel = UILabel()
  private let mushLabel = UILabel()
  
  // MARK: - Variables
  private final let planText = "기획 하기스"
  private final let designText = "디자인 하우디"
  private final let marketingText = "마케팅 하마"
  private final let serverText = "서버 하버드"
  private final let clientText = "클라이언트  하우두유두,하와요"
  private final let creditImageTitles = ["people01",
                                         "people02",
                                         "people03",
                                         "people04",
                                         "people05",
                                         "people06",
                                         "people07",
                                         "people08",
                                         "people09",
                                         "people10",
                                         "people11",
                                         "people12",
                                         "people14",
                                         "people13"]
  private final let creditNames = ["류혜린",
                                   "강수미",
                                   "김자영",
                                   "곽은진",
                                   "박주영",
                                   "이민규",
                                   "이예인",
                                   "이현종",
                                   "황보 경",
                                   "서정록",
                                   "손평화",
                                   "김주은",
                                   "김태훈",
                                   "노한솔"]
  
  // MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configData()
    layout()
    setupNavigation()
  }
}

// MARK: - Extensions
extension CreditViewController {
  
  // MARK: - Layout Helpers
  private func layout() {
    layoutNavigationView()
    layoutScrollView()
    layoutContainerView()
    layoutPlanDesignView()
    layoutMarketingView()
    layoutServerView()
    layoutClientView()
    layoutPlanLabel()
    layoutMerinImageView()
    layoutMerinLabel()
    layoutSumiImageView()
    layoutSumiLabel()
    layoutJazeroImageView()
    layoutJazeroLabel()
    layoutDesignLabel()
    layoutMarketingLabel()
    layoutEunjinImageView()
    layoutEunjinLabel()
    layoutJuyoungImageView()
    layoutJuyoungLabel()
    layoutServerLabel()
    layoutMinkyuImageView()
    layoutMinkyuLabel()
    layoutYenImageView()
    layoutYenLabel()
    layoutHyunjongImageView()
    layoutHyunjongLabel()
    layoutKeiImageView()
    layoutKeiLabel()
    layoutClientLabel()
    layoutRoksuiImageView()
    layoutRoksuiLabel()
    layoutPeaceImageView()
    layoutPeaceLabel()
    layoutGujilImageView()
    layoutGujilLabel()
    layoutJottoImageView()
    layoutJottoLabel()
    layoutMushImageView()
    layoutMushLabel()
  }
  
  private func layoutNavigationView() {
    view.add(navigationView) {
      $0.backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(68)
      }
    }
  }
  
  private func layoutScrollView() {
    view.add(scrollView) {
      $0.backgroundColor = .clear
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.showsVerticalScrollIndicator = false
      $0.snp.makeConstraints {
        $0.center.leading.trailing.bottom.equalToSuperview()
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(68)
      }
    }
  }
  
  private func layoutContainerView() {
    scrollView.add(containerView) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .clear
      $0.contentMode = .scaleToFill
      $0.snp.makeConstraints {
        $0.centerX.top.leading.equalToSuperview()
        $0.bottom.equalTo(self.scrollView.snp.bottom)
      }
    }
  }
  
  private func layoutPlanDesignView() {
    containerView.add(planDesignView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.containerView.snp.top).offset(24)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
        $0.height.equalTo(141)
      }
    }
  }
  
  private func layoutMarketingView() {
    containerView.add(marketingView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.planDesignView.snp.bottom)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
        $0.height.equalTo(141)
      }
    }
  }
  
  private func layoutServerView() {
    containerView.add(serverView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.marketingView.snp.bottom)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
        $0.height.equalTo(141)
      }
    }
  }
  
  private func layoutClientView() {
    containerView.add(clientView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.serverView.snp.bottom)
        $0.leading.equalTo(self.view.snp.leading).offset(16)
        $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
        $0.height.equalTo(220)
        $0.bottom.equalToSuperview().offset(-(self.tabBarController?.tabBar.frame.height)! - 20)
      }
    }
  }
  
  private func layoutPlanLabel() {
    planDesignView.add(planLabel) {
      $0.snp.makeConstraints {
        $0.top.leading.equalToSuperview()
      }
    }
  }
  
  private func layoutMerinImageView() {
    planDesignView.add(merinImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.planLabel.snp.bottom).offset(12)
        $0.leading.equalToSuperview()
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutMerinLabel() {
    planDesignView.add(merinLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.merinImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.merinImageView.snp.centerX)
      }
    }
  }
  
  private func layoutSumiImageView() {
    planDesignView.add(sumiImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.merinImageView.snp.top)
        $0.leading.equalTo(self.merinImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutSumiLabel() {
    planDesignView.add(sumiLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.merinLabel.snp.top)
        $0.centerX.equalTo(self.sumiImageView.snp.centerX)
      }
    }
  }
  
  private func layoutJazeroImageView() {
    planDesignView.add(jazeroImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.merinImageView.snp.top)
        $0.leading.equalTo(self.sumiImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutJazeroLabel() {
    planDesignView.add(jazeroLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.merinLabel.snp.top)
        $0.centerX.equalTo(self.jazeroImageView.snp.centerX)
      }
    }
  }
  
  private func layoutDesignLabel() {
    planDesignView.add(designLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.planLabel.snp.top)
        $0.leading.equalTo(self.jazeroImageView.snp.leading)
      }
    }
  }
  
  private func layoutMarketingLabel() {
    marketingView.add(marketingLabel) {
      $0.snp.makeConstraints {
        $0.top.leading.equalToSuperview()
      }
    }
  }
  
  private func layoutEunjinImageView() {
    marketingView.add(eunjinImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.marketingLabel.snp.bottom).offset(12)
        $0.leading.equalToSuperview()
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutEunjinLabel() {
    marketingView.add(eunjinLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.eunjinImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.eunjinImageView.snp.centerX)
      }
    }
  }
  
  private func layoutJuyoungImageView() {
    marketingView.add(juyoungImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.eunjinImageView.snp.top)
        $0.leading.equalTo(self.eunjinImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutJuyoungLabel() {
    marketingView.add(juyoungLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.juyoungImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.juyoungImageView.snp.centerX)
      }
    }
  }
  
  private func layoutServerLabel() {
    serverView.add(serverLabel) {
      $0.snp.makeConstraints {
        $0.top.leading.equalToSuperview()
      }
    }
  }
  
  private func layoutMinkyuImageView() {
    serverView.add(minkyuImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.serverLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.serverLabel.snp.leading)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutMinkyuLabel() {
    serverView.add(minkyuLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.minkyuImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.minkyuImageView.snp.centerX)
      }
    }
  }
  
  private func layoutYenImageView() {
    serverView.add(yenImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.minkyuImageView.snp.top)
        $0.leading.equalTo(self.minkyuImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutYenLabel() {
    serverView.add(yenLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.yenImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.yenImageView.snp.centerX)
      }
    }
  }
  
  private func layoutHyunjongImageView() {
    serverView.add(hyunjongImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.minkyuImageView.snp.top)
        $0.leading.equalTo(self.yenImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutHyunjongLabel() {
    serverView.add(hyunjongLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.hyunjongImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.hyunjongImageView.snp.centerX)
      }
    }
  }
  
  private func layoutKeiImageView() {
    serverView.add(keiImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.minkyuImageView.snp.top)
        $0.leading.equalTo(self.hyunjongImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutKeiLabel() {
    serverView.add(keiLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.keiImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.keiImageView.snp.centerX)
      }
    }
  }
  
  private func layoutClientLabel() {
    clientView.add(clientLabel) {
      $0.snp.makeConstraints {
        $0.top.leading.equalToSuperview()
      }
    }
  }
  
  private func layoutRoksuiImageView() {
    clientView.add(roksuiImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.clientLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.clientLabel.snp.leading)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutRoksuiLabel() {
    clientView.add(roksuiLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.roksuiImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.roksuiImageView.snp.centerX)
      }
    }
  }
  
  private func layoutPeaceImageView() {
    clientView.add(peaceImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.roksuiImageView.snp.top)
        $0.leading.equalTo(self.roksuiImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutPeaceLabel() {
    clientView.add(peaceLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.peaceImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.peaceImageView.snp.centerX)
      }
    }
  }
  
  private func layoutGujilImageView() {
    clientView.add(gujilImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.roksuiLabel.snp.bottom).offset(12)
        $0.leading.equalTo(self.roksuiImageView.snp.leading)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutGujilLabel() {
    clientView.add(gujilLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.gujilImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.gujilImageView.snp.centerX)
      }
    }
  }
  
  private func layoutJottoImageView() {
    clientView.add(jottoImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.gujilImageView.snp.top)
        $0.leading.equalTo(self.gujilImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutJottoLabel() {
    clientView.add(jottoLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.jottoImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.jottoImageView.snp.centerX)
      }
    }
  }
  
  private func layoutMushImageView() {
    clientView.add(mushImageView) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.gujilImageView.snp.top)
        $0.leading.equalTo(self.jottoImageView.snp.trailing).offset(8)
        $0.width.height.equalTo(self.view.frame.width * 65/375)
      }
    }
  }
  
  private func layoutMushLabel() {
    clientView.add(mushLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.mushImageView.snp.bottom).offset(12)
        $0.centerX.equalTo(self.mushImageView.snp.centerX)
      }
    }
  }
  
  // MARK: - General Helpers
  private func configData() {
    let planAttributedText = NSMutableAttributedString(string: planText,
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 12),
                                                .foregroundColor: UIColor.blackText])
    planAttributedText.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont.nanumRoundRegular(fontSize: 12),
                           range: NSRange(location: 2, length: planAttributedText.length - 2))
    planLabel.attributedText = planAttributedText
    
    let designAttributedText = NSMutableAttributedString(string: designText,
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 12),
                                                .foregroundColor: UIColor.blackText])
    designAttributedText.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont.nanumRoundRegular(fontSize: 12),
                           range: NSRange(location: 3, length: designAttributedText.length - 3))
    designLabel.attributedText = designAttributedText
    
    let serverAttributedText = NSMutableAttributedString(string: serverText,
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 12),
                                                .foregroundColor: UIColor.blackText])
    serverAttributedText.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont.nanumRoundRegular(fontSize: 12),
                           range: NSRange(location: 2, length: serverAttributedText.length - 2))
    serverLabel.attributedText = serverAttributedText
    
    let marketingAttributedText = NSMutableAttributedString(string: marketingText,
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 12),
                                                .foregroundColor: UIColor.blackText])
    marketingAttributedText.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont.nanumRoundRegular(fontSize: 12),
                           range: NSRange(location: 3, length: marketingAttributedText.length - 3))
    marketingLabel.attributedText = marketingAttributedText
    
    let clientAttributedText = NSMutableAttributedString(string: clientText,
                                              attributes: [
                                                .font: UIFont.nanumRoundExtraBold(fontSize: 12),
                                                .foregroundColor: UIColor.blackText])
    clientAttributedText.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont.nanumRoundRegular(fontSize: 12),
                           range: NSRange(location: 6, length: clientAttributedText.length - 6))
    clientLabel.attributedText = clientAttributedText
    
    merinImageView.image = UIImage(named: self.creditImageTitles[0])
    sumiImageView.image = UIImage(named: self.creditImageTitles[1])
    jazeroImageView.image = UIImage(named: self.creditImageTitles[2])
    eunjinImageView.image = UIImage(named: self.creditImageTitles[3])
    juyoungImageView.image = UIImage(named: self.creditImageTitles[4])
    minkyuImageView.image = UIImage(named: self.creditImageTitles[5])
    yenImageView.image = UIImage(named: self.creditImageTitles[6])
    hyunjongImageView.image = UIImage(named: self.creditImageTitles[7])
    keiImageView.image = UIImage(named: self.creditImageTitles[8])
    roksuiImageView.image = UIImage(named: self.creditImageTitles[9])
    peaceImageView.image = UIImage(named: self.creditImageTitles[10])
    gujilImageView.image = UIImage(named: self.creditImageTitles[11])
    jottoImageView.image = UIImage(named: self.creditImageTitles[12])
    mushImageView.image = UIImage(named: self.creditImageTitles[13])
    
    merinLabel.setupLabel(text: self.creditNames[0],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    sumiLabel.setupLabel(text: self.creditNames[1],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    jazeroLabel.setupLabel(text: self.creditNames[2],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    eunjinLabel.setupLabel(text: self.creditNames[3],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    juyoungLabel.setupLabel(text: self.creditNames[4],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    minkyuLabel.setupLabel(text: self.creditNames[5],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    yenLabel.setupLabel(text: self.creditNames[6],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    hyunjongLabel.setupLabel(text: self.creditNames[7],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    keiLabel.setupLabel(text: self.creditNames[8],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    roksuiLabel.setupLabel(text: self.creditNames[9],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    peaceLabel.setupLabel(text: self.creditNames[10],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    gujilLabel.setupLabel(text: self.creditNames[11],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    jottoLabel.setupLabel(text: self.creditNames[12],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
    mushLabel.setupLabel(text: self.creditNames[13],
                          color: .grayText,
                          font: .nanumRoundExtraBold(fontSize: 12))
    
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = true
    navigationView.setUp(title: "지피의 지기들")
  }
}
