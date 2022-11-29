//
//  SearchFilterViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import RxSwift
import RxRelay

// TODO: 다른 뷰에서도 viewModel을 참조한다면 어떤 방식이 좋을까..?
// TODO: 구조 전체적으로 변경. 너무 복잡하고 두서없음
final class SearchFilterViewModel {
  
  // MARK: - Input & Output
  struct Input {
  }
  
  struct Output {
    let tabs = BehaviorRelay<[SearchTab]>(value: SearchTab.default)
    let selectedCount = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: SearchFilterCoordinator?
  private let perfumeRepository: PerfumeRepository
  private let filterRepostiroy: FilterRepository
  private let keywordRepository: KeywordRepository
  private let fetchFilterBrandInitialUseCase: FetchFilterBrandInitialUseCase
  private let from: CoordinatorType
  
  /// Search Keyword
//  let searchKeywords = BehaviorRelay<PerfumeSearch>(value: [])
  /// Series
  let seriesDataSource = BehaviorRelay<[FilterSeriesDataSection.Model]>(value: [])
  let series = BehaviorRelay<[FilterSeries]>(value: [])
  let seriesState = BehaviorRelay<Set<Int>>(value: Set())
  let seriesSelected = BehaviorRelay<Set<Int>>(value: Set())
  /// Brand
  var brandInfos: [FilterBrandInfo] = []
  let brandInitials = BehaviorRelay<[FilterBrandInitial]>(value: [])
  let brandInitialSelected = BehaviorRelay<Int>(value: 1)
  let brands = BehaviorRelay<[FilterBrand]>(value: [])
  let brandsSelected = BehaviorRelay<Set<Int>>(value: Set())
  /// Keyword
  let keywordDataSource = BehaviorRelay<[FilterKeywordDataSection.Model]>(value: [])
  let keywords = BehaviorRelay<[Keyword]>(value: [])
  let keywordsSelected = BehaviorRelay<Set<Int>>(value: Set())
  
  // MARK: - Life Cycle
  init(coordinator: SearchFilterCoordinator,
       perfumeRepository: PerfumeRepository,
       filterRepository: FilterRepository,
       keywordRepository: KeywordRepository,
       fetchFilterBrandInitialUseCase: FetchFilterBrandInitialUseCase,
       from: CoordinatorType) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.filterRepostiroy = filterRepository
    self.keywordRepository = keywordRepository
    self.fetchFilterBrandInitialUseCase = fetchFilterBrandInitialUseCase
    self.from = from
  }
  
  var selectedTab = BehaviorRelay<Int>(value: 0)
  var output = Output()
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(output: output, disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
    return self.output
  }
  
  private func bindInput(input: Input, disposeBag: DisposeBag) {
    
  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    self.bindSeries(output: output, disposeBag: disposeBag)
    self.bindBrands(disposeBag: disposeBag)
    self.bindKeywords(disposeBag: disposeBag)
    self.bindDoneButton(output: output, disposeBag: disposeBag)
  }
  
  private func bindSeries(output: Output, disposeBag: DisposeBag) {
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
    
    self.seriesSelected.withLatestFrom(output.tabs) { updated, originals in
      originals.enumerated().map { idx, tab in
        guard idx != 0 else {
          return SearchTab(name: tab.name, count: updated.count)
        }
        return tab
      }
    }
    .bind(to: output.tabs)
    .disposed(by: disposeBag)
  }
  
