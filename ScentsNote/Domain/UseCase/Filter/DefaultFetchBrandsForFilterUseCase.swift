//
//  DefaultFetchBrandsForFilterUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/21.
//

import RxSwift

protocol FetchBrandsForFilterUseCase {
  func execute() -> Observable<[FilterBrandInfo]>
}

final class DefaultFetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase {
  
  private let filterRepository: FilterRepository
  private let disposeBag = DisposeBag()
  
  init(filterRepository: FilterRepository) {
    self.filterRepository = filterRepository
  }
  
  func execute() -> Observable<[FilterBrandInfo]> {
    self.filterRepository.fetchBrandsForFilter()
  }
}
