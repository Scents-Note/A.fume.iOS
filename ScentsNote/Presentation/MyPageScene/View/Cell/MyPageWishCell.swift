//
//  MyPageWishCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then
import Kingfisher

final class MyPageWishCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let imageContainerView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.bgTabBar.cgColor
    $0.backgroundColor = .lightGray
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .systemFont(ofSize: 12, weight: .regular)
  }
  
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .systemFont(ofSize: 15, weight: .medium)
  }
  
  private let reviewButton = UIButton().then {
    $0.setImage(.pen, for: .normal)
    $0.setTitle("시향 노트 쓰기", for: .normal)
    $0.setTitleColor(.SNDarkBeige1, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
  }
  
  private let imageView = UIImageView().then { $0.contentMode = .scaleAspectFit}
  private let dividerView = UIView().then { $0.backgroundColor = .lightGray }
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }
   
  // MARK: Configure
  func configureUI() {
    self.contentView.addSubview(self.imageContainerView)
    self.imageContainerView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(16)
      $0.width.height.equalTo(86)
    }
    
    self.imageContainerView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.height.equalTo(74)
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageContainerView)
      $0.left.equalTo(self.imageContainerView.snp.right).offset(16)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(4)
      $0.left.equalTo(self.brandLabel)
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.contentView.addSubview(self.reviewButton)
    self.reviewButton.snp.makeConstraints {
      $0.bottom.equalTo(self.imageContainerView)
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalTo(self.imageContainerView.snp.bottom).offset(16)
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
  }
    
  func updateUI(perfume: PerfumeInMyPage) {
    self.imageView.kf.setImage(with: URL(string: perfume.imageUrl))
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
  }
  
  func clickPerfume() -> Observable<UITapGestureRecognizer> {
    self.contentView.rx.tapGesture().when(.recognized).asObservable()
  }
  
  func clickReview() -> Observable<Void> {
    self.reviewButton.rx.tap.asObservable()
  }
}
