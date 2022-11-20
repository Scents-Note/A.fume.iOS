//
//  PerfumeDetailSeasonalContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PerfumeDetailSeasonalContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
      return self
    }
    
    var seasonals: [Seasonal] = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailSeasonalContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var seasonals = BehaviorRelay<[Seasonal]>(value: [])
  
  private lazy var seasonalPieChartView = SeasonalPieChartView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.seasonalCompositionalLayout()).then {
    $0.isScrollEnabled = false
    $0.isUserInteractionEnabled = false
    $0.register(PerfumeDetailSeasonalCell.self)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: 0, height: 200)
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.configureUI()
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
    
    let seasonals = configuration.seasonals
    let degrees = seasonals.map { CGFloat($0.percent) }.map {$0 * 36 / 10}
    self.seasonals.accept(seasonals)
    self.seasonalPieChartView.drawPieChart(degrees: degrees)
  }
  
  func configureUI() {
    self.addSubview(self.seasonalPieChartView)
    self.seasonalPieChartView.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
      $0.height.width.equalTo(200)
    }
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.right.bottom.equalToSuperview()
      $0.width.equalTo(100)
      $0.height.equalTo(100)
    }
  }
  
  func bindUI() {
    self.seasonals
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailSeasonalCell", cellType: PerfumeDetailSeasonalCell.self
      )) { _, seasonal, cell in
        cell.updateUI(seasonal: seasonal)
      }
      .disposed(by: self.disposeBag)
  }
}

extension UICollectionViewListCell {
  func seasonalConfiguration() -> PerfumeDetailSeasonalContentView.Configuration {
    PerfumeDetailSeasonalContentView.Configuration()
  }
}


