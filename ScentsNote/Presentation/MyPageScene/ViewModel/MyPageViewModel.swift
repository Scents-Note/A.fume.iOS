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
    let loginButtonDidTapEvent = PublishRelay<Void>()
    let menuButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let selectedTab = BehaviorRelay<Int>(value: 0)
    let perfumesLiked = PublishRelay<[PerfumeLiked]>()
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MyPageCoordinator?
  private let fetchPerfumesLikedUseCase: FetchPerfumesLikedUseCase
  let input = Input()
  let output = Output()
  
  init(coordinator: MyPageCoordinator, fetchPerfumesLikedUseCase: FetchPerfumesLikedUseCase) {
    self.coordinator = coordinator
    self.fetchPerfumesLikedUseCase = fetchPerfumesLikedUseCase
  }
  
  func transform(disposeBag: DisposeBag){
    let perfumesLiked = PublishRelay<[PerfumeLiked]>()
    
    self.bindInput(disposeBag: disposeBag)
    self.bindOutput(output: output,
                    perfumesLiked: perfumesLiked,
                    disposeBag: disposeBag)
    self.fetchDatas(perfumesLiked: perfumesLiked,
                    disposeBag: disposeBag)
  }
  
  private func bindInput(disposeBag: DisposeBag) {
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
                          perfumesLiked: PublishRelay<[PerfumeLiked]>,
                          disposeBag: DisposeBag) {
    perfumesLiked
      .subscribe(onNext: { perfumes in
        output.perfumesLiked.accept(perfumes)
      })
      .disposed(by: disposeBag)
    
  }
  
  private func fetchDatas(perfumesLiked: PublishRelay<[PerfumeLiked]>,
                          disposeBag: DisposeBag) {
    self.fetchPerfumesLikedUseCase.execute()
      .subscribe(onNext: { perfumes in
        Log(perfumes)

        perfumesLiked.accept(perfumes)
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
    
  }
  
  
}
