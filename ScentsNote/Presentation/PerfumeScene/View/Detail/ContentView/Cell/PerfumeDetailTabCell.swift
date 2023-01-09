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
  
  enum TabType:Int, Equatable {
    case info
    case note
  }
  
  var disposeBag = DisposeBag()
  
  private let infoButton = UIButton().then {
    $0.setTitle("향수 정보", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 16)
  }
  private let noteButton = UIButton().then {
    $0.setTitle("시향 노트", for: .normal)
    $0.setTitleColor(.darkGray7d, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 16)
  }
  
  private let highlightView = UIView().then {
    $0.backgroundColor = .black
  }
  
  private lazy var tabView = Tabview(buttons: [self.infoButton, self.noteButton], highlight: self.highlightView)
  
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
  
  func updateUI(type: PerfumeDetailTabCell.TabType) {
    self.highlightView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * CGFloat(type.rawValue) / 2, y: 0)
    self.infoButton.titleLabel?.font = .notoSans(type: type == .info ? .bold : .regular, size: 16)
    self.infoButton.setTitleColor(type == .info ? .blackText : .darkGray7d, for: .normal)
    self.noteButton.titleLabel?.font = .notoSans(type: type == .info ? .regular : .bold, size: 16)
    self.noteButton.setTitleColor(type == .info ? .darkGray7d : .blackText, for: .normal)
  }
  
  func clickInfoButton() -> Observable<Void> {
    self.infoButton.rx.tap.asObservable()
  }
  
  func clickReviewButton() -> Observable<Void> {
    self.noteButton.rx.tap.asObservable()
  }
}
