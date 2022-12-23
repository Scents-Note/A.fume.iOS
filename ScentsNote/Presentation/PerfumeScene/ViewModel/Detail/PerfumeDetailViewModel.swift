//
//  PerfumeViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/15.
//

import RxSwift
import RxRelay

final class PerfumeDetailViewModel {
  
  
  // TODO: 로직 전면 리팩토링
  struct CellInput {
    let perfumeDidTapEvent = PublishRelay<Perfume>()
  }
  
  struct Input {
    let reviewButtonDidTapEvent: Observable<Void>
  }
  
  struct ScrollInput {
    let tabButtonTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let models = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = BehaviorRelay<Int>(value: 0)
  }
  
  private weak var coordinator: PerfumeDetailCoordinator?
  private let fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase
  private let fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase
//  private let
  
  let input = ScrollInput()
  let cellInput = CellInput()
  let output = Output()
  
  private let perfumeIdx: Int
  
  init(coordinator: PerfumeDetailCoordinator,
       fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase,
       fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase,
       perfumeIdx: Int) {
    self.coordinator = coordinator
    self.fetchPerfumeDetailUseCase = fetchPerfumeDetailUseCase
    self.fetchReviewsInPerfumeDetailUseCase = fetchReviewsInPerfumeDetailUseCase
    self.perfumeIdx = perfumeIdx
  }
  
  func transform(input: Input, disposeBag: DisposeBag) {
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let reviews = PublishRelay<[ReviewInPerfumeDetail]>()
    let pageViewPosition = PublishRelay<Int>()
    
    self.bindInput(input: input,
                   scrollInput: self.input,
                   cellInput: self.cellInput,
                   pageViewPosition: pageViewPosition,
                   perfumeDetail: perfumeDetail,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: self.output,
                    pageViewPosition: pageViewPosition,
                    perfumeDetail: perfumeDetail,
                    reviews: reviews,
                    disposeBag: disposeBag)
    
    self.fetchDatas(perfumeDetail: perfumeDetail, reviews: reviews, disposeBag: disposeBag)
  }
  
  private func bindInput(input: Input,
                         scrollInput: ScrollInput,
                         cellInput: CellInput,
                         pageViewPosition: PublishRelay<Int>,
                         perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                         disposeBag: DisposeBag) {
    
    input.reviewButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let self = self, let detail = perfumeDetail.value else { return }
        self.coordinator?.runPerfumeReviewFlow?(detail)
      })
      .disposed(by: disposeBag)
    
    cellInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow?(perfume.perfumeIdx)
      })
      .disposed(by: disposeBag)

    scrollInput.tabButtonTapEvent
      .subscribe(onNext: { idx in
        pageViewPosition.accept(idx)
      })
      .disposed(by: disposeBag)
    
  }
  
  private func bindOutput(output: Output,
                          pageViewPosition: PublishRelay<Int>,
                          perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                          reviews: PublishRelay<[ReviewInPerfumeDetail]>,
                          disposeBag: DisposeBag) {
    
    pageViewPosition
      .bind(to: output.pageViewPosition)
      .disposed(by: disposeBag)
    
    perfumeDetail
      .bind(to: output.perfumeDetail)
      .disposed(by: disposeBag)
    
    perfumeDetail.withLatestFrom(output.models) { detail, models in
      guard let detail = detail else { return [] }
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
  
  private func fetchDatas(perfumeDetail: BehaviorRelay<PerfumeDetail?>, reviews: PublishRelay<[ReviewInPerfumeDetail]>, disposeBag: DisposeBag) {
    self.fetchPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { detail in
        perfumeDetail.accept(detail)
      })
      .disposed(by: disposeBag)
    
    self.fetchReviewsInPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { result in
        reviews.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
  }
  
  func clickReport(reviewIdx: Int) {
    Log("sefuhsekf")
    self.coordinator?.showReviewReportPopupViewController(reviewIdx: reviewIdx)
  }
}
