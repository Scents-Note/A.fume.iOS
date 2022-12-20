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

final class MyPageWishCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let imageContainerView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.backgroundColor = .SNDarkBeige1
  }
  
  private let brandLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let nameLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .medium, size: 15)
  }
  
  private let reviewButton = UIButton().then {
    $0.setTitle("시향 노트 쓰기", for: .normal)
    $0.setTitleColor(.pointBeige, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 14)
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
      $0.top.left.equalToSuperview()
      $0.width.height.equalTo(86)
    }
    
    self.imageContainerView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.height.equalTo(74)
    }
    
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.right.equalToSuperview()
      $0.left.equalTo(self.imageContainerView.snp.right).offset(16)
    }
    
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom).offset(1)
      $0.left.equalTo(self.brandLabel)
      $0.right.equalToSuperview()
    }
    
    self.contentView.addSubview(self.reviewButton)
    self.reviewButton.snp.makeConstraints {
      $0.bottom.equalTo(self.imageContainerView)
      $0.right.equalToSuperview()
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalTo(self.imageContainerView.snp.bottom).offset(16)
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
  }
    
  func updateUI(perfume: PerfumeInMyPage) {
    self.imageView.load(url: perfume.imageUrl)
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
  }
  
  func clickPerfume() -> Observable<UITapGestureRecognizer> {
    self.contentView.rx.tapGesture().when(.recognized).asObservable()
  }
}
