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
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.perfumeDetailCommonCompositionalLayout()).then {
    $0.isUserInteractionEnabled = false
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(PerfumeDetailCommonCell.self)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 0, height: prices.value.count * 20)
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
//      $0.height.equalTo(60)
    }
    
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    invalidateIntrinsicContentSize()
    super.layoutSubviews()
    self.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
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
