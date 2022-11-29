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
  var viewModel: SearchFilterViewModel
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private lazy var initialCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.brandInitialLayout).then {
    $0.register(FilterBrandInitialCell.self)
  }
  
  private let notyView = UIView().then { $0.backgroundColor = .lightGray2 }
  private let notyLabel = UILabel().then {
    $0.text = "카테고리 당 최대 5개까지 중복 선택 가능합니다."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private lazy var brandCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.filterBrandLayout).then {
    $0.register(FilterBrandCell.self)
  }
  
  // MARK: - Life Cycle
  init(viewModel: SearchFilterViewModel) {
    self.viewModel = viewModel
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
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }

    self.addSubview(self.notyView)
    self.notyView.snp.makeConstraints {
      $0.top.equalTo(self.initialCollectionView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }

    self.notyView.addSubview(self.notyLabel)
    self.notyLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
    self.brandCollectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.brandCollectionView)
    self.brandCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.notyView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    self.initialCollectionView.rx.itemSelected.map { $0.item }
      .subscribe(onNext: { [weak self] pos in
        self?.viewModel.clickBrandInitial(pos: pos)
      })
      .disposed(by: self.disposeBag)
    
    self.brandCollectionView.rx.itemSelected.map { $0.item }
      .subscribe(onNext: { [weak self] pos in
        self?.viewModel.clickBrand(pos: pos)
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel.brandInitials
      .bind(to: self.initialCollectionView.rx.items(cellIdentifier: "FilterBrandInitialCell", cellType: FilterBrandInitialCell.self)) { index, initial, cell in
        cell.updateUI(initial: initial.text, isSelected: initial.isSelected)
      }
      .disposed(by: self.disposeBag)
    
    self.viewModel.brands
      .bind(to: self.brandCollectionView.rx.items(cellIdentifier: "FilterBrandCell", cellType: FilterBrandCell.self)) { index, brand, cell in
        cell.updateUI(brand: brand)
      }
      .disposed(by: self.disposeBag)
  }
}
