//
//  TitleHeaderView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import SnapKit
import Then

final class HomeHeaderView: UICollectionReusableView {
  
  private let underLineView = UIView().then {
    $0.backgroundColor = .blackText
  }
  
  private let titleLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .extraBold, size: 18)
    $0.numberOfLines = 0
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .appleSDGothic(type: .regular, size: 14)
    $0.numberOfLines = 0
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.underLineView.isHidden = false
    self.contentLabel.isHidden = false
  }
  
  private func configureUI() {
    self.addSubview(self.underLineView)
    self.underLineView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
      $0.width.equalTo(18)
      $0.height.equalTo(1)
    }
    
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.left.equalToSuperview().offset(20)
    }
    
    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview()
    }
  }
  
  func updateUI(title: String, content: String?) {
    self.titleLabel.text = title
    guard let content = content else {
      self.titleLabel.snp.updateConstraints {
        $0.top.equalToSuperview().offset(24)
        $0.left.equalToSuperview().offset(0)
      }
      self.underLineView.isHidden = true
      self.contentLabel.isHidden = true
      return
    }
    self.titleLabel.snp.updateConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.left.equalToSuperview().offset(20)
    }
    self.contentLabel.text = content
    
  }
}
