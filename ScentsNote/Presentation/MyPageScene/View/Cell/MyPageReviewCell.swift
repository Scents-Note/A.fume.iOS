//
//  MyPageReviewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class MyPageReviewCell: UICollectionViewCell {
  
  // MARK: - Input
  var onClickReview: ((Int) -> Void)?
  
  // MARK: - Var & Let
  var disposeBag = DisposeBag()
  var reviewIdx = 0
  
  // MARK: - UI
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private let brandLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .notoSans(type: .medium, size: 15)
  }

  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
    self.reviewIdx = 0
  }
   
  // MARK: Configure
  private func configureUI() {
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.height.equalTo(100)
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageView.snp.bottom).offset(26)
      $0.left.right.equalToSuperview().inset(7)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom)
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(7)
    }
  }
    
  func updateUI(review: ReviewInMyPage) {
    self.imageView.load(url: review.imageUrl)
    self.brandLabel.text = review.brand
    self.nameLabel.text = review.perfume
    self.reviewIdx = review.reviewIdx
  }
  
  private func bindUI() {
    self.contentView.rx.tapGesture().when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.onClickReview?(self.reviewIdx)
      })
      .disposed(by: self.disposeBag)
  }
}
