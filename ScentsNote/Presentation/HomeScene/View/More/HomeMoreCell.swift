//
//  HomeMoreCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class HomeMoreCell: UICollectionViewCell {
  
  
//  let moreImage: UIImage = .btnBack?.withRenderingMode(.alwaysTemplate) ?? UIImage()
  let disposeBag = DisposeBag()
  
  private lazy var moreButton = UIButton().then {
    $0.setTitle("더 보기", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.backgroundColor = .white
    $0.titleLabel?.font = .notoSans(type: .medium, size: 15)
    $0.tintColor = .darkGray7d
    $0.setImage(.btnClose, for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.grayCd.cgColor
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
    
    self.contentView.addSubview(self.moreButton)
    self.moreButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func onMoreClick() -> Observable<Void> {
    return moreButton.rx.tap.asObservable()
  }
}


//self.setTitle("다음", for: .normal)
//self.setTitleColor(.white, for: .normal)
//self.titleLabel?.font = .notoSans(type: .bold, size: 15)
//self.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)
//self.setImage(.btnNext, for: .normal)
//self.contentHorizontalAlignment = .right
//self.layer.backgroundColor = UIColor.blackText.cgColor
//self.semanticContentAttribute = .forceRightToLeft
//self.contentEdgeInsets = .init(top: 0, left: 10, bottom: 34, right: 20)
