//
//  PerfumeDetailCommonCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class PerfumeDetailCommonCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  let disposeBag = DisposeBag()
  
  private let typeLabel = UILabel().then {
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 14)
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .notoSans(type: .medium, size: 14)
    $0.numberOfLines = 0
    $0.textAlignment = .right
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
    self.contentView.addSubview(self.typeLabel)
    self.typeLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }
    
    self.contentView.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalToSuperview().offset(75)
    }
  }
    
  /// ingredient : type != nil
  /// abundant / price : type == nil
  func updateUI(type: String, content: String) {
    self.contentLabel.text = content
    if type != "empty" {
      self.typeLabel.text = type
    } else {
      self.contentLabel.textColor = .lightGray185
    }
  }
  
  func updateUI(content: String) {
    if content.isEmpty {
      self.contentLabel.textColor = .lightGray185
    }
    self.contentLabel.text = content
  }
}
