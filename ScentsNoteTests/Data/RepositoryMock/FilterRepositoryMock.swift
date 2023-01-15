//
//  FilterRepositoryMock.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import RxSwift
@testable import ScentsNote

final class FilterRepositoryMock: FilterRepository {
  
  func fetchSeriesForFilter() -> Observable<[FilterSeries]> {
    let series = [FilterSeries(idx: 0, name: "가", ingredients: [FilterIngredient(idx: 0, name: "ㄱ", isSelected: false),
                                                                FilterIngredient(idx: 1, name: "ㄴ", isSelected: false),
                                                                FilterIngredient(idx: 2, name: "ㄷ", isSelected: false)]),
                  FilterSeries(idx: 1, name: "나", ingredients: [FilterIngredient(idx: 3, name: "ㄹ", isSelected: false),
                                                                FilterIngredient(idx: 4, name: "ㅁ", isSelected: false),
                                                                FilterIngredient(idx: 5, name: "ㅂ", isSelected: false)])]
    return Observable.create { observer in
      observer.onNext(series)
      return Disposables.create()
    }
  }
  
  func fetchBrandsForFilter() -> Observable<[FilterBrandInfo]> {
    let brands = [FilterBrandInfo(initial: "ㄱ", brands: [FilterBrand(idx: 0, name: "가", isSelected: false),
                                                         FilterBrand(idx: 1, name: "나", isSelected: false)]),
                  FilterBrandInfo(initial: "ㄴ", brands: [FilterBrand(idx: 2, name: "다", isSelected: false),
                                                         FilterBrand(idx: 3, name: "라", isSelected: false)])]
    
    return Observable.create { observer in
      observer.onNext(brands)
      return Disposables.create()
    }
  }
  
  
}
