//
//  HomeRecentCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class HomeRecentCell: UICollectionViewCell {
  
  static let width: CGFloat = 108
  static let height: CGFloat = 157
  
  var disposeBag = DisposeBag()
  
  private let bgView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 54
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let heartButton = UIButton()
  
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
    super.prepareForReuse()
    self.imageView.image = nil
  }
  
  private func configureUI() {
    
    self.contentView.addSubview(self.bgView)
    self.bgView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.width.height.equalTo(108)
    }
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self.bgView)
      $0.width.height.equalTo(89)
    }
    
    self.contentView.addSubview(self.heartButton)
    self.heartButton.snp.makeConstraints {
      $0.bottom.equalTo(self.bgView)
      $0.right.equalTo(self.bgView).offset(-10)
    }

    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.top.equalTo(self.bgView.snp.bottom).offset(7)
      $0.left.equalToSuperview()
    }

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.brandLabel.snp.bottom)
      $0.left.right.equalToSuperview()
    }
  }
  
  func updateUI(perfume: Perfume?) {
    guard let perfume = perfume else { return }
    self.imageView.load(url: perfume.imageUrl)
    self.brandLabel.text = perfume.brandName
    self.nameLabel.text = perfume.name
    self.heartButton.setImage(perfume.isLiked == true ? .favoriteActive : .favoriteInactive, for: .normal)
  }
  
  func onHeartClick() -> Observable<Void> {
    return heartButton.rx.tap.asObservable()
  }
}
