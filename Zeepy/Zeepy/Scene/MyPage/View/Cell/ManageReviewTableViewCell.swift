//
//  ManageReviewTableViewCell.swift
//  Zeepy
//
//  Created by 노한솔 on 2021/07/23.
//

import UIKit

import SnapKit
import Then

// MARK: - ManageReviewTableViewCell
class ManageReviewTableViewCell: UITableViewCell {
  
  // MARK: - Components
  private let containerView = UIView()
  private let addressLabel = UILabel()
  private let dateLabel = UILabel()
  private let lenderTitleLabel = UILabel()
  private let lenderContextLabel = UILabel()
  private let tendencyTitleLabel = UILabel()
  private let tendencyContextLabel = UILabel()
  private let reviewTitleLabel = UILabel()
  private let reviewContextLabel = UILabel()

  // MARK: - LifeCycles
  override func awakeFromNib() {
    super.awakeFromNib()
    configData()
    layout()
  }
}

// MARK: - Extensions
extension ManageReviewTableViewCell {
  
  // MARK: - Layout Helpers
  private func layout() {
    contentView.backgroundColor = .white
    layoutContainerView()
    layoutAddressLabel()
    layoutDateLabel()
    layoutLender()
    layoutTendency()
    layoutReview()
  }
  
  private func layoutContainerView() {
    contentView.add(containerView) {
      $0.backgroundColor = .whiteTextField
      $0.setRounded(radius: 8)
      $0.snp.makeConstraints {
        $0.top.equalTo(self.contentView.snp.top).offset(4)
        $0.bottom.equalTo(self.contentView.snp.bottom).offset(-4)
        $0.leading.trailing.equalToSuperview()
      }
    }
  }
  
  private func layoutAddressLabel() {
    containerView.add(addressLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.containerView.snp.top).offset(16)
        $0.leading.equalTo(self.containerView.snp.leading).offset(12)
      }
    }
  }
  
  private func layoutDateLabel() {
    containerView.add(dateLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.addressLabel.snp.trailing).offset(8)
        $0.centerY.equalTo(self.addressLabel.snp.centerY)
      }
    }
  }
  
  private func layoutLender() {
    containerView.add(lenderTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.addressLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.addressLabel.snp.leading)
      }
    }
    containerView.add(lenderContextLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.lenderTitleLabel.snp.trailing).offset(8)
        $0.centerY.equalTo(self.lenderTitleLabel.snp.centerY)
      }
    }
  }
  
  private func layoutTendency() {
    containerView.add(tendencyTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.lenderTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.addressLabel.snp.leading)
      }
    }
    containerView.add(tendencyContextLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.tendencyTitleLabel.snp.trailing).offset(8)
        $0.centerY.equalTo(self.tendencyTitleLabel.snp.centerY)
      }
    }
  }
  
  private func layoutReview() {
    containerView.add(reviewTitleLabel) {
      $0.snp.makeConstraints {
        $0.top.equalTo(self.tendencyTitleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(self.addressLabel.snp.leading)
        $0.bottom.equalTo(self.containerView.snp.bottom).offset(-18)
      }
    }
    containerView.add(reviewContextLabel) {
      $0.snp.makeConstraints {
        $0.leading.equalTo(self.reviewTitleLabel.snp.trailing).offset(8)
        $0.centerY.equalTo(self.reviewTitleLabel.snp.centerY)
      }
    }
  }
  
  // MARK: - General Helpers
  func dataBind(address: String,
                date: String,
                lender: String,
                tendency: String,
                sound: String,
                bug: String,
                light: String,
                water: String) {
    addressLabel.setupLabel(text: address,
                            color: .blackText,
                            font: .nanumRoundExtraBold(fontSize: 14))
    dateLabel.setupLabel(text: date, color: .grayText, font: .nanumRoundRegular(fontSize: 10))
    lenderContextLabel.setupLabel(text: lender,
                                  color: .blackText,
                                  font: .nanumRoundRegular(fontSize: 12))
    tendencyContextLabel.setupLabel(text: tendency,
                                    color: .blackText,
                                    font: .nanumRoundRegular(fontSize: 12))
    reviewContextLabel.setupLabel(text: "방음 \(sound), 해충 \(bug), 채광 \(light), 수압 \(water)",
                                  color: .blackText,
                                  font: .nanumRoundRegular(fontSize: 12))
  }
  
  private func configData() {
    lenderTitleLabel.setupLabel(text: "임대인", color: .orangeyYellow, font: .nanumRoundExtraBold(fontSize: 12))
    tendencyTitleLabel.setupLabel(text: "임대인 소통성향", color: .orangeyYellow, font: .nanumRoundExtraBold(fontSize: 12))
    reviewTitleLabel.setupLabel(text: "집", color: .orangeyYellow, font: .nanumRoundExtraBold(fontSize: 12))
  }
}