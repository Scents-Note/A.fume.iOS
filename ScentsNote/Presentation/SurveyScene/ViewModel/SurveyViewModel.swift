//
//  SurveyViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import Foundation

import RxSwift
import RxRelay

final class SurveyViewModel {
  
  struct Input {
    let perfumeButtonDidTapEvent: Observable<Void>
    let keywordButtonDidTapEvent: Observable<Void>
    let seriesButtonDidTapEvent: Observable<Void>
    let exitAlertShownEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var loadData = BehaviorRelay<Bool>(value: false)
    var hightlightViewTransform = BehaviorRelay<Int>(value: 0)
    var perfumeCellDidTap = PublishRelay<IndexPath>()
    var exitAlertShown = PublishRelay<Bool>()
  }
  
  private weak var coordinator: SurveyCoordinator?
  private let fetchPerfumesInSurveyUseCase: FetchPerfumesInSurveyUseCase
  private let fetchKeywordsUseCase: FetchKeywordsUseCase
  private let fetchSeriesUseCase: FetchSeriesUseCase
  private let registerSurveyUseCase: RegisterSurveyUseCase
  private let disposeBag = DisposeBag()
  
  var perfumes: [Perfume] = []
  var keywords: [Keyword] = []
  var series: [SurveySeries] = []
  
  var selectedTab = BehaviorRelay<Int>(value: 0)
  
  init(coordinator: SurveyCoordinator?,
       fetchPerfumesInSurveyUseCase: FetchPerfumesInSurveyUseCase,
       fetchKeywordsUseCase: FetchKeywordsUseCase,
       fetchSeriesUseCase: FetchSeriesUseCase,
       registerSurveyUseCase: RegisterSurveyUseCase
  ) {
    self.coordinator = coordinator
    self.fetchPerfumesInSurveyUseCase = fetchPerfumesInSurveyUseCase
    self.fetchKeywordsUseCase = fetchKeywordsUseCase
    self.fetchSeriesUseCase = fetchSeriesUseCase
    self.registerSurveyUseCase = registerSurveyUseCase
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    input.perfumeButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.selectedTab.accept(0)
        output.hightlightViewTransform.accept(0)
      })
      .disposed(by: disposeBag)
    
    input.keywordButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.selectedTab.accept(1)
        output.hightlightViewTransform.accept(1)
      })
      .disposed(by: disposeBag)
    
    input.seriesButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.selectedTab.accept(2)
        output.hightlightViewTransform.accept(2)
      })
      .disposed(by: disposeBag)
    
    input.exitAlertShownEvent
      .subscribe(onNext: {
        output.exitAlertShown.accept(true)
      })
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        if self?.selectedTab.value == 2 {
          self?.completeSurveyFlow()
        } else {
          let currentTab = self?.selectedTab.value ?? 0
          self?.selectedTab.accept(currentTab + 1)
        }
      })
      .disposed(by: disposeBag)
    
    self.fetchPerfumesInSurveyUseCase.execute()
      .subscribe { [weak self] perfumes in
        self?.perfumes = perfumes
        output.loadData.accept(true)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.fetchKeywordsUseCase.execute()
      .subscribe { [weak self] keywordInfo in
        self?.keywords = keywordInfo.compactMap({
          return Keyword(idx: $0.idx, name: $0.name, isSelected: false)
        })
        output.loadData.accept(true)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    self.fetchSeriesUseCase.execute()
      .subscribe { [weak self] seriesInfo in
        self?.series = seriesInfo.rows.compactMap({
          return SurveySeries(seriesIdx: $0.seriesIdx, name: $0.name, imageUrl: $0.imageUrl, isLiked: false)
        })
        output.loadData.accept(true)
      } onError: { error in
        print("User Log: error - \(error)")
      }
      .disposed(by: disposeBag)
    
    return output
  }
  
  func updateSelectedTab(_ idx: Int) {
    self.selectedTab.accept(idx)
  }
  
  func completeSurveyFlow() {
    let perfumeListLiked = self.perfumes
      .filter { $0.isLiked }
      .map { $0.perfumeIdx }
    let keywordListLiked = self.keywords
      .filter { $0.isSelected == true }
      .map { $0.idx }
    let seriesListLiked = self.series
      .filter { $0.isLiked == true }
      .map { $0.seriesIdx }
    
    self.registerSurveyUseCase.execute(perfumeList: perfumeListLiked, keywordList: keywordListLiked, seriesList: seriesListLiked)
      .subscribe { [weak self] a in
        Log(a)
        self?.coordinator?.finishFlow?()
      } onError: { error in
        Log(error)
      }
      .disposed(by: disposeBag)
  }
  
  
  func exit() {
    self.coordinator?.finishFlow?()
  }
}
