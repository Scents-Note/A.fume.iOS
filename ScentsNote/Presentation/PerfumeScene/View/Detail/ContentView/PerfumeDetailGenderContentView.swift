//
//  PerfumeDetailGenderContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PerfumeDetailGenderContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
      return self
    }
    
    var genders: [Gender] = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailGenderContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var genders = BehaviorRelay<[Gender]>(value: [])
  
  private lazy var seasonalPieChartView = SeasonalPieChartView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)).then { $0.type = .gender}
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
    
    let genders = configuration.genders
    let degrees = genders.map { CGFloat($0.percent) }.map {$0 * 36 / 10}
    self.genders.accept(genders)
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
      $0.height.equalTo(70)
      $0.width.equalTo(112)
    }
  }
  
  func bindUI() {
    self.genders
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailSeasonalCell", cellType: PerfumeDetailSeasonalCell.self
      )) { _, gender, cell in
        cell.updateUI(gender: gender)
      }
      .disposed(by: self.disposeBag)
  }
}

extension UICollectionViewListCell {
  func genderConfiguration() -> PerfumeDetailGenderContentView.Configuration {
    PerfumeDetailGenderContentView.Configuration()
  }
}


