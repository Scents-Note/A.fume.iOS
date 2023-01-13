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
    let viewWillAppearEvent: Observable<Void>
    let myPerfumeButtonDidTapEvent: Observable<Void>
    let wishListButtonDidTapEvent: Observable<Void>
    let loginButtonDidTapEvent: Observable<Void>
    let menuButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let selectedTab = BehaviorRelay<Int>(value: 0)
    let loginState = BehaviorRelay<Bool>(value: true)
    let reviews = BehaviorRelay<[[ReviewInMyPage]]>(value: [])
    let perfumes = BehaviorRelay<[PerfumeInMyPage]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MyPageCoordinator?
  private let fetchUserDefaultUseCase: FetchUserDefaultUseCase
  private let fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase
  private let fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase
  
  let scrollInput = ScrollInput()
  let output = Output()
  let loadData = PublishRelay<Void>()
  var isLoggedIn = false
  
  init(coordinator: MyPageCoordinator,
       fetchUserDefaultUseCase: FetchUserDefaultUseCase,
       fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase,
       fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase) {
    self.coordinator = coordinator
    self.fetchUserDefaultUseCase = fetchUserDefaultUseCase
    self.fetchReviewsInMyPageUseCase = fetchReviewsInMyPageUseCase
    self.fetchPerfumesInMyPageUseCase = fetchPerfumesInMyPageUseCase
  }
  
  func transform(input: Input, disposeBag: DisposeBag){
    let selectedTab = PublishRelay<Int>()
    let loginState = PublishRelay<Bool>()
    let reviews = PublishRelay<[[ReviewInMyPage]]>()
    let perfumes = PublishRelay<[PerfumeInMyPage]>()
    
    self.bindInput(input: input,
                   scrollInput: self.scrollInput,
                   loadData: self.loadData,
                   selectedTab: selectedTab,
                   disposeBag: disposeBag)
    
    self.bindOutput(output: self.output,
                    selectedTab: selectedTab,
                    loginState: loginState,
                    reviews: reviews,
                    perfumes: perfumes,
                    disposeBag: disposeBag)
    
    self.fetchDatas(loadData: self.loadData,
                    loginState: loginState,
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
        self?.coordinator?.runOnboardingFlow?()
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
          let perfumeDetail = self?.getPerfumeDetail(perfume: perfume)
          guard let perfumeDetail = perfumeDetail else { return }
          self?.coordinator?.runPerfumeReviewFlow(perfumeDetail: perfumeDetail)
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
                          perfumes: PublishRelay<[PerfumeInMyPage]>,
                          disposeBag: DisposeBag) {
    
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
                          perfumes: PublishRelay<[PerfumeInMyPage]>,
                          disposeBag: DisposeBag) {
    
    loadData
      .subscribe(onNext: { [weak self] in
        let isLoggedIn = self?.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn) ?? false
        self?.isLoggedIn = isLoggedIn
        
        loginState.accept(isLoggedIn)
        if isLoggedIn {
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
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func getPerfumeDetail(perfume: PerfumeInMyPage) -> PerfumeDetail {
    PerfumeDetail(perfumeIdx: perfume.idx, name: perfume.name, brandName: perfume.brandName, story: "", abundanceRate: "", volumeAndPrice: [], imageUrls: [perfume.imageUrl], score: 0, seasonal: [], sillage: [], longevity: [], gender: [], isLiked: false, Keywords: [], noteType: 0, ingredients: [], reviewIdx: 0)
  }
  
}

extension MyPageViewModel: MyPageMenuDismissDelegate {
  func reloadData() {
    self.loadData.accept(())
  }
}
