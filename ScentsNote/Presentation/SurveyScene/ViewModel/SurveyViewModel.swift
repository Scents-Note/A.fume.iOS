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
        print("user log: \(perfumeInfo)")
        guard let perfumeInfo = perfumeInfo else { return }
        self?.perfumes = perfumeInfo.rows
        output.loadData.accept(true)
      }.catch { error in
        print("User Log: error1 \(error)")
      }
    }
    return output
    //    self.userRepository.
  }
}
