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
    let searchButtonDidTapEvent = PublishRelay<Void>()
    let filterButtonDidTapEvent = PublishRelay<Void>()
    let reportButtonDidTapEvent = PublishRelay<Void>()
    let perfumeSearchUpdateEvent = PublishRelay<PerfumeSearch>()
  }
  
  struct CellInput {
    let keywordDeleteDidTapEvent = PublishRelay<SearchKeyword>()
    let perfumeDidTapEvent = PublishRelay<Perfume>()
    let perfumeHeartDidTapEvent = PublishRelay<Perfume>()
  }
  
  struct Output {
    let keywords = BehaviorRelay<[KeywordDataSection.Model]>(value: [])
    let perfumes = BehaviorRelay<[PerfumeDataSection.Model]>(value: [])
    let hideKeywordView = BehaviorRelay<Bool>(value: true)
    let hideEmptyView = BehaviorRelay<Bool>(value: true)
    let perfumeCount = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SearchResultCoordinator?
  private let fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let perfumeSearch: PerfumeSearch
  private let disposeBag = DisposeBag()
  let input = Input()
  let cellInput = CellInput()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: SearchResultCoordinator,
       fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase,
       perfumeSearch: PerfumeSearch) {
    self.coordinator = coordinator
    self.fetchPerfumeSearchedUseCase = fetchPerfumeSearchedUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    self.perfumeSearch = perfumeSearch
    
    self.transform(input: self.input, cellInput: self.cellInput, output: self.output)
  }
  
  
  // MARK: - Binding
  func transform(input: Input, cellInput: CellInput, output: Output) {
    let keywords = PublishRelay<[SearchKeyword]>()
    let perfumeSearch = PublishRelay<PerfumeSearch>()
    let perfumes = BehaviorRelay<[Perfume]>(value: [])
    
    self.bindInput(input: input,
                   cellInput: cellInput,
                   perfumes: perfumes,
                   perfumeSearch: perfumeSearch,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: output,
                    keywords: keywords,
                    perfumes: perfumes,
                    disposeBag: disposeBag)
    
    self.fetchDatas(keywords: keywords,
                    perfumes: perfumes,
                    perfumeSearch: perfumeSearch,
                    disposeBag: disposeBag)
    
  }
  
  private func bindInput(input: Input,
                         cellInput: CellInput,
                         perfumes: BehaviorRelay<[Perfume]>,
                         perfumeSearch: PublishRelay<PerfumeSearch>,
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
    
    input.perfumeSearchUpdateEvent
      .bind(to: perfumeSearch)
      .disposed(by: self.disposeBag)
    
    cellInput.keywordDeleteDidTapEvent.withLatestFrom(perfumeSearch) { [weak self] updated, originals in
      self?.perfumeSearchUpdated(keyword: updated, perfumeSearch: originals) ?? PerfumeSearch.default
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
        self?.updatePerfumeLike(perfumeIdx: perfume.perfumeIdx, perfumes: perfumes)
        
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          keywords: PublishRelay<[SearchKeyword]>,
                          perfumes: BehaviorRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    
    keywords
      .subscribe(onNext: { keywords in
        let items = keywords.map { KeywordDataSection.Item(keyword: $0) }
        let model = KeywordDataSection.Model(model: "keyword", items: items)
        output.hideKeywordView.accept(items.count == 0)
        output.keywords.accept([model])
      })
      .disposed(by: disposeBag)
    
    perfumes
      .subscribe(onNext: { perfumes in
        let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
        let model = PerfumeDataSection.Model(model: "perfume", items: items)
        output.perfumes.accept([model])
        output.perfumeCount.accept(items.count)
        output.hideEmptyView.accept(perfumes.count != 0)
      })
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(keywords: PublishRelay<[SearchKeyword]>,
                          perfumes: BehaviorRelay<[Perfume]>,
                          perfumeSearch: PublishRelay<PerfumeSearch>,
                          disposeBag: DisposeBag) {
    
    perfumeSearch
      .subscribe(onNext: { [weak self] data in
        keywords.accept(data.toSearchKeywords())
        self?.fetchPerfumes(perfumeSearch: data, perfumes: perfumes, disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    perfumeSearch.accept(self.perfumeSearch)
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
  
  private func perfumeSearchUpdated(keyword: SearchKeyword, perfumeSearch: PerfumeSearch) -> PerfumeSearch {
    var updated = perfumeSearch
    switch keyword.category {
    case .searchWord:
      updated.searchWord = nil
    case .ingredient:
      let updatedIngredients = perfumeSearch.ingredients.filter { $0.idx != keyword.idx }
      updated.ingredients = updatedIngredients
    case .brand:
      let updatedBrands = perfumeSearch.brands.filter { $0.idx != keyword.idx }
      updated.brands = updatedBrands
    case .keyword:
      let updatedKeywords = perfumeSearch.keywords.filter { $0.idx != keyword.idx }
      updated.keywords = updatedKeywords
    }
    return updated
  }
  
  private func updatePerfumeLike(perfumeIdx: Int, perfumes: BehaviorRelay<[Perfume]>) {
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: perfumeIdx)
      .subscribe(onNext: { [weak self] _ in
        let updatedPerfumes = self?.togglePerfumeLike(perfumeIdx: perfumeIdx, originals: perfumes.value) ?? []
        perfumes.accept(updatedPerfumes)
      }, onError: { [weak self] error in
        self?.coordinator?.showPopup()
      })
      .disposed(by: self.disposeBag)
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
  
  func updateSearchWords(perfumeSearch: PerfumeSearch) {
    self.input.perfumeSearchUpdateEvent.accept(perfumeSearch)
  }
  
}

extension SearchResultViewModel: LabelPopupDelegate {
  func confirm() {
    self.coordinator?.runOnboardingFlow?()
  }
}
