//
//  PerfumeDetailKeywordsContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import Then

class PerfumeDetailKeywordsContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var keywords: [String] = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailKeywordsContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var keywords = BehaviorRelay<[String]>(value: [])
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.createCompositionalLayout()).then {
    $0.isScrollEnabled = false
    $0.isUserInteractionEnabled = false
    $0.register(PerfumeDetailKeywordCell.self)
  }
  
  func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(86), heightDimension: .absolute(42))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
    let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

//    layoutGroup.interItemSpacing = .fixed(16)
    let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//    layoutSection.contentInsets = .init(top: 24, leading: 20, bottom: 24, trailing: 20)
//    layoutSection.interGroupSpacing = 16
    
    return UICollectionViewCompositionalLayout(section: layoutSection)
  }
  
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: 0, height: 42)
  }
//
  override func layoutSubviews() {
    super.layoutSubviews()
    self.invalidateIntrinsicContentSize()
  }
//  override func (_ view: UIView) {
//    super.addSubview(view)
////    collectionView.frame = view.bounds
//    let height = collectionView.collectionViewLayout.collectionViewContentSize.height
//    Log(height)
//
//    self.invalidateIntrinsicContentSize()
//  }
  
  
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.bindUI()

//    self.collectionView.sizeToFit()
//    self.collectionView.systemLayoutSizeFitting(CGSize(width: 0, height: 180))
//    self.collectionView.
//    self.collectionView.setNeedsLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    self.keywords.accept(configuration.keywords)
  }
  
  func bindUI() {
    self.keywords
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailKeywordCell", cellType: PerfumeDetailKeywordCell.self
      )) { _, keyword, cell in
        cell.updateUI(keyword: keyword)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func keywordsConfiguration() -> PerfumeDetailKeywordsContentView.Configuration {
    PerfumeDetailKeywordsContentView.Configuration()
  }
}

