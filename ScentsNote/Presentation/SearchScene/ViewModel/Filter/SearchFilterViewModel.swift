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
  
  enum Tab: Int {
    case series
    case brand
    case keyword
  }
  
  // MARK: - Input & Output
  struct Input {
    let tabDidTapEvent = PublishRelay<Int>()
    let doneButtonDidTapEvent = PublishRelay<Void>()
    let closeButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct ChildInput {
    let ingredientsDidUpdateEvent = PublishRelay<[SearchKeyword]>()
    let brandsDidUpdateEvent = PublishRelay<[SearchKeyword]>()
    let keywordsDidUpdateEvent = PublishRelay<[SearchKeyword]>()
  }
  
  struct Output {
    let tabSelected = BehaviorRelay<Int>(value: 0)
    var hightlightViewTransform = BehaviorRelay<Int>(value: 0)
    let tabs = BehaviorRelay<[SearchTab]>(value: SearchTab.default)
    let selectedCount = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SearchFilterCoordinator?
  private weak var delegate: FilterDelegate?
  private let from: CoordinatorType
  private let disposeBag = DisposeBag()
  let input = Input()
  let childInput = ChildInput()
  let output = Output()
  var ingredients: [SearchKeyword] = []
  var brands: [SearchKeyword] = []
  var keywords: [SearchKeyword] = []
  
  // MARK: - Life Cycle
  init(coordinator: SearchFilterCoordinator,
       from: CoordinatorType) {
    self.coordinator = coordinator
    self.from = from
    
    self.transform(input: self.input, childInput: self.childInput, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, childInput: ChildInput, output: Output) {
    let ingredients = BehaviorRelay<[SearchKeyword]>(value: [])
    let brands = BehaviorRelay<[SearchKeyword]>(value: [])
    let keywords = BehaviorRelay<[SearchKeyword]>(value: [])
    let tabSelected = PublishRelay<Int>()
    
    self.bindInput(input: input,
                   childInput: childInput,
                   ingredients: ingredients,
                   brands: brands,
                   keywords: keywords,
                   tabSelected: tabSelected)
    
    self.bindOutput(output: output,
                    ingredients: ingredients,
                    brands: brands,
                    keywords: keywords,
                    tabSelected: tabSelected)
    
  }
  
  private func bindInput(input: Input,
                         childInput: ChildInput,
                         ingredients: BehaviorRelay<[SearchKeyword]>,
                         brands: BehaviorRelay<[SearchKeyword]>,
                         keywords: BehaviorRelay<[SearchKeyword]>,
                         tabSelected: PublishRelay<Int>) {
    input.tabDidTapEvent
      .subscribe(onNext: { idx in
        tabSelected.accept(idx)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        let searchKeywords = self?.searchKeywords()
        self?.coordinator?.finishFlow?(searchKeywords)
      })
      .disposed(by: disposeBag)
    
    input.closeButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.finishFlow?(nil)
      })
      .disposed(by: disposeBag)
    
    childInput.ingredientsDidUpdateEvent
      .subscribe(onNext: { [weak self] ingredientsUpdated in
        self?.ingredients = ingredientsUpdated
        ingredients.accept(ingredientsUpdated)
      })
      .disposed(by: self.disposeBag)
    
    childInput.brandsDidUpdateEvent
      .subscribe(onNext: { [weak self] brandsUpdated in
        self?.brands = brandsUpdated
        brands.accept(brandsUpdated)
      })
      .disposed(by: self.disposeBag)
    
    childInput.keywordsDidUpdateEvent
      .subscribe(onNext: { [weak self] keywordsUpdated in
        self?.keywords = keywordsUpdated
        keywords.accept(keywordsUpdated)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindOutput(output: Output,
                          ingredients: BehaviorRelay<[SearchKeyword]>,
                          brands: BehaviorRelay<[SearchKeyword]>,
                          keywords: BehaviorRelay<[SearchKeyword]>,
                          tabSelected: PublishRelay<Int>) {
    ingredients
      .withLatestFrom(output.tabs) { updated, originals in
        return originals.enumerated().map { idx, tab in
          guard idx != Tab.series.rawValue else {
            return SearchTab(name: tab.name, count: updated.count)
          }
          return tab
        }
      }
      .bind(to: output.tabs)
      .disposed(by: self.disposeBag)
    
    brands
      .withLatestFrom(output.tabs) { updated, originals in
        return originals.enumerated().map { idx, tab in
          guard idx != Tab.brand.rawValue else {
            return SearchTab(name: tab.name, count: updated.count)
          }
          return tab
        }
      }
      .bind(to: output.tabs)
      .disposed(by: self.disposeBag)
    
    keywords
      .withLatestFrom(output.tabs) { updated, originals in
        return originals.enumerated().map { idx, tab in
          guard idx != Tab.keyword.rawValue else {
            return SearchTab(name: tab.name, count: updated.count)
          }
          return tab
        }
      }
      .bind(to: output.tabs)
      .disposed(by: self.disposeBag)
    
    tabSelected
      .subscribe(onNext: { idx in
        output.tabSelected.accept(idx)
        output.hightlightViewTransform.accept(idx)
      })
      .disposed(by: disposeBag)
    
    Observable.combineLatest(ingredients, brands, keywords)
      .subscribe { ingredients, brands, keywords in
        let sum = ingredients.count + brands.count + keywords.count
        output.selectedCount.accept(sum)
      }
      .disposed(by: self.disposeBag)
  }
    
  private func searchKeywords() -> PerfumeSearch {
    PerfumeSearch(ingredients: self.ingredients,
                  brands: self.brands,
                  keywords: self.keywords)
  }
  
}

extension SearchFilterViewModel: FilterDelegate {
  func updateIngredients(ingredients: [FilterIngredient]) {
    let ingredients = ingredients.map { SearchKeyword(idx: $0.idx, name: $0.name, category: .ingredient) }
    self.childInput.ingredientsDidUpdateEvent.accept(ingredients)
  }
  
  func updateBrands(brands: [FilterBrand]) {
    let brands = brands.map { SearchKeyword(idx: $0.idx, name: $0.name, category: .brand) }
    self.childInput.brandsDidUpdateEvent.accept(brands)
  }
  
  func updateKeywords(keywords: [Keyword]) {
    let brands = keywords.map { SearchKeyword(idx: $0.idx, name: $0.name, category: .keyword) }
    self.childInput.keywordsDidUpdateEvent.accept(brands)
  }
}

protocol FilterDelegate: AnyObject {
  func updateIngredients(ingredients: [FilterIngredient])
  func updateBrands(brands: [FilterBrand])
  func updateKeywords(keywords: [Keyword])
  
}
