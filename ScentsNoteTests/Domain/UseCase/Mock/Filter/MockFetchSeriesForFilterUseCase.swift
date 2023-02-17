//
//  MockFetchSeriesForFilterUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/25.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase {
  func execute() -> Observable<[FilterSeries]> {
    let series = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                   FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                   FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                  
                  FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                  FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                  FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    return Observable.create { observer in
      observer.onNext(series)
      return Disposables.create()
    }
  }
}
