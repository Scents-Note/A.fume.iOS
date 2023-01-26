//
//  SearchFilterSeriesViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/22.
//

import RxSwift
import RxRelay

final class SearchFilterSeriesViewModel {
  
  // MARK: - Input & Output
  struct Input {
    // 0: Series 그룹 번호, 1: 그룹 안에 있는 ingredient 정보
    let ingredientDidTapEvent = PublishRelay<(Int, FilterIngredient)>()
    let seiresMoreButtonDidTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let seriesDataSource = BehaviorRelay<[FilterSeriesDataSection.Model]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private let fetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase
  private let disposeBag = DisposeBag()
  private weak var filterDelegate: FilterDelegate?
  let input = Input()
  let output = Output()
  var ingredients: [FilterIngredient] = []
  
  // MARK: - Life Cycle
  init(filterDelegate: FilterDelegate,
       fetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase) {
    self.filterDelegate = filterDelegate
    self.fetchSeriesForFilterUseCase = fetchSeriesForFilterUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let series = PublishRelay<[FilterSeries]>()
    let seriesState = PublishRelay<Set<Int>>()
    
    self.bindInput(input: input,
                   series: series,
                   seriesState: seriesState)
    
    self.bindOutput(output: output,
                    series: series,
                    seriesState: seriesState)
    
    self.fetchDatas(series: series,
                    seriesState: seriesState)
  }
  
  private func bindInput(input: Input,
                         series: PublishRelay<[FilterSeries]>,
                         seriesState: PublishRelay<Set<Int>>) {
    
    input.ingredientDidTapEvent
      .withLatestFrom(series) { [weak self] ingredient, original in
        self?.seriesUpdated(section: ingredient.0, ingredient: ingredient.1, series: original) ?? []
      }
      .bind(to: series)
      .disposed(by: self.disposeBag)
    
    input.seiresMoreButtonDidTapEvent
      .withLatestFrom(seriesState) { [weak self] section, seriesState in
        self?.seriesStateUpdated (section: section, seriesState: seriesState) ?? Set()
      }
      .bind(to: seriesState)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output,
                          series: PublishRelay<[FilterSeries]>,
                          seriesState: PublishRelay<Set<Int>>) {
    
    Observable.combineLatest(series, seriesState)
      .withLatestFrom(output.seriesDataSource) { updated, originals in
        let series = updated.0
        let state = updated.1
        return series.enumerated().map { idx, series in
          let items = state.contains(idx) ? series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) } : []
          return FilterSeriesDataSection.Model(model: series.name, items: items)
        }
      }
      .bind(to: output.seriesDataSource)
      .disposed(by: disposeBag)
  }
  
  private func fetchDatas(series: PublishRelay<[FilterSeries]>,
                          seriesState: PublishRelay<Set<Int>>) {
    self.fetchSeriesForFilterUseCase.execute()
      .subscribe(onNext: { seriesFetched in
        let sectionSet = Set(0..<seriesFetched.count)
        series.accept(seriesFetched)
        seriesState.accept(sectionSet)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func seriesUpdated(section: Int, ingredient: FilterIngredient, series: [FilterSeries]) -> [FilterSeries] {
    var updated = series
    var ingredientsUpdated = updated[section].ingredients
    for i in 0..<ingredientsUpdated.count {
      if ingredient.idx == ingredientsUpdated[i].idx {
        if !ingredientsUpdated[i].isSelected, self.ingredients.count == 5 {
          return updated
        }
        self.updateIngredients(ingredient: ingredient, ingredients: self.ingredients)
        ingredientsUpdated[i].isSelected = !ingredientsUpdated[i].isSelected
      }
    }
    updated[section].ingredients = ingredientsUpdated
    return updated
  }
  
  private func updateIngredients(ingredient: FilterIngredient, ingredients: [FilterIngredient]) {
    for i in 0..<ingredients.count {
      if ingredient.id == ingredients[i].id {
        self.ingredients = ingredients.filter { $0.id != ingredient.id }
        self.filterDelegate?.updateIngredients(ingredients: self.ingredients)
        return
      }
    }
    self.ingredients = ingredients + [ingredient]
    self.filterDelegate?.updateIngredients(ingredients: self.ingredients)
  }
  
  private func seriesStateUpdated(section: Int, seriesState: Set<Int>) -> Set<Int> {
    var updated = seriesState
    if updated.contains(section) {
      updated.remove(section)
    } else {
      updated.insert(section)
    }
    return updated
  }
}
