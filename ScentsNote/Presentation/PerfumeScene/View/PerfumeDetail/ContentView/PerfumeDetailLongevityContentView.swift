//
//  PerfumeDetailLongevityContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import Then

class PerfumeDetailLongevityContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    var longevities: [Longevity] = []
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailLongevityContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var longevities = BehaviorRelay<[Longevity]>(value: [])
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.longevityCompositionalLayout()).then {
    $0.isUserInteractionEnabled = false
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(PerfumeDetailLongevityCell.self)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 300, height: 120)
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(400)
      $0.height.equalTo(200)
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
    Log(configuration.longevities)
    self.longevities.accept(configuration.longevities)
  }
  
  func bindUI() {
    self.longevities
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailLongevityCell", cellType: PerfumeDetailLongevityCell.self
      )) { _, longevity, cell in
        cell.updateUI(longevity: longevity)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func longevityConfiguration() -> PerfumeDetailLongevityContentView.Configuration {
    PerfumeDetailLongevityContentView.Configuration()
  }
}
