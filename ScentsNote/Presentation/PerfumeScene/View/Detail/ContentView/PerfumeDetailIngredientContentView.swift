//
//  PerfumeDetailIngredientContentView.swift
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

class PerfumeDetailIngredientContentView: UIView, UIContentView {
  
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var ingredients: [Ingredient] = []
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailIngredientContentView(self)
    }
  }
  
  let disposeBag = DisposeBag()
  var ingredients = BehaviorRelay<[Ingredient]>(value: [])
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.perfumeDetailCommonCompositionalLayout()).then {
    $0.register(PerfumeDetailCommonCell.self)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: 0, height: ingredients.value.count * 20)
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.collectionView)
    
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    self.ingredients.accept(configuration.ingredients)
  }
  
  func bindUI() {
    self.ingredients
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "PerfumeDetailCommonCell", cellType: PerfumeDetailCommonCell.self
      )) { _, ingredient, cell in
        cell.updateUI(type: ingredient.part, content: ingredient.ingredient)
      }
      .disposed(by: self.disposeBag)
  }

}

extension UICollectionViewListCell {
  func ingredientConfiguration() -> PerfumeDetailIngredientContentView.Configuration {
    PerfumeDetailIngredientContentView.Configuration()
  }
}


