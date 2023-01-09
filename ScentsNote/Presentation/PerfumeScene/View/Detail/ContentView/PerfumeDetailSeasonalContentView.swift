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
  
  private lazy var seasonalPieChartView = SeasonalPieChartView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)).then { $0.type = .seasonal}
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.seasonalCompositionalLayout()).then {
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
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    
    let seasonals = configuration.seasonals
    let degrees = self.getDegrees(seasonals: seasonals)
    self.seasonals.accept(seasonals)
    self.seasonalPieChartView.drawPieChart(degrees: degrees)
  }
  
  func configureUI() {
    self.backgroundColor = .white
    self.addSubview(self.seasonalPieChartView)
    self.seasonalPieChartView.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
      $0.height.width.equalTo(150)
    }
    
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.right.bottom.equalToSuperview()
      $0.height.equalTo(100)
      $0.width.equalTo(112)
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
  
  func getDegrees(seasonals: [Seasonal]) -> [CGFloat] {
    var list: [CGFloat] = []
    var total = 0
    for (idx, seasonal) in seasonals.enumerated() {
      if idx == seasonals.count - 1 {
        /// 마지막 index제외 0이 아닌게 있거나, 마지막 인덱스가 0이 아니거나
        if seasonal.percent != 0 || total != 0 {
          list += [CGFloat(100 - total) * 36 / 10]
        } else {
          list += [CGFloat(0)]
        }
      } else {
        total += seasonal.percent
        list += [CGFloat(seasonal.percent) * 36 / 10]
      }
    }
    return list
  }
}

extension UICollectionViewListCell {
  func seasonalConfiguration() -> PerfumeDetailSeasonalContentView.Configuration {
    PerfumeDetailSeasonalContentView.Configuration()
  }
}


