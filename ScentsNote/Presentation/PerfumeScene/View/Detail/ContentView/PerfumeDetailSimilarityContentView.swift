//
//  PerfumeDetailSimilarityContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import Then

class PerfumeDetailSimilarityContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var clickPerfume: ((Perfume) -> Void)?
    var perfumes: [Perfume]? = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailSimilarityContentView(self)
    }
  }
  
  var clickPerfume: ((Perfume) -> Void)?
  
  let disposeBag = DisposeBag()
  var perfumes = BehaviorRelay<[Perfume]>(value: [])
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.similarityCompositionalLayout()).then {
    $0.showsHorizontalScrollIndicator = false
    $0.register(HomePopularityCell.self)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 0, height: 250)
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    invalidateIntrinsicContentSize()
    super.layoutSubviews()
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration, let perfumes = configuration.perfumes else { return }
    self.perfumes.accept(perfumes)
    self.clickPerfume = configuration.clickPerfume
  }
  
  func bindUI() {
    self.perfumes
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "HomePopularityCell", cellType: HomePopularityCell.self
      )) { _, perfume, cell in
        cell.updateUI(perfume: perfume)
        cell.hideHeart()
      }
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.itemSelected.map { $0.row }.asObservable()
      .subscribe(onNext: { [weak self] idx in
        guard let self = self else { return }
        let perfume = self.perfumes.value[idx]
        self.clickPerfume?(perfume)
      })
      .disposed(by: self.disposeBag)

  }

}

extension UICollectionViewListCell {
  func similarityConfiguration() -> PerfumeDetailSimilarityContentView.Configuration {
    PerfumeDetailSimilarityContentView.Configuration()
  }
}
