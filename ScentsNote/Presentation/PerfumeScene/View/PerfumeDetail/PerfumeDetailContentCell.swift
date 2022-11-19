//
//  PerfumeDetailContentCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then

final class PerfumeDetailContentCell: UICollectionViewCell {
  
  private let infoButton = UIButton().then {
    $0.setTitle("향수 정보", for: .normal)
  }
  
  private let noteButton = UIButton().then {
    $0.setTitle("시향 노트", for: .normal)
  }
  
  private lazy var tabStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    
    $0.addArrangedSubview(self.infoButton)
    $0.addArrangedSubview(self.noteButton)
  }
  
  private let dividerView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  private let highlightView = UIView().then {
    $0.backgroundColor = .black
  }
  
  private let detailScrollView = PerfumeDetailScrollView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI() {
    self.isUserInteractionEnabled = false

    self.contentView.addSubview(self.tabStackView)
    self.tabStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalTo(self.tabStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.contentView.addSubview(self.highlightView)
    self.highlightView.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width / 2)
      $0.bottom.equalTo(self.dividerView)
      $0.height.equalTo(4)
    }
    
    self.contentView.addSubview(self.detailScrollView)
    self.detailScrollView.snp.makeConstraints {
      $0.top.equalTo(self.dividerView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  func updateUI(perfuemDetail: PerfumeDetail) {
    self.detailScrollView.updateUI(perfumeDetail: perfuemDetail)
  }
}
