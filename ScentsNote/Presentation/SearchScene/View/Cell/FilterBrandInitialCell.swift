//
//  FilterBrandInitialCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class FilterBrandInitialCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  private let initialLabel = UILabel().then { $0.textAlignment = .center}
  
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
    self.contentView.addSubview(self.initialLabel)
    self.initialLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  func updateUI(initial: String, isSelected: Bool) {
    self.initialLabel.text = initial
    self.initialLabel.textColor = isSelected ? .blackText : .grayCd
    self.initialLabel.font = .notoSans(type: isSelected ? .bold : .regular, size: 15)
  }
  
  func clickSeries() -> Observable<UITapGestureRecognizer> {
    self.rx.tapGesture().when(.recognized).asObservable()
  }
}
