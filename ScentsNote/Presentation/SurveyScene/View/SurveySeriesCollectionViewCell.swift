//
//  SurveySeriesCollectionViewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit
import SnapKit
import Then

final class SurveySeriesCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "SurveySeriesCollectionViewCell"
  static let height: CGFloat = 166

  private let imageView = UIImageView().then {
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 50
    $0.contentMode = .scaleAspectFill
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let nameLabel = UILabel().then {
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
    self.contentView.backgroundColor = .white
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.imageView.snp.bottom).offset(12)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.nameLabel.snp.bottom).offset(1)
      $0.bottom.equalToSuperview()
    }
  }
  
  func updateUI(seriesInfo: SurveySeries) {
//    self.imageView.load(url: seriesInfo.imageUrl)
    print("update?")
    self.brandLabel.text = seriesInfo.name
    self.nameLabel.text = seriesInfo.name
  }
}
