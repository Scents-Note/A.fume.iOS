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
  private let disposeBag = DisposeBag()
  let input = Input()
  let cellInput = CellInput()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeNewCoordinator, fetchPerfumesNewUseCase: FetchPerfumesNewUseCase) {
    self.coordinator = coordinator
    self.fetchPerfumesNewUseCase = fetchPerfumesNewUseCase
  }
  
  
  // MARK: - Binding
  func transform(input: Input, cellInput: CellInput, output: Output) {
    let perfumes = PublishRelay<[Perfume]>()
    
    self.bindInput(input: input, cellInput: cellInput, perfumes: perfumes, disposeBag: disposeBag)
    self.bindOutput(output: output, perfumes: perfumes, disposeBag: disposeBag)
    self.fetchDatas(perfumes: perfumes, disposeBag: disposeBag)
  }
  
  private func bindInput(input: Input, cellInput: CellInput, perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    input.reportButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runWebFlow(with: WebURL.reportPerfumeInNew)
      })
      .disposed(by: disposeBag)
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfumeIdx in
        self?.coordinator?.runPerfumeDetailFlow?(perfumeIdx)
      })
      .disposed(by: disposeBag)
    
    cellInput.perfumeHeartDidTapEvent.withLatestFrom(perfumes) { updated, originals in
      originals.map {
        guard $0.perfumeIdx != updated else {
          var item = $0
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
      let model = PerfumeDataSection.Model(model: "perfumeNew", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: disposeBag)
  }
  
  private func fetchDatas(perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    self.fetchPerfumesNewUseCase.execute(size: nil)
      .subscribe(onNext: { data in
        perfumes.accept(data)
      })
      .disposed(by: disposeBag)
  }
}
