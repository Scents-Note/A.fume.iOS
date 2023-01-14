//
//  DefaultUpdatePerfumeLikeUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol UpdatePerfumeLikeUseCase {
  func execute(perfumeIdx: Int) -> Observable<Bool>
}

final class DefaultUpdatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(perfumeIdx: Int) -> Observable<Bool> {
    perfumeRepository.updatePerfumeLike(perfumeIdx: perfumeIdx)
  }
}
