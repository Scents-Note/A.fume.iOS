//
//  PerfumeDetailSillageCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class PerfumeDetailSillageCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  static let height: CGFloat = 20
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let progressView = UIProgressView().then {
    $0.progressTintColor = .green
    $0.trackTintColor = .lightGray
    $0.progressViewStyle = .bar
  }
  
  private let sillageLabel = UILabel()
  private let percentLabel = UILabel()
  
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
   
  // MARK: Configure
  func configureUI(){
    self.contentView.addSubview(self.sillageLabel)
    self.sillageLabel.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
    }
    
    self.contentView.addSubview(self.percentLabel)
    self.percentLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
    }
    
    self.contentView.addSubview(self.progressView)
    self.progressView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(80)
      $0.right.equalToSuperview().offset(-54)
      $0.height.equalTo(12)
    }
  }
    
  func updateUI(sillage: Sillage) {
    let isAccent = sillage.isAccent
    self.sillageLabel.do {
      $0.text = sillage.sillage
      $0.textColor = isAccent ? .blackText : .darkGray7d
      $0.font = .systemFont(ofSize: 14, weight: isAccent ? .bold : .regular)
    }
    self.progressView.do {
      $0.progressTintColor = isAccent ? .SNDarkBeige1 : .SNLightBeige1
      $0.setProgress(Float(sillage.percent) / 100, animated: false)
    }
    self.percentLabel.do {
      $0.text = String(sillage.percent) + "%"
      $0.textColor = isAccent ? .blackText : .darkGray7d
      $0.font = .systemFont(ofSize: 14, weight: isAccent ? .bold : .regular)
    }
  }
}

