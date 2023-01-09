//
//  MenuCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit
import SnapKit
import Then

final class MenuCell: UICollectionViewCell {
  
  // MARK: - UI
  private let menuLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  private let dividerView = UILabel().then { $0.backgroundColor = .lightGray }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.contentView.addSubview(self.menuLabel)
    self.menuLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().inset(16)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(1)
    }
  }
  
  func updateUI(menu: String) {
    self.menuLabel.text = menu
  }
}
