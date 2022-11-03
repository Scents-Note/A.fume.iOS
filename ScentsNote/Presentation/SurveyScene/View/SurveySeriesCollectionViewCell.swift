//
//  SurveyKeywordCollectionView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/03.
//

import UIKit

final class SurveySeriesCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "SurveySeriesCollectionViewCell"
  static let height: CGFloat = 188
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 50
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
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100)
    }

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.imageView.snp.bottom).offset(12)
      $0.left.right.equalToSuperview().inset(10)
//      $0.bottom.equalToSuperview().offset(-16)
    }
  }
  
  func updateUI(series: SurveySeries?) {
    guard let series = series else { return }
    self.imageView.load(url: series.imageUrl)
    self.nameLabel.text = series.name
  }
}
