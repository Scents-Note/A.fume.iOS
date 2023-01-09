//
//  MyPageReviewHeaderView.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/03.
//

import UIKit
import SnapKit
import Then

final class MyPageReviewHeaderCell: UICollectionViewCell {
  
  private let contentLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .systemFont(ofSize: 12, weight: .regular)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI() {
    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(17)
      $0.bottom.equalToSuperview().offset(-26)
    }
  }
  
  func setReviewCount(cnt: Int) {
    self.contentLabel.text = "기록된 향수 \(cnt) 개"
  }
}
