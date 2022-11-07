//
//  HomeTitleHeaderView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import SnapKit
import Then

final class HomeTitleHeaderView: UICollectionReusableView {
  
  private let titleLabel = UILabel().then {
    $0.text = "최근 찾아본 향수"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .extraBold, size: 18)
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI() {
    
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
    }
  }
  

}

