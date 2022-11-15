//
//  HomeNewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class HomeNewCell: UICollectionViewCell {
  
  var clickHeart: (() -> Void)?
  
  static let width: CGFloat = 146
  static let height: CGFloat = 198
  
  var disposeBag = DisposeBag()

  private let bgView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.bgTabBar.cgColor
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let heartButton = UIButton()
  
  private let brandLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private let nameLabel = UILabel().then {
    $0.textColor = .black1d
    $0.font = .notoSans(type: .medium, size: 16)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
    self.imageView.image = nil
    self.brandLabel.text = ""
    self.nameLabel.text = ""
  }
  
  private func configureUI() {
    
    self.contentView.addSubview(self.bgView)
    self.bgView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(self.snp.width)
    }
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self.bgView)
      $0.width.height.equalTo(143)
    }
    
    self.contentView.addSubview(self.heartButton)
    self.heartButton.snp.makeConstraints {
      $0.bottom.right.equalTo(self.bgView).offset(-8)
    }

    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.bgView.snp.bottom).offset(10)
      $0.left.right.equalToSuperview()
    }

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom)
      $0.left.right.equalToSuperview()
    }
  }
  
  func updateUI(perfume: Perfume?) {
    guard let perfume = perfume else { return }
    self.imageView.kf.setImage(with: URL(string: perfume.imageUrl))
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
    self.heartButton.setImage(perfume.isLiked == true ? .favoriteActive : .favoriteInactive, for: .normal)
  }
  
  func onPerfumeClick() -> Observable<UITapGestureRecognizer> {
    return self.contentView.rx.tapGesture().when(.recognized)
  }
  
  func onHeartClick() -> Observable<Void> {
    return self.heartButton.rx.tap.asObservable()
  }
  

}
