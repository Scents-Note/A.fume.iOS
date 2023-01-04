//
//  SearchResultViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import RxSwift
import RxRelay

final class SearchResultViewModel {
  // MARK: - Input & Output
  struct Input {
    let searchButtonDidTapEvent: Observable<Void>
    let filterButtonDidTapEvent: Observable<Void>
    let reportButtonDidTapEvent: Observable<Void>
  }
  
  struct CellInput {
    let keywordDeleteDidTapEvent: PublishRelay<SearchKeyword>
    let perfumeDidTapEvent: PublishRelay<Perfume>
    let perfumeHeartDidTapEvent: PublishRelay<Perfume>
  }
  
  struct Output {
    let keywords = BehaviorRelay<[KeywordDataSection.Model]>(value: [])
    let perfumes = BehaviorRelay<[PerfumeDataSection.Model]>(value: [])
    let hideKeywordView = BehaviorRelay<Bool>(value: true)
    let hideEmptyView = BehaviorRelay<Bool>(value: true)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SearchResultCoordinator?
  private let fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  
  let perfumeSearch = BehaviorRelay<PerfumeSearch>(value: PerfumeSearch.default)
  
  // MARK: - Life Cycle
  init(coordinator: SearchResultCoordinator,
       fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase,
       perfumeSearch: PerfumeSearch) {
    self.coordinator = coordinator
    self.fetchPerfumeSearchedUseCase = fetchPerfumeSearchedUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    self.perfumeSearch.accept(perfumeSearch)
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let keywords = PublishRelay<[SearchKeyword]>()
    let perfumes = BehaviorRelay<[Perfume]>(value: [])
    
    self.bindInput(input: input,
                   cellInput: cellInput,
                   perfumes: perfumes,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: output,
                    keywords: keywords,
                    perfumes: perfumes,
                    disposeBag: disposeBag)
    
    self.bindNetwork(keywords: keywords,
                     perfumes: perfumes,
                     disposeBag: disposeBag)
    
    return output
  }
  
  private func bindInput(input: Input,
                         cellInput: CellInput,
                         perfumes: BehaviorRelay<[Perfume]>,
                         disposeBag: DisposeBag) {
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchKeywordFlow?()
      })
      .disposed(by: disposeBag)
    
    input.filterButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchFilterFlow?()
      })
      .disposed(by: disposeBag)
    
    input.reportButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runWebFlow(with: WebURL.reportPerfumeInSearch)
      })
      .disposed(by: disposeBag)

    cellInput.keywordDeleteDidTapEvent.withLatestFrom(perfumeSearch) { updated, originals in
      switch updated.category {
      case .searchWord:
        var updates = originals
        updates.searchWord = nil
        return updates
      case .ingredient:
        var updates = originals
        let updatedIngredients = originals.ingredients.filter { $0.idx != updated.idx }
        updates.ingredients = updatedIngredients
        return updates
      case .brand:
        var updates = originals
        let updatedBrands = originals.brands.filter { $0.idx != updated.idx }
        updates.brands = updatedBrands
        return updates
      case .keyword:
        var updates = originals
        Log(updated)
        let updatedKeywords = originals.keywords.filter { $0.idx != updated.idx }
        Log(updatedKeywords)
        updates.keywords = updatedKeywords
        return updates
      }
    }
    .bind(to: perfumeSearch)
    .disposed(by: disposeBag)
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow?(perfume.perfumeIdx)
      })
      .disposed(by: disposeBag)
    
    cellInput.perfumeHeartDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.updatePerfumeLikeUseCase.execute(perfumeIdx: perfume.perfumeIdx)
          .subscribe(onNext: { _ in
            let updatedPerfumes = self?.togglePerfumeLike(perfumeIdx: perfume.perfumeIdx, originals: perfumes.value) ?? []
            perfumes.accept(updatedPerfumes)
          }, onError: { error in
            self?.coordinator?.showPopup()
          })
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          keywords: PublishRelay<[SearchKeyword]>,
                          perfumes: BehaviorRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    keywords.subscribe(onNext: { keywords in
      let items = keywords.map { KeywordDataSection.Item(keyword: $0) }
      let model = KeywordDataSection.Model(model: "keyword", items: items)
      output.hideKeywordView.accept(items.count == 0)
      output.keywords.accept([model])
    })
    .disposed(by: disposeBag)
    
    perfumes.subscribe(onNext: { perfumes in
      if perfumes.count == 0 {
        output.hideEmptyView.accept(false)
      } else {
        output.hideEmptyView.accept(true)
      }
      let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
      let model = PerfumeDataSection.Model(model: "perfume", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: disposeBag)
    
  }
  
  private func bindNetwork(keywords: PublishRelay<[SearchKeyword]>,
                           perfumes: BehaviorRelay<[Perfume]>,
                           disposeBag: DisposeBag) {
    
    perfumeSearch
      .subscribe(onNext: { [weak self] data in
        keywords.accept(data.toKeywordList())
        self?.fetchPerfumes(perfumeSearch: data, perfumes: perfumes, disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchPerfumes(perfumeSearch: PerfumeSearch,
                             perfumes: BehaviorRelay<[Perfume]>,
                             disposeBag: DisposeBag) {
    self.fetchPerfumeSearchedUseCase.execute(perfumeSearch: perfumeSearch)
      .subscribe(onNext: { perfumesFetched in
        perfumes.accept(perfumesFetched)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
  }
  
  func updateSearchWords(perfumeSearch: PerfumeSearch) {
    self.perfumeSearch.accept(perfumeSearch)
  }
  
  private func togglePerfumeLike(perfumeIdx: Int, originals perfumes: [Perfume]) -> [Perfume] {
    perfumes.map {
      guard $0.perfumeIdx != perfumeIdx else {
        var updatePerfume = $0
        updatePerfume.isLiked = !updatePerfume.isLiked
        return updatePerfume
      }
      return $0
    }
  }
  
}

extension SearchResultViewModel: LabelPopupDelegate {
  func confirm() {
    self.coordinator?.runOnboardingFlow?()
  }
}
