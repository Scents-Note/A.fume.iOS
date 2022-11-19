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
    
    var seasonal: Seasonal?
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailSeasonalContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var seasonals = BehaviorRelay<[SeasonalInfo]>(value: [])
  
  private lazy var seasonalPieChartView = SeasonalPieChartView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
  
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
      CGSize(width: 0, height: 200)
    }
  //
  //  override func layoutSubviews() {
  //    super.layoutSubviews()
  //    self.invalidateIntrinsicContentSize()
  //  }
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
    
//    presentCircleView()
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
    
    let seasonals = configuration.seasonal?.toList() ?? []
    self.seasonals.accept(seasonals)
//    Log(configuration.seasonal?.toList())
    //    self.keywords.accept(configuration.keywords)
    let percents = seasonals.map { $0.percent }
    self.seasonalPieChartView.drawPieChart(degrees: percents.map { $0 * 36 / 10})
  }
  
  func configureUI() {
    self.addSubview(self.seasonalPieChartView)
    self.seasonalPieChartView.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
      $0.height.width.equalTo(200)
    }
    
    //    self.addSubview(self.collectionView)
    //    self.collectionView.snp.makeConstraints {
    //      $0.edges.equalToSuperview()
    //    }
  }
  
  func bindUI() {
    //    self.keywords
    //      .bind(to: self.collectionView.rx.items(
    //        cellIdentifier: "PerfumeDetailKeywordCell", cellType: PerfumeDetailKeywordCell.self
    //      )) { _, keyword, cell in
    //        cell.updateUI(keyword: keyword)
    //      }
    //      .disposed(by: self.disposeBag)
  }
  
}

extension UICollectionViewListCell {
  func seasonalConfiguration() -> PerfumeDetailSeasonalContentView.Configuration {
    PerfumeDetailSeasonalContentView.Configuration()
  }
}


