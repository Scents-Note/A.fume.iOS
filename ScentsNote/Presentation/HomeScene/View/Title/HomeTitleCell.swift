//
//  HomeTitleSection.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import SnapKit
import Then

final class HomeTitleCell: UICollectionViewCell {
  private let titleLabel = UILabel().then {
    $0.text = "Scents Note"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .bold, size: 30)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI() {
    self.backgroundColor = .white
    
    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
    }
  }
}
