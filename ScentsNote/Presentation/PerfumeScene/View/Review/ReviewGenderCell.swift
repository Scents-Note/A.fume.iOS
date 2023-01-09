//
//  ReviewGenderCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import UIKit
import SnapKit
import Then

final class ReviewGenderCell: UICollectionViewCell {
  
  private let roundView = UIView().then {
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.borderWidth = 1
  }
  
  private let desciptionLabel = UILabel().then {
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
    
    self.contentView.addSubview(self.desciptionLabel)
    self.desciptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.roundView.snp.centerY).offset(12)
    }
  }
  
  func updateUI(gender: Gender) {
    let isAccent = gender.isAccent
    self.desciptionLabel.text = gender.gender
    self.desciptionLabel.textColor = isAccent ? .blackText : .darkGray7d
    self.desciptionLabel.font = .notoSans(type: isAccent ? .bold : .regular, size: 14)
    self.roundView.isHidden = gender.gender.count == 0
    self.roundView.backgroundColor = isAccent ? .pointBeige : .grayCd
    self.roundView.layer.cornerRadius = isAccent ? 8 : 4
    self.roundView.snp.updateConstraints {
      $0.top.equalToSuperview().offset(isAccent ? 6 : 10)
      $0.height.width.equalTo(isAccent ? 16 : 8)
    }
  }
  
  func updateUI(sillage: Sillage) {
    let isAccent = sillage.isAccent
    self.desciptionLabel.text = sillage.sillage
    self.desciptionLabel.textColor = isAccent ? .blackText : .darkGray7d
    self.desciptionLabel.font = .notoSans(type: isAccent ? .bold : .regular, size: 14)
    self.roundView.isHidden = sillage.sillage.count == 0
    self.roundView.backgroundColor = isAccent ? .pointBeige : .grayCd
    self.roundView.layer.cornerRadius = isAccent ? 8 : 4
    self.roundView.snp.updateConstraints {
      $0.top.equalToSuperview().offset(isAccent ? 6 : 10)
      $0.height.width.equalTo(isAccent ? 16 : 8)
    }
  }
}
