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
  private let logoImage = UIImageView().then {
    $0.image = .logoHome
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
    
    self.contentView.addSubview(self.logoImage)
    self.logoImage.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
    }
  }
}
