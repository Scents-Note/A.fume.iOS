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
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
    $0.numberOfLines = 0
  }
  
//  private lazy var verticalStackView = UIStackView().then {
//    $0.axis = .vertical
//    $0.spacing = 12
//    $0.addArrangedSubview(self.underLineView)
//    $0.addArrangedSubview(self.titleLabel)
//    $0.addArrangedSubview(self.contentLabel)
//  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  required init?(coder: NSCoder) {
    fatalError()
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
      $0.top.equalTo(self.underLineView.snp.bottom).offset(12)
      $0.left.equalToSuperview().offset(20)
    }
    
    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
//      $0.bottom.equalToSuperview().offset(-23)
      $0.left.equalToSuperview().offset(20)
    }
  }
  
  func updateUI(title: String, content: String) {
    self.titleLabel.text = title
    self.contentLabel.text = content
  }
}
