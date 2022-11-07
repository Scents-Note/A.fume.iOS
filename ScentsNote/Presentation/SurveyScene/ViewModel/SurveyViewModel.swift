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
  private weak var coordinator: SurveyCoordinator?
  private let perfumeRepository: PerfumeRepository
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  var perfumes: [Perfume] = []
  var keywords: [SurveyKeyword] = []
  var series: [SurveySeries] = []
  
  var selectedTab = BehaviorRelay<Int>(value: 0)
  
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
  
  init(coordinator: SurveyCoordinator?, perfumeRepository: PerfumeRepository, userRepository: UserRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
    self.userRepository = userRepository
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
    
    self.perfumeRepository.fetchPerfumesInSurvey { result in
      result.success { [weak self] perfumeInfo in
        guard let perfumeInfo = perfumeInfo else { return }
        self?.perfumes = perfumeInfo.rows
        output.loadData.accept(true)
      }.catch { error in
        print("User Log: \(error)")
      }
    }
    
    self.perfumeRepository.fetchKeywords { result in
      result.success { [weak self] keywordInfo in
        guard let keywordInfo = keywordInfo else { return }
        self?.keywords = keywordInfo.rows.compactMap({
          return SurveyKeyword(keywordIdx: $0.keywordIdx, name: $0.name, isLiked: false)
        })
        output.loadData.accept(true)
      }.catch { error in
        print("User Log: \(error)")
      }
    }
    
    self.perfumeRepository.fetchSeries { result in
      result.success { [weak self] seriesInfo in
        guard let seriesInfo = seriesInfo else { return }
        self?.series = seriesInfo.rows.compactMap({
          return SurveySeries(seriesIdx: $0.seriesIdx, name: $0.name, imageUrl: $0.imageUrl, isLiked: false)
        })
        output.loadData.accept(true)
      }.catch { error in
        print("User Log: \(error)")
      }
    }
        
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
      .filter { $0.isLiked == true }
      .map { $0.keywordIdx }
    let seriesListLiked = self.series
      .filter { $0.isLiked == true }
      .map { $0.seriesIdx }
    
    self.userRepository.registerSurvey(perfumeList: perfumeListLiked, keywordList: keywordListLiked, seriesList: seriesListLiked) { result in
      result.success { _ in
        self.coordinator?.finishFlow?()
      }.catch { error in
        print("User Log: \(error)")
      }
    }
  }
  
  func exit() {
    self.coordinator?.finishFlow?()
  }
}
