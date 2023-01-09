//
//  ReviewSeasonalCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class ReviewSeasonalCell: UICollectionViewCell {
  
  static let identifier = "SurveyKeywordCollectionViewCell"
  static let height: CGFloat = 42
  private var disposeBag = DisposeBag()
  
  private let seasonLabel = UILabel()
  private let checkImageView = UIImageView()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }

  func configureUI(){
    self.contentView.layer.borderColor = UIColor.grayCd.cgColor
    self.contentView.addSubview(self.seasonLabel)
    self.seasonLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(16)
    }
    
    self.contentView.addSubview(self.checkImageView)
    self.checkImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-18)
    }
    
    
  }
    
  func updateUI(seasonal: Seasonal) {
    let isAccent = seasonal.isAccent
    self.contentView.layer.borderWidth = isAccent ? 0 : 1
    self.contentView.backgroundColor = isAccent ? .pointBeige : .white
    self.seasonLabel.text = seasonal.season
    self.seasonLabel.textColor = isAccent ? .white : .darkGray7d
    self.seasonLabel.font = .systemFont(ofSize: 14, weight: isAccent ? .bold : .regular)
    self.checkImageView.image = isAccent ? .checkWhite : .checkGray
  }
}