  private func bindBrands(disposeBag: DisposeBag) {
    Observable.zip(self.brandInitialSelected, self.brandInitialSelected.skip(1))
      .subscribe(onNext: { [weak self] previous, current in
        guard previous != current else { return }
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
    
    self.brandsSelected.withLatestFrom(output.tabs) { updated, originals in
      originals.enumerated().map { idx, tab in
        guard idx != 1 else {
          return SearchTab(name: tab.name, count: updated.count)
        }
        return tab
      }
    }
    .bind(to: output.tabs)
    .disposed(by: disposeBag)
  }
  
  private func bindKeywords(disposeBag: DisposeBag) {
    self.keywords.withLatestFrom(self.keywordDataSource) { updated, originals in
      let items = updated.map { FilterKeywordDataSection.Item(keyword: $0) }
      let sectionModel = FilterKeywordDataSection.Model(model: "keyword", items: items)
      return [sectionModel]
    }
    .bind(to: self.keywordDataSource)
    .disposed(by: disposeBag)
    
    self.keywordsSelected.withLatestFrom(output.tabs) { updated, originals in
      originals.enumerated().map { idx, tab in
        guard idx != 2 else {
          return SearchTab(name: tab.name, count: updated.count)
        }
        return tab
      }
    }
    .bind(to: output.tabs)
    .disposed(by: disposeBag)
  }
  
  private func bindDoneButton(output: Output, disposeBag: DisposeBag) {
    Observable.combineLatest(self.seriesSelected, self.brandsSelected, self.keywordsSelected)
      .subscribe(onNext: { series, brands, keywords in
        let count = series.count + brands.count + keywords.count
        output.selectedCount.accept(count)
      })
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
    self.filterRepostiroy.fetchBrandsForFilter()
      .subscribe(onNext: { [weak self] brandInfos in
        self?.brandInfos = brandInfos
      })
      .disposed(by: disposeBag)
    
    self.fetchFilterBrandInitialUseCase.execute()
      .subscribe(onNext: { [weak self] initials in
        self?.brandInitials.accept(initials)
        self?.brandInitialSelected.accept(0)
      })
      .disposed(by: disposeBag)
    
    self.keywordRepository.fetchKeywords()
      .subscribe(onNext: { [weak self] keywords in
        self?.keywords.accept(keywords)
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
  
  func clickBrandInitial(pos: Int) {
    self.brandInitialSelected.accept(pos)
  }
  
  func clickBrand(pos: Int) {
    self.updateBrandData(pos: pos)
  }
  
  func clickKeyword(pos: Int) {
    self.updateKeywords(pos: pos)
  }
  
  // MARK: - Update Data
  func updateSeries(section: Int, ingredient: FilterIngredient) {
    let updated = self.series.value.enumerated().map { idx, series in
      guard idx != section else {
        /// 클릭된 Ingredient 업데이트
        let updatedIngredients = series.ingredients.map {
          guard $0.idx != ingredient.idx else {
            var selected = self.seriesSelected.value
            if ingredient.isSelected {
              selected.remove(ingredient.idx)
            } else {
              if self.seriesSelected.value.count > 4 {
                return $0
              } else {
                selected.insert(ingredient.idx)
              }
            }
            self.seriesSelected.accept(selected)
            
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
  
  private func updateBrandData(pos: Int) {
    let initialPos = self.brandInitialSelected.value
    var updatedBrandInfo = self.brandInfos[initialPos].brands[pos]
    updatedBrandInfo.isSelected = !updatedBrandInfo.isSelected
    
    let updatedBrands = self.brands.value.enumerated().map { idx, brand in
      guard idx != pos else {
        var selected = self.brandsSelected.value
        if brand.isSelected {
          selected.remove(brand.idx)
        } else {
          if self.brandsSelected.value.count > 4 {
            return brand
          } else {
            selected.insert(brand.idx)
          }
        }
        self.brandsSelected.accept(selected)
        
        return FilterBrand(idx: brand.idx, name: brand.name, isSelected: !brand.isSelected)
      }
      return brand
    }
    
    self.brandInfos[initialPos].brands[pos] = updatedBrandInfo
    self.brands.accept(updatedBrands)
  }
  
  private func updateKeywords(pos: Int) {
    Log(pos)
    let updated = self.keywords.value.enumerated().map { idx, keyword in
      guard idx != pos else {
        var selected = self.keywordsSelected.value
        if keyword.isSelected {
          selected.remove(keyword.idx)
        } else {
          if self.keywordsSelected.value.count > 4 {
            return keyword
          } else {
            selected.insert(keyword.idx)
          }
        }
        self.keywordsSelected.accept(selected)
        
        return Keyword(idx: keyword.idx, name: keyword.name, isSelected: !keyword.isSelected)
      }
      return keyword
    }
    self.keywords.accept(updated)
  }
  
}
