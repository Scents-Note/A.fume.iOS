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
  static let height: CGFloat = 200
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let percentLabel = UILabel()
  private let barView = UIView()
  private let longevityLabel = UILabel()
  private let durationLabel = UILabel()
  
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
      $0.bottom.equalTo(self.longevityLabel.snp.top)
      $0.centerX.equalToSuperview()
//      $0.left.right.equalToSuperview()
      $0.width.equalTo(25)
      $0.height.equalTo(50)
    }
    
    self.contentView.addSubview(self.percentLabel)
    self.percentLabel.snp.makeConstraints {
//      $0.top.equalToSuperview()
      $0.bottom.equalTo(self.barView.snp.top)
      $0.left.right.equalToSuperview()
//      $0.width.equalTo(50)
    }
  }
    
  func updateUI(longevity: Longevity) {
    self.percentLabel.text = String(longevity.percent) + "%"
//    self.barView.snp.updateConstraints {
//      $0.height.equalTo(longevity.percent * 10)
//    }
    self.barView.backgroundColor = longevity.isAccent ? .SNDarkBeige1 : .SNLightBeige1
    self.longevityLabel.text = longevity.longevity
    self.durationLabel.text = longevity.duration
  }
}
