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

  private let brandLabel = UILabel().then { $0.textAlignment = .center}
  private let checkButton = UIButton()
  private let dividerView = UIView().then { $0.backgroundColor = .black}
  
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
  }
  
  func configureUI(){
    self.contentView.addSubview(self.brandLabel)
    self.brandLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(18)
    }
    
    self.contentView.addSubview(self.checkButton)
    self.checkButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-18)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func updateUI(brand: FilterBrand) {
    self.brandLabel.text = brand.name
    self.checkButton.setImage(brand.isSelected ? .checkmark : .btnNext, for: .normal)
  }
  
//  func clickSeries() -> Observable<UITapGestureRecognizer> {
//    self.rx.tapGesture().when(.recognized).asObservable()
//  }
}
