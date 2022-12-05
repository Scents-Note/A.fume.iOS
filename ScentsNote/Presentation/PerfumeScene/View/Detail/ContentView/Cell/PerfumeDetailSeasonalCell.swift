//
//  PerfumeDetailSeasonalCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import Foundation

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class PerfumeDetailSeasonalCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  static let height: CGFloat = 16
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let colorView = UIView()
  private let seasonLabel = UILabel()
  private let percentLabel = UILabel()
  
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
    self.contentView.addSubview(self.colorView)
    self.colorView.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
      $0.width.height.equalTo(16)
    }
    
    self.contentView.addSubview(self.seasonLabel)
    self.seasonLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.colorView)
      $0.left.equalTo(self.colorView.snp.right)
    }
    
    self.contentView.addSubview(self.percentLabel)
    self.percentLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.colorView)
      $0.right.equalToSuperview()
    }
  }
    
  func updateUI(seasonal: Seasonal) {
    self.colorView.backgroundColor = seasonal.color
    self.seasonLabel.do {
      $0.text = seasonal.season
      $0.textColor = seasonal.isAccent ? .blackText : .darkGray7d
      $0.font = .notoSans(type: seasonal.isAccent ? .bold : .regular, size: 14)
    }
    self.percentLabel.text = String(seasonal.percent) + "%"
  }
}
