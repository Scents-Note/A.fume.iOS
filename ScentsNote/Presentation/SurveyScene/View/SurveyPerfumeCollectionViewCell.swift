//
//  SurveySeriesCollectionViewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/01.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

final class SurveyPerfumeCollectionViewCell: UICollectionViewCell {
  
  var clickPerfume: (() -> Void)?

  static let identifier = "SurveyPerfumeCollectionViewCell"
  static let height: CGFloat = 188
  private let disposeBag = DisposeBag()
    
  private let imageBackground = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 50
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.lightGray2.cgColor
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let selectedBackground = UIView().then {
    $0.backgroundColor = .bgSurveySelected
    $0.layer.cornerRadius = 50
  }
  
  private let heartImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = .heart
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
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
    self.bindUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView.image = nil
    self.selectedBackground.isHidden = true
    self.heartImageView.isHidden = true
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
      $0.centerX.centerY.equalTo(self.imageBackground)
      $0.width.height.equalTo(84)
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
    }
    
  }
  
  func updateUI(perfume: Perfume?) {
    guard let perfume = perfume else { return }
    self.imageView.load(url: perfume.imageUrl)
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
    self.selectedBackground.isHidden = !perfume.isLiked
    self.heartImageView.isHidden = !perfume.isLiked
  }
  
  
  func bindUI() {
    self.imageBackground.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        self?.clickPerfume?()
      })
      .disposed(by: self.disposeBag)
  }
  
}
