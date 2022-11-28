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
  typealias InitialDataSource = RxCollectionViewSectionedReloadDataSource<FilterSeriesDataSection.Model>
  typealias BrandDataSource = RxCollectionViewSectionedReloadDataSource<FilterSeriesDataSection.Model>
  
  // MARK: - Vars & Lets
  var viewModel: SearchFilterViewModel
  let disposeBag = DisposeBag()
  var initialDataSource: InitialDataSource!
  var brandDataSource: BrandDataSource!
  
  // MARK: - UI
  private lazy var initialCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.filterKeywordLayout).then {
    $0.register(FilterSeriesCell.self)
  }
  
  private let notyView = UIView().then { $0.backgroundColor = .lightGray2 }
  private let notyLabel = UILabel().then {
    $0.text = "카테고리 당 최대 5개까지 중복 선택 가능합니다."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private lazy var brandCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.filterKeywordLayout).then {
    $0.register(FilterSeriesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(FilterSeriesCell.self)
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
    self.configureCollectionView()
    
    self.initialCollectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.initialCollectionView)
    self.initialCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }
    
    self.addSubview(self.notyView)
    self.notyView.snp.makeConstraints {
      $0.top.equalTo(self.brandCollectionView.snp.bottom)
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
  
  private func configureCollectionView() {
    
    self.initialDataSource = InitialDataSource { dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(FilterSeriesCell.self, for: indexPath)
      cell.updateUI(ingredient: item.ingredient)
      cell.clickSeries()
        .subscribe(onNext: {_ in
          self.viewModel.clickSeries(section: indexPath.section, ingredient: item.ingredient)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
    
    self.brandDataSource = BrandDataSource { dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(FilterSeriesCell.self, for: indexPath)
      cell.updateUI(ingredient: item.ingredient)
      cell.clickSeries()
        .subscribe(onNext: {_ in
          self.viewModel.clickSeries(section: indexPath.section, ingredient: item.ingredient)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
  }
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    self.viewModel.output.series
      .bind(to: self.initialCollectionView.rx.items(dataSource: initialDataSource))
      .disposed(by: self.disposeBag)
  }
}
