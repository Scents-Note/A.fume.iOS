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
    let reviews = BehaviorRelay<[Review]>(value: [])
  }
  
  let output = Output()
  private weak var coordinator: PerfumeDetailCoordinator?
  private let perfumeIdx: Int
  private let fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase
  private let perfumeRepository: PerfumeRepository
  
  init(coordinator: PerfumeDetailCoordinator,
       fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase,
       perfumeRepository: PerfumeRepository,
       perfumeIdx: Int) {
    self.coordinator = coordinator
    self.fetchPerfumeDetailUseCase = fetchPerfumeDetailUseCase
    self.perfumeRepository = perfumeRepository
    self.perfumeIdx = perfumeIdx
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let perfumeDetail = PublishRelay<PerfumeDetail>()
    let reviews = PublishRelay<[Review]>()
    self.bindOutput(output: output, perfumeDetail: perfumeDetail, reviews: reviews, disposeBag: disposeBag)
    self.fetchDatas(perfumeDetail: perfumeDetail, reviews: reviews, disposeBag: disposeBag)
    return output
  }
  
  private func fetchDatas(perfumeDetail: PublishRelay<PerfumeDetail>, reviews: PublishRelay<[Review]>, disposeBag: DisposeBag) {
    self.fetchPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { detail in
        perfumeDetail.accept(detail)
      })
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchReviews(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { result in
        Log(result)
        reviews.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)

  }
  
  private func bindOutput(output: Output, perfumeDetail: PublishRelay<PerfumeDetail>, reviews: PublishRelay<[Review]>, disposeBag: DisposeBag) {
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
    
    reviews
      .bind(to: output.reviews)
      .disposed(by: disposeBag)
    
  }
  
}
