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
    let reviewCellReportTapEvent = PublishRelay<Int>()
    let comparePriceTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let perfumeDetailDatas = BehaviorRelay<[PerfumeDetailDataSection.Model]>(value: [])
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = BehaviorRelay<Int>(value: 0)
    let isLiked = PublishRelay<Bool>()
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
    let perfumeDetail = BehaviorRelay<PerfumeDetail?>(value: nil)
    let isLiked = BehaviorRelay<Bool>(value: true)
    let reviews = BehaviorRelay<[ReviewInPerfumeDetail]>(value: [])
    let pageViewPosition = PublishRelay<Int>()
    let showToast = PublishRelay<Void>()
    
    self.bindInput(input: input,
                   childInput: childInput,
                   pageViewPosition: pageViewPosition,
                   perfumeDetail: perfumeDetail,
                   isLiked: isLiked,
                   reviews: reviews,
                   showToast: showToast)
    
    self.bindOutput(output: output,
                    pageViewPosition: pageViewPosition,
                    perfumeDetail: perfumeDetail,
                    isLiked: isLiked,
                    reviews: reviews,
                    showToast: showToast)
    
    self.fetchDatas(perfumeDetail: perfumeDetail,
                    reviews: reviews,
                    isLiked: isLiked)
  }
  
  private func bindInput(input: Input,
                         childInput: ChildInput,
                         pageViewPosition: PublishRelay<Int>,
                         perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                         isLiked: BehaviorRelay<Bool>,
                         reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                         showToast: PublishRelay<Void>) {
    
    input.likeButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.handlePerfumeLike(isLiked: isLiked)
      })
      .disposed(by: self.disposeBag)
    
    input.reviewButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.handleReviewButton()
      })
      .disposed(by: self.disposeBag)
    
    input.tabButtonTapEvent
      .subscribe(onNext: { idx in
        pageViewPosition.accept(idx)
      })
      .disposed(by: self.disposeBag)
    
    input.showToastEvent
      .bind(to: showToast)
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
        self?.handleReviewLike(reviewIdx: reviewIdx, reviews: reviews)
      })
      .disposed(by: self.disposeBag)
    
    childInput.reviewCellReportTapEvent
      .subscribe(onNext: { [weak self] reviewIdx in
        self?.handleReviewReport(reviewIdx: reviewIdx)
      })
      .disposed(by: self.disposeBag)
    
      childInput.comparePriceTapEvent
          .subscribe(onNext: { [weak self] _ in
              self?.handleComparePrice()
          }).disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          pageViewPosition: PublishRelay<Int>,
                          perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                          isLiked: BehaviorRelay<Bool>,
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
    
    isLiked
      .bind(to: output.isLiked)
      .disposed(by: disposeBag)
    
    reviews
      .bind(to: output.reviews)
      .disposed(by: disposeBag)
    
    showToast
      .bind(to: output.showToast)
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(perfumeDetail: BehaviorRelay<PerfumeDetail?>,
                          reviews: BehaviorRelay<[ReviewInPerfumeDetail]>,
                          isLiked: BehaviorRelay<Bool>) {
    
    self.isLoggedIn = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn)
    
    self.fetchPerfumeDetailUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { [weak self] perfumeDetailFetched in
        self?.perfumeDetail = perfumeDetailFetched
        perfumeDetail.accept(perfumeDetailFetched)
        isLiked.accept(perfumeDetailFetched.isLiked)
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
  
  func runPerfumeReview() {
    guard let perfumeDetail = self.perfumeDetail else { return }
    if perfumeDetail.reviewIdx == 0 {
      self.coordinator?.runPerfumeReviewFlow?(perfumeDetail)
    } else {
      self.coordinator?.runPerfumeReviewFlowWithReviewIdx?(perfumeDetail.reviewIdx)
    }
  }
  
  func handlePerfumeLike(isLiked: BehaviorRelay<Bool>) {
    if self.isLoggedIn == true {
      self.updatePerfumeLike(isLiked: isLiked)
    } else {
      self.coordinator?.showPopup()
    }
  }
  
  
  func updatePerfumeLike(isLiked: BehaviorRelay<Bool>) {
    self.updatePerfumeLikeUseCase.execute(perfumeIdx: self.perfumeIdx)
      .subscribe(onNext: { _ in
        isLiked.accept(!isLiked.value)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
  
  func handleReviewButton() {
    if self.isLoggedIn == true {
      self.runPerfumeReview()
    } else {
      self.coordinator?.showPopup()
    }
  }
  
  func handleReviewLike(reviewIdx: Int, reviews: BehaviorRelay<[ReviewInPerfumeDetail]>) {
    if self.isLoggedIn == true {
      self.updateReviewLike(reviewIdx: reviewIdx, reviews: reviews)
    } else {
      self.coordinator?.showPopup()
    }
  }
  
  func updateReviewLike(reviewIdx: Int, reviews: BehaviorRelay<[ReviewInPerfumeDetail]>) {
    self.updateReviewLikeUseCase.execute(reviewIdx: reviewIdx)
      .subscribe(onNext: { [weak self] _ in
        let updated = self?.reviewsUpdated(reviewIdx: reviewIdx, reviews: reviews.value)
        guard let updated = updated else { return }
        reviews.accept(updated)
      }) { error in
        Log(error)
      }
      .disposed(by: self.disposeBag)
  }
  
  func reviewsUpdated(reviewIdx: Int, reviews: [ReviewInPerfumeDetail]) -> [ReviewInPerfumeDetail] {
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
  
  func handleReviewReport(reviewIdx: Int) {
    if self.isLoggedIn == true {
      self.coordinator?.showReviewReportPopupViewController(reviewIdx: reviewIdx)
    } else {
      self.coordinator?.showPopup()
    }
  }
    
    func handleComparePrice() {
        self.coordinator?.showComparePriceViewController()
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
