//
//  PerfumeNewHeaderView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import UIKit
import SnapKit
import Then

final class PerfumeNewHeaderView: UICollectionReusableView {
  
  private let clockImageView = UIImageView().then {
    $0.tintColor = .black
    $0.image = .btnNext
  }
  
  private let updateLabel = UILabel().then {
    $0.text = "매주 수요일 업데이트"
    $0.textColor = .black
    $0.font = .notoSans(type: .regular, size: 14)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI() {
    self.addSubview(self.clockImageView)
    self.clockImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
    }
    
    self.addSubview(self.updateLabel)
    self.updateLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalTo(self.clockImageView.snp.right).offset(4)
    }
  }
}
