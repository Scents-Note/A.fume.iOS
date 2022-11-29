//
//  FilterSeriesHeaderView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class FilterSeriesHeaderView: UICollectionReusableView {
  
  var disposeBag = DisposeBag()
  
  private let titleLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  private let moreButton = UIButton().then {
    $0.setImage(.checkmark, for: .normal)
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .lightGray }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }
  
  private func configureUI() {
    
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(15)
      $0.left.equalToSuperview().offset(18)
    }
    
    self.addSubview(self.moreButton)
    self.moreButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-18)
    }
    
    self.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(18)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func updateUI(title: String) {
    self.titleLabel.text = title
  }
  
  func clickMoreButton() -> Observable<Void> {
    self.moreButton.rx.tap.asObservable()
  }
}
