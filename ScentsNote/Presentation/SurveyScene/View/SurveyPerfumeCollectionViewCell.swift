//
//  SurveySeriesCollectionViewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit
import SnapKit
import Then

final class SurveyPerfumeCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "SurveyPerfumeCollectionViewCell"
  static let height: CGFloat = 188

  private let imageBackground = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 50
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.lightGray2.cgColor
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let nameLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.textColor = .blackText
    $0.font = .notoSans(type: .regular, size: 12)
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
  
  func configureUI(){
    self.contentView.addSubview(self.imageBackground)
    self.imageBackground.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self.imageBackground)
      $0.width.height.equalTo(84)
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.imageBackground.snp.bottom).offset(12)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(1)
      $0.left.right.equalToSuperview().inset(10)
//      $0.bottom.equalToSuperview().offset(-16)
    }
  }
  
  func updateUI(perfume: SurveyPerfume?) {
    guard let perfume = perfume else { return }
    self.imageView.load(url: perfume.imageUrl)
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
  }
}
