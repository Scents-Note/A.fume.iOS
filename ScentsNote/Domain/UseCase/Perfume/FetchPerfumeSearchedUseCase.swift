//
//  FetchPerfumeSearchedUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

final class FetchPerfumeSearchedUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]> {
    perfumeRepository.fetchPerfumeSearched(perfumeSearch: perfumeSearch)
  }
}
