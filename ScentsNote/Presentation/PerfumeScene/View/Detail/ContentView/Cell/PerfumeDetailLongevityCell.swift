//
//  PerfumeDetailLongevityCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class PerfumeDetailLongevityCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  static let height: CGFloat = 160
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let percentLabel = UILabel().then {
    $0.textAlignment = .center
  }
  private let longevityLabel = UILabel().then {
    $0.textAlignment = .center
  }
  private let durationLabel = UILabel().then {
    $0.textAlignment = .center
  }
  
  private let barView = UIView()
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
   
  // MARK: Configure
  func configureUI(){
    self.contentView.addSubview(self.durationLabel)
    self.durationLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview()
    }
    
    self.contentView.addSubview(self.longevityLabel)
    self.longevityLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(self.durationLabel.snp.top)
    }
    
    self.contentView.addSubview(self.barView)
    self.barView.snp.makeConstraints {
      $0.bottom.equalTo(self.longevityLabel.snp.top).offset(-8)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(25)
      $0.height.equalTo(0)
    }
    
    self.contentView.addSubview(self.percentLabel)
    self.percentLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.barView.snp.top).offset(-3)
      $0.left.right.equalToSuperview()
    }
  }
    
  func updateUI(longevity: Longevity) {
    let isAccent = longevity.isAccent
    self.percentLabel.text = String(longevity.percent) + "%"
    self.percentLabel.textColor = isAccent ? .blackText : .darkGray7d
    self.percentLabel.font = .systemFont(ofSize: 14, weight: isAccent ? .bold : .regular)
    self.longevityLabel.text = longevity.longevity
    self.longevityLabel.textColor = isAccent ? .blackText : .darkGray7d
    self.longevityLabel.font = .systemFont(ofSize: 14, weight: isAccent ? .bold : .regular)
    self.durationLabel.text = longevity.duration
    self.durationLabel.textColor = isAccent ? .blackText : .darkGray7d
    self.durationLabel.font = .systemFont(ofSize: 11, weight: isAccent ? .bold : .regular)
    self.barView.backgroundColor = longevity.isAccent ? .SNDarkBeige1 : .pointBeige
    self.barView.snp.updateConstraints {
      $0.height.equalTo(longevity.percent)
    }
  }
}
