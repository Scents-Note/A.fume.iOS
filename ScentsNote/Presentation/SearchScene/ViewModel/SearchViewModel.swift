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
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  
  // MARK: - Life Cycle
  init(coordinator: SearchCoordinator,
       fetchPerfumesNewUseCase: FetchPerfumesNewUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase) {
    self.coordinator = coordinator
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
  }
  
  // MARK: - Binding
  func transform(from input: Input, from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let perfumes = BehaviorRelay<[Perfume]>(value: [])
    
    self.bindInput(input: input, cellInput: cellInput, perfumes: perfumes, disposeBag: disposeBag)
    self.bindOutput(output: output, perfumes: perfumes, disposeBag: disposeBag)
    self.fetchDatas(perfumes: perfumes, disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input, cellInput: CellInput, perfumes: BehaviorRelay<[Perfume]>, disposeBag: DisposeBag) {
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
  
  private func bindOutput(output: Output, perfumes: BehaviorRelay<[Perfume]>, disposeBag: DisposeBag) {
    perfumes.subscribe(onNext: { perfumes in
      let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
      let model = PerfumeDataSection.Model(model: "perfume", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: disposeBag)
  }
  
  private func fetchDatas(perfumes: BehaviorRelay<[Perfume]>, disposeBag: DisposeBag) {
    self.fetchPerfumesNewUseCase.execute(size: nil)
      .subscribe { perfumesFetched in
        perfumes.accept(perfumesFetched)
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
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

extension SearchViewModel: LabelPopupDelegate {
  func confirm() {
    self.coordinator?.runOnboardingFlow?()
  }
}
