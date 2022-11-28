//
//  FilterSeriesView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources

final class FilterSeriesView: UIView {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<FilterSeriesDataSection.Model>
  
  // MARK: - Vars & Lets
  var viewModel: SearchFilterViewModel
  let disposeBag = DisposeBag()
  private var dataSource: DataSource!
  
  let series = BehaviorRelay<[FilterIngredient]>(value: [])
  
  
  // MARK: - UI
  private let notyView = UIView().then { $0.backgroundColor = .lightGray2 }
  private let notyLabel = UILabel().then {
    $0.text = "카테고리 당 최대 5개까지 중복 선택 가능합니다."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.filterKeywordLayout).then {
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
    
    self.addSubview(self.notyView)
    self.notyView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }
    
    self.notyView.addSubview(self.notyLabel)
    self.notyLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
//    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.notyView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func configureCollectionView() {
    
    self.dataSource = DataSource(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = self.collectionView.dequeueReusableCell(FilterSeriesCell.self, for: indexPath)
        cell.updateUI(ingredient: item.ingredient)
        cell.clickSeries()
          .subscribe(onNext: {_ in
            self.viewModel.clickSeries(section: indexPath.section, ingredient: item.ingredient)
          })
          .disposed(by: cell.disposeBag)
        return cell
      }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let section = collectionView.dequeueReusableHeaderView(FilterSeriesHeaderView.self, for: indexPath)
        let title = dataSource.sectionModels[indexPath.section].model
        section.updateUI(title: title)
        section.clickMoreButton()
          .subscribe(onNext: {
            self.viewModel.clickSeriesMoreButton(section: indexPath.section)
          })
          .disposed(by: section.disposeBag)
        return section
      })
  }
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    self.viewModel.seriesDataSource
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}
