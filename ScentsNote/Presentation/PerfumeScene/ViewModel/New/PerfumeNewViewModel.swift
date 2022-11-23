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
    
  }
  
  struct CellInput {
    let perfumeDidTapEvent: PublishRelay<Perfume>
    let perfumeHeartDidTapEvent: PublishRelay<Perfume>
  }
  
  struct Output {
    let perfumes = BehaviorRelay<[PerfumeNewDataSection.Model]>(value: [])
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: PerfumeNewCoordinator?
  var perfumeRepository: PerfumeRepository
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeNewCoordinator, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, from cellInput: CellInput, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let perfumes = PublishRelay<[Perfume]>()
    
    self.bindInput(cellInput: cellInput, perfumes: perfumes, disposeBag: disposeBag)
    self.bindOutput(output: output, perfumes: perfumes, disposeBag: disposeBag)
    self.fetchDatas(perfumes: perfumes, disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(cellInput: CellInput, perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
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
  
  private func bindOutput(output: Output, perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    perfumes.subscribe(onNext: { perfumes in
      let items = perfumes.map { PerfumeNewDataSection.Item(perfume: $0) }
      let model = PerfumeNewDataSection.Model(model: "perfumeNew", items: items)
      output.perfumes.accept([model])
    })
    .disposed(by: disposeBag)
  }
  
  private func fetchDatas(perfumes: PublishRelay<[Perfume]>, disposeBag: DisposeBag) {
    self.perfumeRepository.fetchPerfumesNew(size: nil)
      .subscribe(onNext: { data in
        guard let data = data else { return }
        perfumes.accept(data)
      })
      .disposed(by: disposeBag)
  }
}
