//
//  KeywordCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class KeywordCell: UICollectionViewCell {
    
  static let height: CGFloat = 32
  static let width: CGFloat = 100
  var disposeBag = DisposeBag()
  
  private let containerView = UIView().then {
    $0.backgroundColor = .SNLightBeige1
    $0.layer.cornerRadius = 16
  }
  
  private let keywordLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .notoSans(type: .regular, size: 14)
  }
  
  private let deleteButton = UIButton().then {
    $0.setImage(.btnCancelWhite, for: .normal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layer.masksToBounds = true
  }
   
  func configureUI(){
    self.contentView.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(32)
    }
    
    self.containerView.addSubview(self.keywordLabel)
    self.keywordLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(14)
    }
    
    self.containerView.addSubview(self.deleteButton)
    self.deleteButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalTo(self.keywordLabel.snp.right).offset(5)
      $0.right.equalToSuperview().offset(-12)
    }
  }
    
  func updateUI(keyword: SearchKeyword) {
    self.keywordLabel.text = keyword.name
  }
  
  func onDeleteClick() -> Observable<Void> {
    return self.deleteButton.rx.tap.asObservable()
  }
}
