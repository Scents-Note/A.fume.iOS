//
//  FetchFilterBrandInitialUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import RxSwift

final class FetchFilterBrandInitialUseCase {
  
  private let filterRepository: FilterRepository
  private let disposeBag = DisposeBag()
  
  init(filterRepository: FilterRepository) {
    self.filterRepository = filterRepository
  }
  
  func execute() -> Observable<[FilterBrandInitial]>{
    return Observable.create { observer in
      self.filterRepository.fetchBrandsForFilter()
        .subscribe(onNext: { brandInfos in
          let initials = brandInfos.map { FilterBrandInitial(text: $0.initial, isSelected: false) }
          observer.onNext(initials)
        })
        .disposed(by: self.disposeBag)
      return Disposables.create()
    }
  }
}
