//
//  SearchFilterViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import RxSwift
import RxRelay

// TODO: 다른 뷰에서도 viewModel을 참조한다면 어떤 방식이 좋을까..?
final class SearchFilterViewModel {
  
  // MARK: - Input & Output
  struct Input {
  }
  
  struct Output {
    let tabs = BehaviorRelay<[SearchTab]>(value: SearchTab.default)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: SearchFilterCoordinator?
  let perfumeRepository: PerfumeRepository
  let filterRepostiroy: FilterRepository
  let fetchFilterBrandInitialUseCase: FetchFilterBrandInitialUseCase
  let from: CoordinatorType
  
  /// Series
  let seriesDataSource = BehaviorRelay<[FilterSeriesDataSection.Model]>(value: FilterSeriesDataSection.default)
  let series = BehaviorRelay<[FilterSeries]>(value: [])
  let seriesState = BehaviorRelay<Set<Int>>(value: Set())
  /// Brand
  var brandInfos: [FilterBrandInfo] = []
  let brandInitials = BehaviorRelay<[FilterBrandInitial]>(value: [])
  let brandInitialSelected = BehaviorRelay<Int>(value: 1)
  let brands = BehaviorRelay<[FilterBrand]>(value: [])
  
  
  // MARK: - Life Cycle
  init(coordinator: SearchFilterCoordinator,
       perfumeRepository: PerfumeRepository,
       filterRepository: FilterRepository,
       fetchFilterBrandInitialUseCase: FetchFilterBrandInitialUseCase,
       from: CoordinatorType) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.filterRepostiroy = filterRepository
    self.fetchFilterBrandInitialUseCase = fetchFilterBrandInitialUseCase
    self.from = from
  }
  
  var selectedTab = BehaviorRelay<Int>(value: 0)
  var output = Output()
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
    return self.output
  }
  
  private func bindInput(input: Input, disposeBag: DisposeBag) {
    
  }
  
  private func bindOutput(disposeBag: DisposeBag) {
    self.bindSeries(disposeBag: disposeBag)
    self.bindBrands(disposeBag: disposeBag)
  }
  
  private func bindSeries(disposeBag: DisposeBag) {
    Observable.combineLatest(self.series, self.seriesState).withLatestFrom(self.seriesDataSource) { updated, originals in
      let series = updated.0
      let state = updated.1
      return series.enumerated().map { idx, series in
        let items = state.contains(idx) ? series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) } : []
        return FilterSeriesDataSection.Model(model: series.name, items: items)
      }
    }
    .bind(to: self.seriesDataSource)
    .disposed(by: disposeBag)
  }
  
  private func bindBrands(disposeBag: DisposeBag) {
    Observable.zip(self.brandInitialSelected, self.brandInitialSelected.skip(1))
      .subscribe(onNext: { [weak self] previous, current in
        self?.updateBrandInitials(previous: previous, current: current)
        self?.updateBrands(current: current)
      })
      .disposed(by: disposeBag)
    

    Observable.combineLatest(self.series, self.seriesState).withLatestFrom(self.seriesDataSource) { updated, originals in
      let series = updated.0
      let state = updated.1
      return series.enumerated().map { idx, series in
        let items = state.contains(idx) ? series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) } : []
        return FilterSeriesDataSection.Model(model: series.name, items: items)
      }
    }
    .bind(to: self.seriesDataSource)
    .disposed(by: disposeBag)
  }
  
  // MARK: - Network
  private func fetchDatas(disposeBag: DisposeBag) {
    /// Series
    self.filterRepostiroy.fetchSeriesForFilter()
      .subscribe { [weak self] data in
        let count = data.count
        let sectionSet = Set(0..<count)
        self?.series.accept(data)
        self?.seriesState.accept(sectionSet)
      }
      .disposed(by: disposeBag)
    
    /// Brand
    self.fetchFilterBrandInitialUseCase.execute()
      .subscribe(onNext: { [weak self] initials in
        self?.brandInitials.accept(initials)
//        self?.brandInitialSelected.accept(0)
      })
      .disposed(by: disposeBag)
    
    self.filterRepostiroy.fetchBrandsForFilter()
      .subscribe(onNext: { [weak self] brandInfos in
        self?.brandInfos = brandInfos
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Action
  func clickSeriesMoreButton(section: Int) {
    var seriesSet = self.seriesState.value
    if seriesSet.contains(section) {
      seriesSet.remove(section)
    } else {
      seriesSet.insert(section)
    }
    self.seriesState.accept(seriesSet)
  }
  
  func clickSeries(section: Int, ingredient: FilterIngredient) {
    self.updateSeries(section: section, ingredient: ingredient)
  }
  
  func updateSeries(section: Int, ingredient: FilterIngredient) {
    let updated = self.series.value.enumerated().compactMap { idx, series in
      guard idx != section else {
        /// 클릭된 Ingredient 업데이트
        let updatedIngredients = series.ingredients.compactMap {
          guard $0.idx != ingredient.idx else {
            let ingredientUpdated = FilterIngredient(idx: ingredient.idx, name: ingredient.name, isSelected: !ingredient.isSelected)
            return ingredientUpdated
          }
          return $0
        }
        let updatedSeries = FilterSeries(idx: series.idx, name: series.name, ingredients: updatedIngredients)
        return updatedSeries
      }
      
      return series
    }
    self.series.accept(updated)
  }
  
  private func updateBrandInitials(previous: Int, current: Int) {
    let initials = self.brandInitials.value
    let updated = initials.enumerated().map { idx, initial in
      if idx == previous {
        return FilterBrandInitial(text: initial.text, isSelected: false)
      } else if idx == current, !initial.isSelected {
        return FilterBrandInitial(text: initial.text, isSelected: true)
      } else {
        return initial
      }
    }
    self.brandInitials.accept(updated)
  }
  
  private func updateBrands(current: Int) {
    for (idx, brandInfo) in self.brandInfos.enumerated() {
      if idx == current {
        self.brands.accept(brandInfo.brands)
        break
      }
    }
  }
  
  func clickBrandInitial(pos: Int) {
    self.brandInitialSelected.accept(pos)
  }
  
  func clickBrand(pos: Int) {
    self.updateBrandData(pos: pos)
  }
  
  private func updateBrandData(pos: Int) {
    var updatedBrandInfo = self.brandInfos[self.brandInitialSelected.value].brands[pos]
    updatedBrandInfo.isSelected = !updatedBrandInfo.isSelected
    
    let updatedBrands = self.brands.value.enumerated().map { idx, brand in
      guard idx != pos else {
        return FilterBrand(idx: brand.idx, name: brand.name, isSelected: !brand.isSelected)
      }
      return brand
    }
    self.brands.accept(updatedBrands)
  }
}
