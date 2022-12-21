//
//  SearchViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay

final class SearchViewModel {

  // MARK: - Input & Output
  struct Input {
    let searchButtonDidTapEvent: Observable<Void>
    let filterButtonDidTapEvent: Observable<Void>
  }
  
  struct CellInput {
    let perfumeDidTapEvent: PublishRelay<Perfume>
    let perfumeHeartDidTapEvent: PublishRelay<Perfume>
  }
  
  struct Output {
    let perfumes = BehaviorRelay<[PerfumeDataSection.Model]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SearchCoordinator?
  private let fetchPerfumesNewUseCase: FetchPerfumesNewUseCase
  
  // MARK: - Life Cycle
  init(coordinator: SearchCoordinator, fetchPerfumesNewUseCase: FetchPerfumesNewUseCase) {
    self.coordinator = coordinator
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
  }
  
  // MARK: - Binding
  func transform(from input: Input, from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let perfumes = PublishRelay<[Perfume]>()
    
    self.bindInput(input: input, cellInput: cellInput, perfumes: perfumes, disposeBag: disposeBag)
    self.bindOutput(output: output, perfumes: perfumes, disposeBag: disposeBag)
    self.fetchDatas(perfumes: perfumes, disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input, cellInput: CellInput, perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchKeywordFlow(from: .search)
      })
      .disposed(by: disposeBag)
    
    input.filterButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchFilterFlow(from: .search)
      })
      .disposed(by: disposeBag)
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow(perfumeIdx: perfume.perfumeIdx)
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
  
  private func bindOutput(output: Output, perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    perfumes.subscribe(onNext: { perfumes in
      let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
      let model = PerfumeDataSection.Model(model: "perfume", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: disposeBag)
  }
  
  private func fetchDatas(perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    self.fetchPerfumesNewUseCase.execute(size: nil)
      .subscribe { perfumesFetched in
        perfumes.accept(perfumesFetched)
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
  }
}
