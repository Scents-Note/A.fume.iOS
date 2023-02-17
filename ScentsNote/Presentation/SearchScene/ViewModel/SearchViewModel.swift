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
    let searchButtonDidTapEvent = PublishRelay<Void>()
    let filterButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct CellInput {
    let perfumeDidTapEvent = PublishRelay<Perfume>()
    let perfumeHeartDidTapEvent = PublishRelay<Perfume>()
  }
  
  struct Output {
    let perfumes = BehaviorRelay<[PerfumeDataSection.Model]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: SearchCoordinator?
  private let fetchPerfumesNewUseCase: FetchPerfumesNewUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let cellInput = CellInput()
  let output = Output()
  var perfumes: [Perfume] = []
  
  // MARK: - Life Cycle
  init(coordinator: SearchCoordinator,
       fetchPerfumesNewUseCase: FetchPerfumesNewUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase) {
    self.coordinator = coordinator
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    
    self.transform(input: self.input, cellInput: self.cellInput, output: self.output)
  }
  
  // MARK: - Binding
    func transform(input: Input, cellInput: CellInput, output: Output) {
    let perfumes = PublishRelay<[Perfume]>()
    
    self.bindInput(input: input, cellInput: cellInput, perfumes: perfumes)
    self.bindOutput(output: output, perfumes: perfumes)
    self.fetchDatas(perfumes: perfumes)
  }
  
  private func bindInput(input: Input, cellInput: CellInput, perfumes: PublishRelay<[Perfume]>) {
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchKeywordFlow(from: .search)
      })
      .disposed(by: self.disposeBag)
    
    input.filterButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runSearchFilterFlow(from: .search)
      })
      .disposed(by: self.disposeBag)
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow(perfumeIdx: perfume.perfumeIdx)
      })
      .disposed(by: self.disposeBag)
    
    cellInput.perfumeHeartDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.updatePerfumes(perfume: perfume, perfumesOld: self?.perfumes ?? [], perfumes: perfumes)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindOutput(output: Output, perfumes: PublishRelay<[Perfume]>) {
    perfumes.subscribe(onNext: { perfumes in
      let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
      let model = PerfumeDataSection.Model(model: "perfume", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: self.disposeBag)
  }
  
  private func fetchDatas(perfumes: PublishRelay<[Perfume]>) {
    self.fetchPerfumesNewUseCase.execute(size: nil)
      .subscribe { [weak self] perfumesFetched in
        self?.perfumes = perfumesFetched
        perfumes.accept(perfumesFetched)
      } onError: { error in
        Log(error)
      }
      .disposed(by: self.disposeBag)
  }
  
  private func updatePerfumes(perfume: Perfume, perfumesOld: [Perfume], perfumes: PublishRelay<[Perfume]>) {
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: perfume.perfumeIdx)
      .subscribe(onNext: { [weak self] _ in
        let updated = self?.updatePerfumeLike(perfumeIdx: perfume.perfumeIdx, perfumesOld: perfumesOld) ?? []
        self?.perfumes = updated
        perfumes.accept(updated)
      }, onError: { [weak self] error in
        self?.coordinator?.showPopup()
      })
      .disposed(by: disposeBag)
  }
  
  private func updatePerfumeLike(perfumeIdx: Int, perfumesOld perfumes: [Perfume]) -> [Perfume] {
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
