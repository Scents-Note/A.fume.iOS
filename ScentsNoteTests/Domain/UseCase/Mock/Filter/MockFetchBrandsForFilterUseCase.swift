//
//  MockFetchBrandsForFilterUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase {
  func execute() -> Observable<[FilterBrandInfo]> {
    
    let brandInfos = [FilterBrandInfo(initial: "ㄱ", brands: [FilterBrand(idx: 0, name: "브랜드1", isSelected: false),
                                                             FilterBrand(idx: 1, name: "브랜드2", isSelected: false),
                                                             FilterBrand(idx: 2, name: "브랜드3", isSelected: false)]),
                      FilterBrandInfo(initial: "ㄴ", brands: [FilterBrand(idx: 3, name: "브랜드4", isSelected: false),
                                                             FilterBrand(idx: 4, name: "브랜드5", isSelected: false),
                                                             FilterBrand(idx: 5, name: "브랜드6", isSelected: false)]),
                      FilterBrandInfo(initial: "ㄷ", brands: [FilterBrand(idx: 6, name: "브랜드7", isSelected: false)])]
    
    return Observable.create { observer in
      observer.onNext(brandInfos)
      return Disposables.create()
    }
  }
}
