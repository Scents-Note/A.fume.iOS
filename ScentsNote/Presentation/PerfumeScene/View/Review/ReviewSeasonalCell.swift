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
  var disposeBag = DisposeBag()
  
  let seasonLabel = UILabel()
  
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
    self.seasonLabel.translatesAutoresizingMaskIntoConstraints = false
    self.seasonLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.equalToSuperview().offset(18)
      $0.right.equalToSuperview().offset(-18)
    }
  }
    
  func updateUI(seasonal: Seasonal) {
    let isAccent = seasonal.isAccent
    self.contentView.layer.borderWidth = isAccent ? 0 : 1
    self.seasonLabel.text = seasonal.season
    self.seasonLabel.textColor = isAccent ? .white : .darkGray7d
    self.seasonLabel.font = .notoSans(type: isAccent ? .bold : .regular, size: 14)
  }
}
