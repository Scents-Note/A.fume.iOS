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
  struct InfoInput {
    let suggestionDidTapEvent = PublishRelay<Void>()
    let perfumeDidTapEvent = PublishRelay<Perfume>()
  }
  
  struct Input {
    let viewWillAppearEvent: Observable<Void>
    let viewDidDisappearEvent: Observable<Void>
    let likeButtonDidTapEvent: Observable<Void>
    let reviewButtonDidTapEvent: Observable<Void>
  }
  
  struct ScrollInput {
    let tabButtonTapEvent = PublishRelay<Int>()
  }
  
  struct ReviewInput {
    let reviewCellHeartTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let models = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = BehaviorRelay<Int>(value: 0)
    let updatePerfumeLike = PublishRelay<Bool>()
    let toast = PublishRelay<Void>()
  }
  
  private weak var coordinator: PerfumeDetailCoordinator?
  private let fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase
  private let fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let updateReviewLikeUseCase: UpdateReviewLikeUseCase
//  private let
  
  let input = ScrollInput()
  let reviewInput = ReviewInput()
  let infoInput = InfoInput()
  let output = Output()
  
  private let perfumeIdx: Int
  private let toast = PublishRelay<Void>()
  private var perfumeDetail: PerfumeDetail?
  private var isLiked = false
  
  init(coordinator: PerfumeDetailCoordinator?,
       fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase,
       fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase,
       updateReviewLikeUseCase: UpdateReviewLikeUseCase,
       perfumeIdx: Int) {
    self.coordinator = coordinator
    self.fetchPerfumeDetailUseCase = fetchPerfumeDetailUseCase
    self.fetchReviewsInPerfumeDetailUseCase = fetchReviewsInPerfumeDetailUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    self.updateReviewLikeUseCase = updateReviewLikeUseCase
    self.perfumeIdx = perfumeIdx
  }
  
  func transform(input: Input, disposeBag: DisposeBag) {
    let loadView = PublishRelay<Void>()
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let updatePerfumeLike = PublishRelay<Bool>()
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = PublishRelay<Int>()
    
    self.bindInput(input: input,
                   scrollInput: self.input,
                   reviewInput: self.reviewInput,
                   infoInput: self.infoInput,
                   loadView: loadView,
                   pageViewPosition: pageViewPosition,
                   perfumeDetail: perfumeDetail,
                   updatePerfumeLike: updatePerfumeLike,
                   reviews: reviews,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: self.output,
                    pageViewPosition: pageViewPosition,
                    perfumeDetail: perfumeDetail,
                    updatePerfumeLike: updatePerfumeLike,
                    reviews: reviews,
                    toast: self.toast,
                    disposeBag: disposeBag)
    
    self.fetchDatas(loadView: loadView,
                    perfumeDetail: perfumeDetail,
                    reviews: reviews,
                    disposeBag: disposeBag)
  }
  
  private func bindInput(input: Input,
                         scrollInput: ScrollInput,
                         reviewInput: ReviewInput,
                         infoInput: InfoInput,
                         loadView: PublishRelay<Void>,
                         pageViewPosition: PublishRelay<Int>,
                         perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                         updatePerfumeLike: PublishRelay<Bool>,
                         reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                         disposeBag: DisposeBag) {
    
    input.viewWillAppearEvent
      .bind(to: loadView)
      .disposed(by: disposeBag)
    
    input.viewDidDisappearEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.finishFlow?()
      })
      .disposed(by: disposeBag)
    
    input.likeButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.updatePerfumeLike(perfumeIdx: self?.perfumeDetail?.perfumeIdx,
                                updatePerfumeLike: updatePerfumeLike,
                                disposeBag: disposeBag)
      })
      .disposed(by: disposeBag)
    
    input.reviewButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.runPerfumeReview()
        
      })
      .disposed(by: disposeBag)
    
    infoInput.suggestionDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runWebFlow(with: WebURL.perfumeDetailSuggestion)
      })
      .disposed(by: disposeBag)

    
    infoInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        self?.coordinator?.runPerfumeDetailFlow?(perfume.perfumeIdx)
      })
      .disposed(by: disposeBag)
    
    reviewInput.reviewCellHeartTapEvent
      .subscribe(onNext: { [weak self] reviewIdx in
        self?.updateReviewLike(reviewIdx: reviewIdx, reviews: reviews, disposeBag: disposeBag)
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
                          updatePerfumeLike: PublishRelay<Bool>,
                          reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                          toast: PublishRelay<Void>,
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
    
    updatePerfumeLike
      .bind(to: output.updatePerfumeLike)
      .disposed(by: disposeBag)
    
    reviews
      .bind(to: output.reviews)
      .disposed(by: disposeBag)

    toast
      .bind(to: output.toast)
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(loadView: PublishRelay<Void>,
                          perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                          reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                          disposeBag: DisposeBag) {
    
    loadView.subscribe(onNext: { [weak self] in
      guard let perfumeIdx = self?.perfumeIdx else { return }
      self?.fetchPerfumeDetailUseCase.execute(perfumeIdx: perfumeIdx)
        .subscribe(onNext: { [weak self] detail in
          self?.perfumeDetail = detail
          self?.isLiked = detail.isLiked
          perfumeDetail.accept(detail)
        })
        .disposed(by: disposeBag)
      
      self?.fetchReviewsInPerfumeDetailUseCase.execute(perfumeIdx: perfumeIdx)
        .subscribe(onNext: { result in
          reviews.accept(result)
        }, onError: { error in
          Log(error)
        })
        .disposed(by: disposeBag)
    })
    .disposed(by: disposeBag)
    
  }
  
  func runPerfumeReview() {
    guard let detail = perfumeDetail else { return }
    if detail.reviewIdx == 0 {
      self.coordinator?.runPerfumeReviewFlow?(detail)
    } else {
      self.coordinator?.runPerfumeReviewFlowWithReviewIdx?(detail.reviewIdx)
    }
  }
  
  func updatePerfumeLike(perfumeIdx: Int?,
                         updatePerfumeLike: PublishRelay<Bool>,
                         disposeBag: DisposeBag) {
    guard let perfumeIdx = perfumeIdx else { return }
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: perfumeIdx)
      .subscribe(onNext: { [weak self] _ in
        guard let isLiked = self?.isLiked else { return }
        updatePerfumeLike.accept(!isLiked)
        self?.isLiked = !isLiked
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)

  }
  
  func updateReviewLike(reviewIdx: Int,
                        reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                        disposeBag: DisposeBag) {
    self.updateReviewLikeUseCase.execute(reviewIdx: reviewIdx)
      .subscribe(onNext: { [weak self] _ in
        let updated = self?.toggleReviewLike(reviewIdx: reviewIdx, reviews: reviews.value)
        guard let updated = updated else { return }
        reviews.accept(updated)
      }) { error in
        Log(error)
      }
      .disposed(by: disposeBag)
  }
  
  func toggleReviewLike(reviewIdx: Int, reviews: [ReviewInPerfumeDetail]) -> [ReviewInPerfumeDetail] {
    reviews.map {
      guard $0.idx != reviewIdx else {
        var review = $0
        if review.isLiked {
          review.likeCount -= 1
        } else {
          review.likeCount += 1
        }
        review.isLiked = !review.isLiked
        return review
      }
      return $0
    }
  }
  
  func clickReport(reviewIdx: Int) {
    self.coordinator?.showReviewReportPopupViewController(reviewIdx: reviewIdx)
  }
  
  func clickHeart(reviewIdx: Int) {
    self.reviewInput.reviewCellHeartTapEvent.accept(reviewIdx)
  }
  
  func showToast() {
    self.toast.accept(())
  }
}
