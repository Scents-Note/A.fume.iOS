//
//  PerfumeDetailImageCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then
import Cosmos
import Kingfisher

final class PerfumeDetailTitleCell: UICollectionViewCell {
 
  // MARK: - UI
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .pointBeige
    $0.font = .nanumMyeongjo(type: .regular, size: 16)
  }
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .notoSans(type: .bold, size: 24)
  }
  
  private let starView = CosmosView().then {
    $0.settings.starSize = 16
    $0.settings.fillMode = .half
    $0.settings.emptyImage = .starUnfilled
    $0.settings.filledImage = .starFilled
    $0.settings.starMargin = 4
  }
  
  private let scoreLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .regular, size: 14)
  }
  
  private lazy var scoreStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.addArrangedSubview(self.starView)
    $0.addArrangedSubview(self.scoreLabel)
    $0.spacing = 8
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI(){
    self.contentView.addSubview(self.mainImageView)
    self.mainImageView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.width)
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.mainImageView.snp.bottom).offset(33)
      $0.left.right.equalToSuperview().inset(16)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(16)
    }
    
    self.contentView.addSubview(self.scoreStackView)
    self.scoreStackView.snp.makeConstraints {
      $0.top.equalTo(self.nameLabel.snp.bottom).offset(10.5)
      $0.left.equalToSuperview().offset(20)
    }
  }
  
  func updateUI(perfumeDetail: PerfumeDetail) {
    self.mainImageView.kf.setImage(with: URL(string: perfumeDetail.imageUrls[0]))
    self.brandLabel.text = perfumeDetail.brandName
    self.nameLabel.text = perfumeDetail.name
    self.starView.rating = perfumeDetail.score
    self.scoreLabel.text = "\(perfumeDetail.score)"
  }
}
