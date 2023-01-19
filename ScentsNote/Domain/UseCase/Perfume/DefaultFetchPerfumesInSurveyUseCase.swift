//
//  DefaultFetchPerfumesInSurveyUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/20.
//

import RxSwift

protocol FetchPerfumesInSurveyUseCase {
  func execute() -> Observable<[Perfume]>
}

final class DefaultFetchPerfumesInSurveyUseCase: FetchPerfumesInSurveyUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute() -> Observable<[Perfume]>{
    self.perfumeRepository.fetchPerfumesInSurvey()
  }
}
