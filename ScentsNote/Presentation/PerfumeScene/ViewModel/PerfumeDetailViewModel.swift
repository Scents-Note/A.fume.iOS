//
//  PerfumeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import RxSwift
import RxRelay

final class PerfumeDetailViewModel {
  
  struct Input {}
  struct Output {
    var models = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
  }
  
  private weak var coordinator: PerfumeDetailCoordinator?
  private var perfumeRepository: PerfumeRepository
  private var perfumeIdx: Int
  
  init(coordinator: PerfumeDetailCoordinator, perfumeRepository: PerfumeRepository, perfumeIdx: Int) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.perfumeIdx = perfumeIdx
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    
    let perfumeDetail = PublishRelay<PerfumeDetail>()

    
    let output = Output()
    
    self.bindOutput(output: output, perfumeDetail: perfumeDetail, disposeBag: disposeBag)
    
    self.perfumeRepository.fetchPerfumeDetail(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { detail in
        guard let detail = detail else { return }
        perfumeDetail.accept(detail)
      })
      .disposed(by: disposeBag)
    
    return output
    
    
  }
  
  private func bindOutput(output: Output, perfumeDetail: PublishRelay<PerfumeDetail>, disposeBag: DisposeBag) {
    perfumeDetail.withLatestFrom(output.models) { detail, models in
      let titleItems = PerfumeDetailDataSection.PerfumeDetailItem.title(detail)
      let titleSection = PerfumeDetailDataSection.Model(model: .title, items: [titleItems])
      let contentItems = PerfumeDetailDataSection.PerfumeDetailItem.content(detail)
      let contentSection = PerfumeDetailDataSection.Model(model: .content, items: [contentItems])
      return [titleSection, contentSection]
    }
    .bind(to: output.models)
    .disposed(by: disposeBag)
  }
  
}
