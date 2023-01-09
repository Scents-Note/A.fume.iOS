//
//  FilterBrandCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class FilterBrandCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()

  private let brandLabel = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = .blackText
    $0.font = .systemFont(ofSize: 15, weight: .regular)
  }
  private let checkButton = UIButton()
  
  private let checkView = UIView()
  private let checkImageView = UIImageView().then {
    $0.image = .checkWhite
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .bgTabBar}
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
    self.checkButton.setImage(nil, for: .normal)
  }
  
  func configureUI(){
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(18)
    }
    
    self.contentView.addSubview(self.checkView)
    self.checkView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-18)
      $0.size.equalTo(22)
    }
    
    self.checkView.addSubview(self.checkImageView)
    self.checkImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func updateUI(brand: FilterBrand) {
    self.brandLabel.text = brand.name
    self.checkView.backgroundColor = brand.isSelected ? .pointBeige : .bgTabBar
  }
  
}
