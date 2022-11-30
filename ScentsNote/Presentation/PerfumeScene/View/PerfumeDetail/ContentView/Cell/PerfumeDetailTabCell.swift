//
//  PerfumeDetailTabCell.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PerfumeDetailTabCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  private let infoButton = UIButton().then {
    $0.setTitle("향수 정보", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 18)
  }
  private let noteButton = UIButton().then {
    $0.setTitle("시향 노트", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 14)
  }
  
  private lazy var tabView = Tabview(buttons: [self.infoButton, self.noteButton])
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }
  
  private func configureUI() {
    self.contentView.backgroundColor = .white
    
    self.contentView.addSubview(self.tabView)
    self.tabView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
  }
  
  func clickInfoButton() -> Observable<Void> {
    self.infoButton.rx.tap.asObservable()
  }
  
  func clickReviewButton() -> Observable<Void> {
    self.noteButton.rx.tap.asObservable()
  }
}
