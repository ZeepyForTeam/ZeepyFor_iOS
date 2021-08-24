//
//  SubCommentTableViewCell.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/05/23.
//

import UIKit
import RxSwift
class SubCommentTableViewCell: UITableViewCell {
  let disposeBag = DisposeBag()
  private let arrow = UIImageView().then {
    $0.image = UIImage(named: "arrowRight")
  }
  private let userName = UILabel().then {
    $0.setupLabel(text: "", color: .blackText, font: .nanumRoundExtraBold(fontSize: 14))
  }
  private let commentLabel = UILabel().then {
    $0.setupLabel(text: "비밀 댓글입니다.", color: .blackText, font: .nanumRoundRegular(fontSize: 14))
    $0.numberOfLines = 0
  }
  let reportBtn = UIButton().then {
    $0.setupButton(title: "신고", color: .grayText, font: .nanumRoundBold(fontSize: 12), backgroundColor: .clear, state: .normal, radius: 0)
  }
  private let commentedAt = UILabel().then {
    $0.setupLabel(text: "2021.04.23", color: .grayText, font: .nanumRoundRegular(fontSize: 10))
  }
  private let commentView = UIView().then {
    $0.setRounded(radius: 5)
    $0.backgroundColor = .gray249
  }
  private func layout() {
    self.contentView.add(commentView)
    commentView.snp.makeConstraints{
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(28)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-8)
    }
    commentView.adds([arrow,
                           userName,
                           commentLabel,
                           commentedAt,
                           reportBtn])
    arrow.snp.makeConstraints{
      $0.top.leading.equalToSuperview().offset(12)
      $0.width.height.equalTo(18)
    }
    userName.snp.makeConstraints{
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalTo(arrow.snp.trailing).offset(4)
    }
    commentLabel.snp.makeConstraints{
      $0.top.equalTo(arrow.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(13)
      $0.trailing.equalToSuperview().offset(-13)
    }
    commentedAt.snp.makeConstraints{
      $0.top.equalTo(commentLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(12)
      $0.bottom.equalToSuperview().offset(-10)
    }
    reportBtn.snp.makeConstraints{
      $0.top.equalToSuperview().offset(12)
      $0.trailing.equalToSuperview().offset(-12)
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.userName.text = ""
    self.commentLabel.text = ""
    self.commentedAt.text = ""
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  func bindCell(model : CommentSectionModel) {
    self.userName.text = model.userName
    self.commentLabel.text = model.hidden ? "비밀 댓글입니다." : model.comment
    self.commentedAt.text = model.postedAt.asDate(format: .iso8601)?.detailTime
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
