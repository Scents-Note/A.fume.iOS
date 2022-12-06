//
//  MyPageViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxRelay

final class MyPageViewModel {
  
  struct Input {
    let reviewCellDidTapEvent = PublishRelay<Int>()
    let loginButtonDidTapEvent = PublishRelay<Void>()
    let menuButtonDidTapEvent = PublishRelay<Void>()
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
  
  let input = Input()
  let output = Output()
  
  init(coordinator: MyPageCoordinator,
       fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase,
       fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase) {
    self.coordinator = coordinator
    self.fetchReviewsInMyPageUseCase = fetchReviewsInMyPageUseCase
    self.fetchPerfumesInMyPageUseCase = fetchPerfumesInMyPageUseCase
  }
  
  func transform(disposeBag: DisposeBag){
    let reviews = PublishRelay<[[ReviewInMyPage]]>()
    let perfumes = PublishRelay<[PerfumeInMyPage]>()
    
    self.bindInput(disposeBag: disposeBag)
    self.bindOutput(output: output,
                    reviews: reviews,
                    perfumes: perfumes,
                    disposeBag: disposeBag)
    self.fetchDatas(reviews: reviews,
                    perfumes: perfumes,
                    disposeBag: disposeBag)
  }
  
  private func bindInput(disposeBag: DisposeBag) {
    self.input.reviewCellDidTapEvent
      .subscribe(onNext: { [weak self] reviewIdx in
        self?.coordinator?.runPerfumeReviewFlow(reviewIdx: reviewIdx)
      })
      .disposed(by: disposeBag)
    
    self.input.loginButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.onOnboardingFlow?()
      })
      .disposed(by: disposeBag)
    
    self.input.menuButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showMyPageMenuViewController()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output,
                          reviews: PublishRelay<[[ReviewInMyPage]]>,
                          perfumes: PublishRelay<[PerfumeInMyPage]>,
                          disposeBag: DisposeBag) {
    
    reviews
      .subscribe(onNext: { reviews in
        output.reviews.accept(reviews)
        Log(reviews)
      })
      .disposed(by: disposeBag)
    
    perfumes
      .subscribe(onNext: { perfumes in
        output.perfumes.accept(perfumes)
      })
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(reviews: PublishRelay<[[ReviewInMyPage]]>,
                          perfumes: PublishRelay<[PerfumeInMyPage]>,
                          disposeBag: DisposeBag) {
    
    self.fetchReviewsInMyPageUseCase.execute()
      .subscribe(onNext: { result in
        reviews.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
    
    self.fetchPerfumesInMyPageUseCase.execute()
      .subscribe(onNext: { result in
        perfumes.accept(result)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
    
  }
  
  
}
