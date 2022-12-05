//
//  ReviewLongevityCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/04.
//

import UIKit
import SnapKit
import Then

final class ReviewLongevityCell: UICollectionViewCell {
  
  private let roundView = UIView().then {
    $0.backgroundColor = .grayCd
    $0.layer.cornerRadius = 4
  }
  
  private let longevityLabel = UILabel().then {
    $0.textColor = .darkGray7d
  }
  
  private let durationLabel = UILabel().then {
    $0.textColor = .darkGray7d
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
//    self.contentView.backgroundColor = .clear
    self.contentView.addSubview(self.roundView)
    self.roundView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(10)
      $0.height.width.equalTo(8)
    }
    
    self.contentView.addSubview(self.longevityLabel)
    self.longevityLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.roundView.snp.centerY).offset(20)
    }
    
    self.contentView.addSubview(self.durationLabel)
    self.durationLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.longevityLabel.snp.bottom).offset(1)
      $0.bottom.equalToSuperview()
    }
  }
  
  func updateUI(longevity: Longevity) {
    let isAccent = longevity.isAccent
    self.longevityLabel.text = longevity.longevity
    self.longevityLabel.font = .notoSans(type: isAccent ? .bold : .regular, size: 14)
    self.durationLabel.text = longevity.duration
    self.durationLabel.font = .notoSans(type: isAccent ? .bold : .regular, size: 11)
    self.roundView.layer.cornerRadius = isAccent ? 8 : 4
    self.roundView.snp.updateConstraints {
      $0.top.equalToSuperview().offset(isAccent ? 6 : 10)
      $0.height.width.equalTo(isAccent ? 16 : 8)
    }
  }
}
