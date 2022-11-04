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
  private let disposeBag = DisposeBag()
  
  var perfumes: [SurveyPerfume] = []
  var keywords: [SurveyKeyword] = []
  var series: [SurveySeries] = []
  
  var selectedTab = BehaviorRelay<Int>(value: 0)
  
  struct Input {
    let perfumeButtonDidTapEvent: Observable<Void>
    let keywordButtonDidTapEvent: Observable<Void>
    let seriesButtonDidTapEvent: Observable<Void>
    let backButtonDidTapEvent: Observable<Void>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var loadData = BehaviorRelay<Bool>(value: false)
    var hightlightViewTransform = BehaviorRelay<Int>(value: 0)
    var perfumeCellDidTap = PublishRelay<IndexPath>()
  }
  
  init(coordinator: SurveyCoordinator?, perfumeRepository: PerfumeRepository) {
    self.coordinator = coordinator
    self.perfumeRepository = perfumeRepository
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
    
    input.backButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        
      })
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        if self?.selectedTab.value == 2 {
          
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
        print("User Log: error1 \(error)")
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
        print("User Log: error1 \(error)")
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
        print("User Log: error1 \(error)")
      }
    }
        
    return output
  }
  
  func updateSelectedTab(_ idx: Int) {
    self.selectedTab.accept(idx)
  }
}
