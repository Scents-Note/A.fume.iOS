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
  }
  
  struct CellInput {
    let keywordDeleteDidTapEvent: PublishRelay<Keyword>
    let perfumeDidTapEvent: PublishRelay<Perfume>
    let perfumeHeartDidTapEvent: PublishRelay<Perfume>
  }
  
  struct Output {
    let keywords = BehaviorRelay<[KeywordDataSection.Model]>(value: [])
    let perfumes = BehaviorRelay<[PerfumeDataSection.Model]>(value: [])
    let hideEmptyView = BehaviorRelay<Bool>(value: true)
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: SearchResultCoordinator?
  var perfumeRepository: PerfumeRepository
//  private let perfumeSearch: PerfumeSearch
  let perfumeSearch = BehaviorRelay<PerfumeSearch>(value: PerfumeSearch.default)
  
  // MARK: - Life Cycle
  init(coordinator: SearchResultCoordinator, perfumeRepository: PerfumeRepository, perfumeSearch: PerfumeSearch) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.perfumeSearch.accept(perfumeSearch)
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let keywords = PublishRelay<[Keyword]>()
    let perfumes = PublishRelay<[Perfume]>()
//    let perfumeSearch = PublishRelay<PerfumeSearch>()
    
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
                         perfumes: PublishRelay<[Perfume]>,
                         disposeBag: DisposeBag) {
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchKeywordFlow?()
      })
      .disposed(by: disposeBag)
    
    cellInput.keywordDeleteDidTapEvent.withLatestFrom(perfumeSearch) { updated, originals in
      switch updated.category {
      case .searchWord:
        var updates = originals
        updates.searchWord = nil
        return updates
      default:
        return originals
      }
    }
    .bind(to: perfumeSearch)
    .disposed(by: disposeBag)
    
    //    cellInput.keywordDeleteDidTapEvent.withLatestFrom(<#T##second: ObservableConvertibleType##ObservableConvertibleType#>)
    //      .subscribe(onNext: {})
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow?(perfume.perfumeIdx)
      })
      .disposed(by: disposeBag)
    
    cellInput.perfumeHeartDidTapEvent.withLatestFrom(perfumes) { updated, originals in
      originals.map {
        guard $0.perfumeIdx != updated.perfumeIdx else {
          Log($0.perfumeIdx)
          var item = updated
          item.isLiked.toggle()
          return item
        }
        return $0
      }
    }
    .bind(to: perfumes)
    .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          keywords: PublishRelay<[Keyword]>,
                          perfumes: PublishRelay<[Perfume]>,
                          disposeBag: DisposeBag) {
    keywords.subscribe(onNext: { keywords in
      let items = keywords.map { KeywordDataSection.Item(keyword: $0) }
      let model = KeywordDataSection.Model(model: "keyword", items: items)
      output.keywords.accept([model])
    })
    .disposed(by: disposeBag)
    
    perfumes.subscribe(onNext: { perfumes in
      if perfumes.count == 0 {
        output.hideEmptyView.accept(false)
      }
      let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
      let model = PerfumeDataSection.Model(model: "perfume", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: disposeBag)
    
  }
  
  private func bindNetwork(keywords: PublishRelay<[Keyword]>,
                           perfumes: PublishRelay<[Perfume]>,
                           disposeBag: DisposeBag) {
    
    perfumeSearch
      .subscribe(onNext: { [weak self] data in
        Log(data)
        keywords.accept(data.toKeywordList())
        self?.fetchPerfumes(perfumeSearch: data, perfumes: perfumes, disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
//    perfumeSearch.accept(self.perfumeSearch)
    
  }
  
  private func fetchPerfumes(perfumeSearch: PerfumeSearch, perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    self.perfumeRepository.fetchPerfumeSearched(perfumeSearch: perfumeSearch)
      .subscribe(onNext: { perfumesFetched in
        Log(perfumesFetched)
        guard let perfumesFetched = perfumesFetched else { return }
        perfumes.accept(perfumesFetched)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
  }
  
  func updateSearchWords(perfumeSearch: PerfumeSearch) {
    self.perfumeSearch.accept(perfumeSearch)
  }
  
  
}
