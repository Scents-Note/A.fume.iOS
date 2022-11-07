//
//  PerfumeRecommandKeywordCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import RxSwift
import RxGesture

final class HomeRecommendationKeywordCell: UICollectionViewCell {
  
  var clickKeyword: (() -> Void)?
  
  static let identifier = "PerfumeRecommandKeywordCell"
  static let height: CGFloat = 26
  let disposeBag = DisposeBag()
  
  private let keywordLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .notoSans(type: .regular, size: 12)
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
    self.backgroundColor = .bgSurveySelected

    self.contentView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(10)
    }
  }
    
  func updateUI(name: String) {
    self.keywordLabel.text = "#" + name
  }
}
