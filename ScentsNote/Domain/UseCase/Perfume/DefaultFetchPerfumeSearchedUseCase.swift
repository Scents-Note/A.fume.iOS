//
//  DefaultFetchPerfumeSearchedUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol FetchPerfumeSearchedUseCase {
  func execute(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]>
}

final class DefaultFetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]> {
    perfumeRepository.fetchPerfumeSearched(perfumeSearch: perfumeSearch)
  }
}
