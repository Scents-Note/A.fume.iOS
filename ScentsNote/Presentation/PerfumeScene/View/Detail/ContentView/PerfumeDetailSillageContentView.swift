//
//  PerfumeDetailSillageContentView.swift
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

class PerfumeDetailSillageContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var sillages: [Sillage] = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailSillageContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var sillages = BehaviorRelay<[Sillage]>(value: [])
  
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: self.perfumeDetailCommonCompositionalLayout()).then {
    $0.isUserInteractionEnabled = false
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(PerfumeDetailSillageCell.self)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 0, height: PerfumeDetailSillageCell.height * 3)
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
    guard let configuration = configuration as? Configuration else { return }
    self.sillages.accept(configuration.sillages)
  }
  
  func bindUI() {
    self.sillages
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailSillageCell", cellType: PerfumeDetailSillageCell.self
      )) { _, sillage, cell in
        cell.updateUI(sillage: sillage)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func sillageConfiguration() -> PerfumeDetailSillageContentView.Configuration {
    PerfumeDetailSillageContentView.Configuration()
  }
}
