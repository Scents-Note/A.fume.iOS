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
    let reviewButtonDidTapEvent = PublishRelay<PerfumeInMyPage>()
    let loginButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Input {
    let viewWillAppearEvent = PublishRelay<Void>()
    let myPerfumeButtonDidTapEvent = PublishRelay<Void>()
    let wishListButtonDidTapEvent = PublishRelay<Void>()
    let menuButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let selectedTab = BehaviorRelay<Int>(value: 0)
    let loginState = BehaviorRelay<Bool>(value: false)
    let reviews = BehaviorRelay<[[ReviewInMyPage]]>(value: [])
    let perfumes = BehaviorRelay<[PerfumeInMyPage]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MyPageCoordinator?
  private let fetchUserDefaultUseCase: FetchUserDefaultUseCase
  private let fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase
  private let fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase
  private let disposeBag = DisposeBag()
  let input = Input()
  let scrollInput = ScrollInput()
  let output = Output()
  
  init(coordinator: MyPageCoordinator,
       fetchUserDefaultUseCase: FetchUserDefaultUseCase,
       fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase,
       fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase) {
    self.coordinator = coordinator
    self.fetchUserDefaultUseCase = fetchUserDefaultUseCase
    self.fetchReviewsInMyPageUseCase = fetchReviewsInMyPageUseCase
    self.fetchPerfumesInMyPageUseCase = fetchPerfumesInMyPageUseCase
    
    self.transform(input: self.input, scrollInput: self.scrollInput, output: self.output)
  }
  
  func transform(input: Input, scrollInput: ScrollInput, output: Output){
    let loadData = PublishRelay<Void>()
    let selectedTab = PublishRelay<Int>()
    let loginState = PublishRelay<Bool>()
    let reviews = PublishRelay<[[ReviewInMyPage]]>()
    let perfumes = PublishRelay<[PerfumeInMyPage]>()
    
    self.bindInput(input: input,
                   scrollInput: scrollInput,
                   loadData: loadData,
                   selectedTab: selectedTab)
    
    self.bindOutput(output: output,
                    selectedTab: selectedTab,
                    loginState: loginState,
                    reviews: reviews,
                    perfumes: perfumes)
    
    self.fetchDatas(loadData: loadData,
                    loginState: loginState,
                     reviews: reviews,
                     perfumes: perfumes)
    
  }
  
  private func bindInput(input: Input,
                         scrollInput: ScrollInput,
                         loadData: PublishRelay<Void>,
                         selectedTab: PublishRelay<Int>) {
    
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
    
    scrollInput.reviewButtonDidTapEvent
      .subscribe(onNext: { [weak self] perfume in
        if perfume.reviewIdx == 0 {
          self?.coordinator?.runPerfumeReviewFlow(perfumeDetail: perfume.toPerfumeDetail())
        } else {
          self?.coordinator?.runPerfumeReviewFlow(reviewIdx: perfume.reviewIdx)
        }
      })
      .disposed(by: disposeBag)
    
    scrollInput.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.runOnboardingFlow?()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          selectedTab: PublishRelay<Int>,
                          loginState: PublishRelay<Bool>,
                          reviews: PublishRelay<[[ReviewInMyPage]]>,
                          perfumes: PublishRelay<[PerfumeInMyPage]>) {
    
    selectedTab
      .bind(to: output.selectedTab)
      .disposed(by: disposeBag)
    
    loginState
      .bind(to: output.loginState)
      .disposed(by: disposeBag)

    reviews
      .bind(to: output.reviews)
      .disposed(by: disposeBag)
    
    perfumes
      .bind(to: output.perfumes)
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(loadData: PublishRelay<Void>,
                          loginState: PublishRelay<Bool>,
                          reviews: PublishRelay<[[ReviewInMyPage]]>,
                          perfumes: PublishRelay<[PerfumeInMyPage]>) {
    
    loadData
      .subscribe(onNext: { [weak self] in
        let isLoggedIn = self?.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn) ?? false
        
        loginState.accept(isLoggedIn)
        if isLoggedIn {
          self?.fetchReviews(reviews: reviews)
          self?.fetchPerfumes(perfumes: perfumes)
        } else {
          reviews.accept([])
          perfumes.accept([])
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchReviews(reviews: PublishRelay<[[ReviewInMyPage]]>) {
    self.fetchReviewsInMyPageUseCase.execute()
      .subscribe(onNext: { result in
        reviews.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func fetchPerfumes(perfumes: PublishRelay<[PerfumeInMyPage]>) {
    self.fetchPerfumesInMyPageUseCase.execute()
      .subscribe(onNext: { result in
        perfumes.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
}

extension MyPageViewModel: MyPageMenuDismissDelegate {
  func reloadData() {
    self.input.viewWillAppearEvent.accept(())
  }
}
