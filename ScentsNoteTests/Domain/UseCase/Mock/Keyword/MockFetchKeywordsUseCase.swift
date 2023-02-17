//
//  MockFetchKeywordsUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchKeywordsUseCase: FetchKeywordsUseCase {
  func execute() -> Observable<[Keyword]> {
    let keywords = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 1, name: "키워드1", isSelected: false),
                    Keyword(idx: 2, name: "키워드2", isSelected: false),
                    Keyword(idx: 3, name: "키워드3", isSelected: false),
                    Keyword(idx: 4, name: "키워드4", isSelected: false),
                    Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    return Observable.create { observer in
      observer.onNext(keywords)
      return Disposables.create()
    }
    
  }
}
