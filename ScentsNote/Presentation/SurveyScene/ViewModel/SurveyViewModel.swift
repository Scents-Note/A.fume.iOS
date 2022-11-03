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
  
  struct Input {
    
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
    
    
    return output
    //    self.userRepository.
  }
}
