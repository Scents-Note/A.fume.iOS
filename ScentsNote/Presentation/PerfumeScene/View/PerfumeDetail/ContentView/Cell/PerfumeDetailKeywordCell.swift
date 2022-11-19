//
//  PerfumeDetailKeywordCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class PerfumeDetailKeywordCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  let disposeBag = DisposeBag()
  static let height: CGFloat = 42
  
  private let keywordLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
   
  // MARK: Configure
  func configureUI(){
    self.contentView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(18)
      $0.height.equalTo(42)
    }
  }
    
  func updateUI(keyword: String) {
    self.keywordLabel.text = keyword
  }
}
