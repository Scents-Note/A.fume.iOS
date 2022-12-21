//
//  FetchBrandsForFilterUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

final class FetchBrandsForFilterUseCase {
  
  private let filterRepository: FilterRepository
  private let disposeBag = DisposeBag()
  
  init(filterRepository: FilterRepository) {
    self.filterRepository = filterRepository
  }
  
  func execute() -> Observable<[FilterBrandInfo]> {
    self.filterRepository.fetchBrandsForFilter()
  }
}
