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
    let series = BehaviorRelay<[FilterSeriesDataSection.Model]>(value: FilterSeriesDataSection.default)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: SearchFilterCoordinator?
  let perfumeRepository: PerfumeRepository
  let filterRepostiroy: FilterRepository
  let from: CoordinatorType
  
  /// Series
  let series = BehaviorRelay<[FilterSeries]>(value: [])
  let seriesState = BehaviorRelay<Set<Int>>(value: Set())
  /// Brand
  let brands = BehaviorRelay<[FilterSeries]>(value: [])
  let brandInitials = BehaviorRelay<[String]>(value: [])

  
  // MARK: - Life Cycle
  init(coordinator: SearchFilterCoordinator,
       perfumeRepository: PerfumeRepository,
       filterRepository: FilterRepository,
       from: CoordinatorType) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.filterRepostiroy = filterRepository
    self.from = from
  }
  
  var selectedTab = BehaviorRelay<Int>(value: 0)
  var output = Output()
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let series = PublishRelay<[FilterSeries]>()
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
    return self.output
  }
  
  private func bindInput(input: Input, disposeBag: DisposeBag) {
    
  }
  
  private func bindOutput(disposeBag: DisposeBag) {
    
//    Observable.combineLatest(series, isMonthlyTodosHidden)
    Observable.combineLatest(self.series, self.seriesState).withLatestFrom(self.output.series) { updated, originals in
      let series = updated.0
      let state = updated.1
      return series.enumerated().map { idx, series in
        let items = state.contains(idx) ? series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) } : []
        return FilterSeriesDataSection.Model(model: series.name, items: items)
      }
    }
    .bind(to: self.output.series)
    .disposed(by: disposeBag)
    
  }
  
  // MARK: - Network
  private func fetchDatas(disposeBag: DisposeBag) {
    /// Series
    self.filterRepostiroy.fetchSeriesForFilter()
      .subscribe { [weak self] data in
        guard let data = data else { return }
        let count = data.count
        let sectionSet = Set(0..<count)
        self?.series.accept(data)
        self?.seriesState.accept(sectionSet)
      }
      .disposed(by: disposeBag)
    
    /// Brand
//    self.filterRepostiroy.fetchBrandForFilter()
      
  }
  
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
}
