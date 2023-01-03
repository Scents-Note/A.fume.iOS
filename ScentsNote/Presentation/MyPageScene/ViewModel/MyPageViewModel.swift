//
//  MyPageViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay

final class MyPageViewModel {
  
  struct ScrollInput {
    let reviewCellDidTapEvent = PublishRelay<Int>()
    let perfumeCellDidTapEvent = PublishRelay<Int>()
  }
  
  struct Input {
    let viewWillAppearEvent: Observable<Void>
    let myPerfumeButtonDidTapEvent: Observable<Void>
    let wishListButtonDidTapEvent: Observable<Void>
    let loginButtonDidTapEvent: Observable<Void>
    let menuButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let selectedTab = BehaviorRelay<Int>(value: 0)
    let reviews = BehaviorRelay<[[ReviewInMyPage]]>(value: [])
    let perfumes = BehaviorRelay<[PerfumeInMyPage]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MyPageCoordinator?
  private let fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase
  private let fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase
  
  let scrollInput = ScrollInput()
  let output = Output()
  let loadData = PublishRelay<Void>()
  
  init(coordinator: MyPageCoordinator,
       fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase,
       fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase) {
    self.coordinator = coordinator
    self.fetchReviewsInMyPageUseCase = fetchReviewsInMyPageUseCase
    self.fetchPerfumesInMyPageUseCase = fetchPerfumesInMyPageUseCase
  }
  
  func transform(input: Input, disposeBag: DisposeBag){
    let selectedTab = PublishRelay<Int>()
    let reviews = PublishRelay<[[ReviewInMyPage]]>()
    let perfumes = PublishRelay<[PerfumeInMyPage]>()
    
    self.bindInput(input: input,
                   scrollInput: self.scrollInput,
                   loadData: self.loadData,
                   selectedTab: selectedTab,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: self.output,
                    selectedTab: selectedTab,
                    reviews: reviews,
                    perfumes: perfumes,
                    disposeBag: disposeBag)
    
    self.fetchDatas(loadData: self.loadData,
                     reviews: reviews,
                     perfumes: perfumes,
                     disposeBag: disposeBag)
    
  }
  
  private func bindInput(input: Input,
                         scrollInput: ScrollInput,
                         loadData: PublishRelay<Void>,
                         selectedTab: PublishRelay<Int>,
                         disposeBag: DisposeBag) {
    
    input.viewWillAppearEvent
      .bind(to: loadData)
      .disposed(by: disposeBag)
    
    input.myPerfumeButtonDidTapEvent
      .subscribe(onNext: {
        selectedTab.accept(0)
      })
      .disposed(by: disposeBag)
    
    input.wishListButtonDidTapEvent
      .subscribe(onNext: {
        selectedTab.accept(1)
      })
      .disposed(by: disposeBag)
    
    input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.onOnboardingFlow?()
      })
      .disposed(by: disposeBag)
    
    input.menuButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showMyPageMenuViewController()
      })
      .disposed(by: disposeBag)
    
    scrollInput.reviewCellDidTapEvent
      .subscribe(onNext: { [weak self] reviewIdx in
        self?.coordinator?.runPerfumeReviewFlow(reviewIdx: reviewIdx)
      })
      .disposed(by: disposeBag)
    
    scrollInput.perfumeCellDidTapEvent
      .subscribe(onNext: { [weak self] perfumeIdx in
        self?.coordinator?.runPerfumeDetailFlow(perfumeIdx: perfumeIdx)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          selectedTab: PublishRelay<Int>,
                          reviews: PublishRelay<[[ReviewInMyPage]]>,
                          perfumes: PublishRelay<[PerfumeInMyPage]>,
                          disposeBag: DisposeBag) {
    
    selectedTab
      .bind(to: output.selectedTab)
      .disposed(by: disposeBag)
    
    reviews
      .bind(to: output.reviews)
      .disposed(by: disposeBag)
    
    perfumes
      .bind(to: output.perfumes)
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(loadData: PublishRelay<Void>,
                          reviews: PublishRelay<[[ReviewInMyPage]]>,
                          perfumes: PublishRelay<[PerfumeInMyPage]>,
                          disposeBag: DisposeBag) {
    
    loadData
      .subscribe(onNext: { [weak self] in
        self?.fetchReviewsInMyPageUseCase.execute()
          .subscribe(onNext: { result in
            reviews.accept(result)
          }, onError: { error in
            reviews.accept([])
            Log(error)
          })
          .disposed(by: disposeBag)
        
        self?.fetchPerfumesInMyPageUseCase.execute()
          .subscribe(onNext: { result in
            perfumes.accept(result)
          }, onError: { error in
            perfumes.accept([])
            Log(error)
          })
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)
  }
  
  
}

extension MyPageViewModel: MyPageMenuDismissDelegate {
  func reloadData() {
    self.loadData.accept(())
  }
}
