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
      $0.left.equalTo(self.colorView.snp.right).offset(12)
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
      $0.font = .systemFont(ofSize: 14, weight: seasonal.isAccent ? .bold : .regular)
    }
    self.percentLabel.do {
      $0.text = String(seasonal.percent) + "%"
      $0.textColor = seasonal.isAccent ? .blackText : .darkGray7d
      $0.font = .systemFont(ofSize: 14, weight: seasonal.isAccent ? .bold : .regular)
    }
  }
  
  func updateUI(gender: Gender) {
    self.colorView.backgroundColor = gender.color
    self.seasonLabel.do {
      $0.text = gender.gender
      $0.textColor = gender.isAccent ? .blackText : .darkGray7d
      $0.font = .systemFont(ofSize: 14, weight: gender.isAccent ? .bold : .regular)
    }
    self.percentLabel.do {
      $0.text = String(gender.percent) + "%"
      $0.textColor = gender.isAccent ? .blackText : .darkGray7d
      $0.font = .systemFont(ofSize: 14, weight: gender.isAccent ? .bold : .regular)
    }
  }
}
