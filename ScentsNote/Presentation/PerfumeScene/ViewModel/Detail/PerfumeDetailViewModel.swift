//
//  PerfumeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import RxSwift
import RxRelay

final class PerfumeDetailViewModel {
  
  struct Input {
    let tabButtonTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let models = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let reviews = BehaviorRelay<[Review]>(value: [])
    let pageViewPosition = BehaviorRelay<Int>(value: 0)
  }
  
  let input = Input()
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
  
  func transform(disposeBag: DisposeBag) {
    let perfumeDetail = PublishRelay<PerfumeDetail>()
    let reviews = PublishRelay<[Review]>()
    let pageViewPosition = PublishRelay<Int>()
    
    self.bindInput(input: self.input, pageViewPosition: pageViewPosition, disposeBag: disposeBag)
    self.bindOutput(output: self.output, pageViewPosition: pageViewPosition, perfumeDetail: perfumeDetail, reviews: reviews, disposeBag: disposeBag)
    self.fetchDatas(perfumeDetail: perfumeDetail, reviews: reviews, disposeBag: disposeBag)
  }
  
  private func bindInput(input: Input,
                         pageViewPosition: PublishRelay<Int>,
                         disposeBag: DisposeBag) {
    input.tabButtonTapEvent
      .subscribe(onNext: { idx in
        pageViewPosition.accept(idx)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          pageViewPosition: PublishRelay<Int>,
                          perfumeDetail: PublishRelay<PerfumeDetail>,
                          reviews: PublishRelay<[Review]>,
                          disposeBag: DisposeBag) {
    
    pageViewPosition
      .bind(to: output.pageViewPosition)
      .disposed(by: disposeBag)

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
  
  private func fetchDatas(perfumeDetail: PublishRelay<PerfumeDetail>, reviews: PublishRelay<[Review]>, disposeBag: DisposeBag) {
    self.fetchPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { detail in
        perfumeDetail.accept(detail)
      })
      .disposed(by: disposeBag)
    
    self.perfumeRepository.fetchReviews(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { result in
        reviews.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)

  }
  
}
