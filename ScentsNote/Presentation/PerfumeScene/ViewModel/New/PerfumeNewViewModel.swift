//
//  PerfumeNewViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import Foundation
import RxSwift
import RxRelay

final class PerfumeNewViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let reportButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct CellInput {
    let perfumeDidTapEvent = PublishRelay<Int>()
    let perfumeHeartDidTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let perfumes = BehaviorRelay<[PerfumeDataSection.Model]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: PerfumeNewCoordinator?
  private let fetchPerfumesNewUseCase: FetchPerfumesNewUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let cellInput = CellInput()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeNewCoordinator,
       fetchPerfumesNewUseCase: FetchPerfumesNewUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase) {
    self.coordinator = coordinator
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    
    self.transform(input: self.input, cellInput: self.cellInput, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, cellInput: CellInput, output: Output) {
    let perfumes = BehaviorRelay<[Perfume]>(value: [])
    
    self.bindInput(input: input, cellInput: cellInput, perfumes: perfumes)
    self.bindOutput(output: output, perfumes: perfumes)
    self.fetchDatas(perfumes: perfumes)
  }
  
  private func bindInput(input: Input, cellInput: CellInput, perfumes: BehaviorRelay<[Perfume]>) {
    input.reportButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runWebFlow(with: WebURL.reportPerfumeInNew)
      })
      .disposed(by: self.disposeBag)
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfumeIdx in
        self?.coordinator?.runPerfumeDetailFlow?(perfumeIdx)
      })
      .disposed(by: self.disposeBag)
    
    cellInput.perfumeHeartDidTapEvent
      .subscribe(onNext: { [weak self] perfumeIdx in
        self?.updatePerfumeLike(perfumeIdx: perfumeIdx, perfumes: perfumes)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output, perfumes: BehaviorRelay<[Perfume]>) {
    perfumes.subscribe(onNext: { perfumes in
      let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
      let model = PerfumeDataSection.Model(model: "perfumeNew", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: self.disposeBag)
  }
  
  private func fetchDatas(perfumes: BehaviorRelay<[Perfume]>) {
    self.fetchPerfumesNewUseCase.execute(size: nil)
      .subscribe(onNext: { data in
        perfumes.accept(data)
      })
      .disposed(by: disposeBag)
  }
  
  private func updatePerfumeLike(perfumeIdx: Int, perfumes: BehaviorRelay<[Perfume]>) {
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: perfumeIdx)
      .subscribe(onNext: { [weak self] _ in
        let perfumesUpdated = self?.perfumesUpdated(perfumeIdx: perfumeIdx, perfumes: perfumes.value) ?? []
        perfumes.accept(perfumesUpdated)
      }, onError: { [weak self] error in
        self?.coordinator?.showPopup()
      })
      .disposed(by: self.disposeBag)
  }
  
  private func perfumesUpdated(perfumeIdx: Int, perfumes: [Perfume]) -> [Perfume] {
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

extension PerfumeNewViewModel: LabelPopupDelegate {
  func confirm() {
    self.coordinator?.runOnboardingFlow?()
  }
}
