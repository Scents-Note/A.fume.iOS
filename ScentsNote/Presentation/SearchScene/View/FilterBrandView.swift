//
//  FilterBrandView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources

final class FilterBrandView: UIView {
  
  // MARK: - Vars & Lets
  var viewModel: SearchFilterBrandViewModel
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private lazy var initialCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.brandInitialLayout).then {
    $0.register(FilterBrandInitialCell.self)
  }
  
  private lazy var brandCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.filterBrandLayout).then {
    $0.register(FilterBrandCell.self)
  }
  
  // MARK: - Life Cycle
  init(viewModel: SearchFilterViewModel) {
    self.viewModel = SearchFilterBrandViewModel(filterDelegate: viewModel,
                                                fetchBrandsForFilterUseCase: DefaultFetchBrandsForFilterUseCase(filterRepository: DefaultFilterRepository.shared))
    super.init(frame: .zero)
    self.configureUI()
    self.bindViewModel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    
    self.initialCollectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.initialCollectionView)
    self.initialCollectionView.snp.makeConstraints {
        $0.top.leading.bottom.equalToSuperview()
      $0.width.equalTo(48)
    }
    
    self.brandCollectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.brandCollectionView)
    self.brandCollectionView.snp.makeConstraints {
        $0.top.bottom.trailing.equalToSuperview()
        $0.leading.equalTo(initialCollectionView.snp.trailing)
    }
  }
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.initialCollectionView.rx.itemSelected.map { $0.item }
      .subscribe(onNext: { idx in
        input.brandInitialCellDidTapEvent.accept(idx)
      })
      .disposed(by: self.disposeBag)
    
    self.brandCollectionView.rx.itemSelected.map { $0.item }
      .subscribe(onNext: { idx in
        input.brandCellDidTapEvent.accept(idx)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    output.brandInitials
      .bind(to: self.initialCollectionView.rx.items(cellIdentifier: "FilterBrandInitialCell", cellType: FilterBrandInitialCell.self)) { index, initial, cell in
        cell.updateUI(initial: initial.text, isSelected: initial.isSelected)
      }
      .disposed(by: self.disposeBag)

    output.brands
      .bind(to: self.brandCollectionView.rx.items(cellIdentifier: "FilterBrandCell", cellType: FilterBrandCell.self)) { index, brand, cell in
        cell.updateUI(brand: brand)
      }
      .disposed(by: self.disposeBag)
  }
}
