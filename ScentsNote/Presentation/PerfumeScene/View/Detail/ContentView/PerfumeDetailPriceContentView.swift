//
//  PerfumeDetailPriceContentView.swift
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

class PerfumeDetailPriceContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var prices: [String]?
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailPriceContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var prices = BehaviorRelay<[String]>(value: [])
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.perfumeDetailCommonCompositionalLayout()).then {
    $0.backgroundColor = .white
    $0.register(PerfumeDetailCommonCell.self)
    $0.isScrollEnabled = false
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
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
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 0, height: prices.value.count * 20)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.invalidateIntrinsicContentSize()
//    self.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    let prices = configuration.prices ?? []
    self.prices.accept(prices)
  }
  
  func bindUI() {
    self.prices
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailCommonCell", cellType: PerfumeDetailCommonCell.self
      )) { _, price, cell in
        cell.updateUI(content: price)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func priceConfiguration() -> PerfumeDetailPriceContentView.Configuration {
    PerfumeDetailPriceContentView.Configuration()
  }
}
