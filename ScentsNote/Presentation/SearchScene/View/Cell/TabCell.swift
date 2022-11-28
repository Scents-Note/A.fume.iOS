//
//  TabCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

final class TabCell: UICollectionViewCell {
    
  static let height: CGFloat = 48
  static let identifier = "TabCell"
  var disposeBag = DisposeBag()
  
  private let nameLabel = UILabel().then {
    $0.textColor = .blackText
    $0.font = .notoSans(type: .bold, size: 14)
  }
  
  private let countLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .notoSans(type: .regular, size: 11)
    $0.backgroundColor = .blackText
    $0.textAlignment = .center
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 9
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
   
  func configureUI(){
    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(12)
    }
    
    self.contentView.addSubview(self.countLabel)
    self.countLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.left.equalTo(self.nameLabel.snp.right).offset(4)
      $0.width.height.equalTo(18)
    }
  }
    
  func updateUI(searchTab: SearchTab) {
    self.nameLabel.text = searchTab.name
    self.countLabel.text = String(searchTab.count)
  }
  
  func onTabClick() -> Observable<UITapGestureRecognizer>  {
    return self.contentView.rx.tapGesture().when(.recognized)
  }
}
