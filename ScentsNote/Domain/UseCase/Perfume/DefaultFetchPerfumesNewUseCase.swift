//
//  DefaultFetchPerfumesNewUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol FetchPerfumesNewUseCase {
  func execute(size: Int?) -> Observable<[Perfume]>
}

final class DefaultFetchPerfumesNewUseCase: FetchPerfumesNewUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(size: Int?) -> Observable<[Perfume]> {
    perfumeRepository.fetchPerfumesNew(size: size)
  }
}
