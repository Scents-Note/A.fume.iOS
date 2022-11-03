//
//  SurveyKeywordCollectionViewCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/03.
//

import UIKit

final class SurveyKeywordCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "SurveyKeywordCollectionViewCell"
  static let height: CGFloat = 42
  
  private let keywordLabel = UILabel().then {
    $0.textColor = .grayCd
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
  
  func configureUI(){
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.grayCd.cgColor
    
    self.contentView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(18)
    }
  }
    
  func updateUI(keyword: SurveyKeyword?) {
    guard let keyword = keyword else { return }
    self.keywordLabel.text = "#"+keyword.name
  }
}
