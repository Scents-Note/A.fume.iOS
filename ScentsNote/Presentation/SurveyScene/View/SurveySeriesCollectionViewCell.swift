//
//  SurveyKeywordCollectionView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/03.
//

import UIKit
import RxSwift
import RxGesture

final class SurveySeriesCollectionViewCell: UICollectionViewCell {
  
  var clickSeries: (() -> Void)?

  static let identifier = "SurveySeriesCollectionViewCell"
  static let height: CGFloat = 156
  let disposeBag = DisposeBag()

  private let imageBackground = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 50
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.lightGray2.cgColor
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 50
  }
  
  private let selectedBackground = UIView().then {
    $0.backgroundColor = .bgSurveySelected
    $0.layer.cornerRadius = 50
  }
  
  private let heartImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = .heart
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
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
    self.bindUI()
  }
  
  func configureUI(){
    
    self.contentView.addSubview(self.imageBackground)
    self.imageBackground.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    
    self.imageBackground.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    
    self.imageBackground.addSubview(self.selectedBackground)
    self.selectedBackground.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    
    self.imageBackground.addSubview(self.heartImageView)
    self.heartImageView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self.selectedBackground)
      $0.width.height.equalTo(32)
    }

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.imageView.snp.bottom).offset(12)
      $0.left.right.equalToSuperview().inset(10)
    }
  }
  
  func updateUI(series: SurveySeries?) {
    guard let series = series else { return }
    self.imageView.load(url: series.imageUrl)
    self.nameLabel.text = series.name
    self.selectedBackground.isHidden = !series.isLiked!
    self.heartImageView.isHidden = !series.isLiked!
  }
  
  func bindUI() {
    self.imageBackground.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        self?.clickSeries?()
      })
      .disposed(by: self.disposeBag)
  }
}
