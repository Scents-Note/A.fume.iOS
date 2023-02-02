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
    let likeButtonDidTapEvent = PublishRelay<Void>()
    let reviewButtonDidTapEvent = PublishRelay<Void>()
    let tabButtonTapEvent = PublishRelay<Int>()
    let showToastEvent = PublishRelay<Void>()
  }
  
  /// 하위 뷰 `Info` & `review` 의 Input
  struct ChildInput {
    let suggestionDidTapEvent = PublishRelay<Void>()
    let perfumeDidTapEvent = PublishRelay<Int>()
    let reviewCellHeartTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let perfumeDetailDatas = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = BehaviorRelay<Int>(value: 0)
    let updatePerfumeLike = PublishRelay<Bool>()
    let showToast = PublishRelay<Void>()
  }
  
  private weak var coordinator: PerfumeDetailCoordinator?
  private let fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase
  private let fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase
  private let updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase
  private let updateReviewLikeUseCase: UpdateReviewLikeUseCase
  private let fetchUserDefaultUseCase: FetchUserDefaultUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let childInput = ChildInput()
  let output = Output()
  let perfumeIdx: Int
  var perfumeDetail: PerfumeDetail?
  var isLoggedIn: Bool?
  
  init(coordinator: PerfumeDetailCoordinator?,
       fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase,
       fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase,
       updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase,
       updateReviewLikeUseCase: UpdateReviewLikeUseCase,
       fetchUserDefaultUseCase: FetchUserDefaultUseCase,
       perfumeIdx: Int) {
    self.coordinator = coordinator
    self.fetchPerfumeDetailUseCase = fetchPerfumeDetailUseCase
    self.fetchReviewsInPerfumeDetailUseCase = fetchReviewsInPerfumeDetailUseCase
    self.updatePerfumeLikeUseCase = updatePerfumeLikeUseCase
    self.updateReviewLikeUseCase = updateReviewLikeUseCase
    self.fetchUserDefaultUseCase = fetchUserDefaultUseCase
    self.perfumeIdx = perfumeIdx
    
    self.transform(input: self.input, childInput: self.childInput, output: self.output)
  }
  
  func transform(input: Input, childInput: ChildInput, output: Output) {
    let loadView = PublishRelay<Void>()
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let updatePerfumeLike = BehaviorRelay<Bool>(value: false)
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = PublishRelay<Int>()
    let showToast = PublishRelay<Void>()
    
    self.bindInput(input: input,
                   childInput: childInput,
                   pageViewPosition: pageViewPosition,
                   perfumeDetail: perfumeDetail,
                   updatePerfumeLike: updatePerfumeLike,
                   reviews: reviews,
                   showToast: showToast)
    
    self.bindOutput(output: output,
                    pageViewPosition: pageViewPosition,
                    perfumeDetail: perfumeDetail,
                    updatePerfumeLike: updatePerfumeLike,
                    reviews: reviews,
                    showToast: showToast)
    
    self.fetchDatas(perfumeDetail: perfumeDetail,
                    reviews: reviews)
  }
  
  private func bindInput(input: Input,
                         childInput: ChildInput,
                         pageViewPosition: PublishRelay<Int>,
                         perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                         updatePerfumeLike: BehaviorRelay<Bool>,
                         reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                         showToast: PublishRelay<Void>) {
    
    input.likeButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.updatePerfumeLike(updatePerfumeLike: updatePerfumeLike)
      })
      .disposed(by: self.disposeBag)
    
    input.reviewButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.handleReviewButton(perfumeDetail: perfumeDetail.value!)
      })
      .disposed(by: self.disposeBag)
    
    input.tabButtonTapEvent
      .subscribe(onNext: { idx in
        pageViewPosition.accept(idx)
      })
      .disposed(by: self.disposeBag)
    
    childInput.suggestionDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runWebFlow(with: WebURL.perfumeDetailSuggestion)
      })
      .disposed(by: self.disposeBag)
    
    
    childInput.perfumeDidTapEvent
      .subscribe(onNext: { [weak self] perfumeIdx in
        self?.coordinator?.runPerfumeDetailFlow?(perfumeIdx)
      })
      .disposed(by: self.disposeBag)
    
    childInput.reviewCellHeartTapEvent
      .subscribe(onNext: { [weak self] reviewIdx in
        self?.updateReviewLike(reviewIdx: reviewIdx, reviews: reviews)
      })
      .disposed(by: self.disposeBag)
    
    
  }
  
  private func bindOutput(output: Output,
                          pageViewPosition: PublishRelay<Int>,
                          perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                          updatePerfumeLike: BehaviorRelay<Bool>,
                          reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                          showToast: PublishRelay<Void>) {
    
    pageViewPosition
      .bind(to: output.pageViewPosition)
      .disposed(by: disposeBag)
    
    perfumeDetail
      .subscribe(onNext: { detail in
        output.perfumeDetail.accept(detail)
        output.pageViewPosition.accept(0)
        output.perfumeDetailDatas.accept(detail?.toDataSources() ?? [])
      })
      .disposed(by: disposeBag)
    
    updatePerfumeLike
      .bind(to: output.updatePerfumeLike)
      .disposed(by: disposeBag)
    
    reviews
      .bind(to: output.reviews)
      .disposed(by: disposeBag)
    
    showToast
      .bind(to: output.showToast)
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                          reviews: BehaviorRelay<[ReviewInPerfumeDetail]>) {
    
    self.isLoggedIn = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn)
    
    self.fetchPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { [weak self] perfumeDetailFetched in
        self?.perfumeDetail = perfumeDetailFetched
        perfumeDetail.accept(perfumeDetailFetched)
      })
      .disposed(by: self.disposeBag)
    
    self.fetchReviewsInPerfumeDetailUseCase.execute(perfumeIdx: perfumeIdx)
      .subscribe(onNext: { reviewsFetched in
        reviews.accept(reviewsFetched)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  func runPerfumeReview(perfumeDetail: PerfumeDetail) {
    if perfumeDetail.reviewIdx == 0 {
      self.coordinator?.runPerfumeReviewFlow?(perfumeDetail)
    } else {
      self.coordinator?.runPerfumeReviewFlowWithReviewIdx?(perfumeDetail.reviewIdx)
    }
  }
  
  func updatePerfumeLike(updatePerfumeLike: BehaviorRelay<Bool>) {
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { _ in
        let isLiked = updatePerfumeLike.value
        updatePerfumeLike.accept(!isLiked)
      }, onError: { [weak self] error in
        self?.coordinator?.showPopup()
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
  
  func updateReviewLike(reviewIdx: Int,
                        reviews: BehaviorRelay<[ReviewInPerfumeDetail]>) {
    self.updateReviewLikeUseCase.execute(reviewIdx: reviewIdx)
      .subscribe(onNext: { [weak self] _ in
        let updated = self?.toggleReviewLike(reviewIdx: reviewIdx, reviews: reviews.value)
        guard let updated = updated else { return }
        reviews.accept(updated)
      }) { [weak self] error in
        self?.coordinator?.showPopup()
        Log(error)
      }
      .disposed(by: self.disposeBag)
  }
  
  func handleReviewButton(perfumeDetail: PerfumeDetail) {
    if self.isLoggedIn == true {
      self.runPerfumeReview(perfumeDetail: perfumeDetail)
    } else {
      self.coordinator?.showPopup()
    }
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
    if self.isLoggedIn == true {
      self.coordinator?.showReviewReportPopupViewController(reviewIdx: reviewIdx)
    } else {
      self.coordinator?.showPopup()
    }
  }
  
  func clickHeart(reviewIdx: Int) {
    self.childInput.reviewCellHeartTapEvent.accept(reviewIdx)
  }
  
  func showToast() {
    self.input.showToastEvent.accept(())
  }
}

extension PerfumeDetailViewModel: LabelPopupDelegate {
  func confirm() {
    self.coordinator?.runOnboardingFlow?()
  }
}
