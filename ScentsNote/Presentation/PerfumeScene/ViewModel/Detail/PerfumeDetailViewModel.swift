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
    let models = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
  }
  
  private weak var coordinator: PerfumeDetailCoordinator?
  private var perfumeIdx: Int
  private var fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase
  
  init(coordinator: PerfumeDetailCoordinator, fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase, perfumeIdx: Int) {
    self.coordinator = coordinator
    self.fetchPerfumeDetailUseCase = fetchPerfumeDetailUseCase
    self.perfumeIdx = perfumeIdx
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let perfumeDetail = PublishRelay<PerfumeDetail>()
    let output = Output()
    self.bindOutput(output: output, perfumeDetail: perfumeDetail, disposeBag: disposeBag)
    self.fetchDatas(perfumeDetail: perfumeDetail, disposeBag: disposeBag)
    return output
  }
  
  private func fetchDatas(perfumeDetail: PublishRelay<PerfumeDetail>, disposeBag: DisposeBag) {
    self.fetchPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { detail in
        guard let detail = detail else { return }
        perfumeDetail.accept(detail)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output, perfumeDetail: PublishRelay<PerfumeDetail>, disposeBag: DisposeBag) {
    perfumeDetail
      .bind(to: output.perfumeDetail)
      .disposed(by: disposeBag)
    
    perfumeDetail.withLatestFrom(output.models) { detail, models in
      let titleItems = PerfumeDetailDataSection.Item.title(detail)
      let titleSection = PerfumeDetailDataSection.Model(model: .title, items: [titleItems])
      let contentItems = PerfumeDetailDataSection.Item.content(detail)
      let contentSection = PerfumeDetailDataSection.Model(model: .content, items: [contentItems])
      return [titleSection, contentSection]
    }
    .bind(to: output.models)
    .disposed(by: disposeBag)
    
    
  }
  
}
