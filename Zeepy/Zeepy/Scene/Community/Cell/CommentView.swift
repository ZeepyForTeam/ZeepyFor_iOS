//
//  CommentView.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/23.
//

import Foundation
import UIKit
class CommentView : UITableViewHeaderFooterView , Identifiable {
  let profileBtn = UIButton().then {
    $0.setRounded(radius: 10)
    $0.backgroundColor = .gray196
  }
  let userName = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  let userTag = UILabel().then{
    $0.isHidden = true
    $0.setupLabel(text: "글쓴이", color: .communityGreen, font: .nanumRoundExtraBold(fontSize: 14))
  }
  let commentLabel = UILabel().then {
    $0.setupLabel(text: "비밀 댓글입니다.", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
    $0.numberOfLines = 0
  }
  let commentedAt = UILabel().then {
    $0.setupLabel(text: "2021.04.23", color: .grayText, font: .nanumRoundRegular(fontSize: 10))
  }
  let addSubcommentBtn = UIButton().then {
    $0.setImageByName("iconChat")
  }
  let reportOrModifyBtn = UIButton().then {
    $0.setupButton(title: "신고", color: .grayText, font: .nanumRoundBold(fontSize: 12), backgroundColor: .clear, state: .normal, radius: 0)
  }
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.setRounded(radius: 5)
    $0.borderWidth = 1
    $0.borderColor = .gray228
  }
  private func layout() {
    self.tintColor = .white
    self.contentView.add(containerView)
    containerView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-8)
    }
    containerView.adds([profileBtn,
                        userName,
                        userTag,
                        commentLabel,
                        commentedAt,
                        addSubcommentBtn,
                        reportOrModifyBtn])
    profileBtn.snp.makeConstraints{
      $0.top.equalToSuperview().offset(9)
      $0.leading.equalToSuperview().offset(12)
      $0.width.height.equalTo(20)
    }
    userName.snp.makeConstraints{
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalTo(profileBtn.snp.trailing).offset(4)
    }
    userTag.snp.makeConstraints{
      $0.centerY.equalTo(userName)
      $0.leading.equalTo(userName.snp.trailing).offset(8)
    }
    commentLabel.snp.makeConstraints{
      $0.top.equalTo(profileBtn.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(13)
      $0.trailing.equalToSuperview().offset(-13)
    }
    commentedAt.snp.makeConstraints{
      $0.top.equalTo(commentLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(12)
      $0.bottom.equalToSuperview().offset(-10)
    }
    addSubcommentBtn.snp.makeConstraints{
      $0.trailing.equalToSuperview().offset(-12)
      $0.top.equalToSuperview().offset(12)
      $0.width.height.equalTo(16)
    }
    reportOrModifyBtn.snp.makeConstraints{
      $0.centerY.equalTo(addSubcommentBtn)
      $0.trailing.equalTo(addSubcommentBtn.snp.leading).offset(4)
    }
  }
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    layout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    userName.text = ""
    commentLabel.text = ""
    commentedAt.text = ""
  }
}
