//
//  FetchPerfumeDetailUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import RxSwift

final class FetchPerfumeDetailUseCase {
  
  private let perfumeRepository: PerfumeRepository
  private let disposeBag = DisposeBag()
  
  init(perfumeRepository: PerfumeRepository) {
    self.perfumeRepository = perfumeRepository
  }
  
  func execute(perfumeIdx: Int) -> Observable<PerfumeDetail?>{
    return Observable.create { observer in
      Observable.zip(self.perfumeRepository.fetchPerfumeDetail(perfumeIdx: perfumeIdx), self.perfumeRepository.fetchSimliarPerfumes(perfumeIdx: perfumeIdx))
        .subscribe(onNext: { perfumeDetail, similarPerfumes in
          var detail = perfumeDetail
          detail.similarPerfumes = similarPerfumes
          observer.onNext(detail)
        })
        .disposed(by: self.disposeBag)
      return Disposables.create()
    }
    
    
    
  }
}
