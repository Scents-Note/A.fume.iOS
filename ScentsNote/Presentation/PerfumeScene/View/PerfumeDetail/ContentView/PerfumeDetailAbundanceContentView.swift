//
//  PerfumeDetailAbundanceContentView.swift
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

class PerfumeDetailAbundanceContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var abundance: String?
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailAbundanceContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var abundance = BehaviorRelay<[String]>(value: [])
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.perfumeDetailCommonCompositionalLayout()).then {
    $0.register(PerfumeDetailCommonCell.self)
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
      $0.height.equalTo(20)
    }
    
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    let abundance = configuration.abundance ?? ""
    self.abundance.accept([abundance])
  }
  
  func bindUI() {
    self.abundance
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailCommonCell", cellType: PerfumeDetailCommonCell.self
      )) { _, abundance, cell in
        cell.updateUI(content: abundance)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func abundanceConfiguration() -> PerfumeDetailAbundanceContentView.Configuration {
    PerfumeDetailAbundanceContentView.Configuration()
  }
}
