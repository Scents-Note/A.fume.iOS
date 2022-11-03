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
  }
  
  struct Output {
    var loadData = BehaviorRelay<Bool>(value: false)
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
      })
      .disposed(by: disposeBag)
    
    input.keywordButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.selectedTab.accept(1)
      })
      .disposed(by: disposeBag)
    
    input.seriesButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.selectedTab.accept(2)
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
        self?.keywords = keywordInfo.rows
        output.loadData.accept(true)
      }.catch { error in
        print("User Log: error1 \(error)")
      }
    }
    
    self.perfumeRepository.fetchSeries { result in
      result.success { [weak self] seriesInfo in
        guard let seriesInfo = seriesInfo else { return }
        self?.series = seriesInfo.rows
        output.loadData.accept(true)
      }.catch { error in
        print("User Log: error1 \(error)")
      }
    }
    
    
    return output
    //    self.userRepository.
  }
  
  func updateSelectedTab(_ idx: Int) {
    self.selectedTab.accept(idx)
  }
}
