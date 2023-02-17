//
//  MockKeywordRepository.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockKeywordRepository: KeywordRepository {
  func fetchKeywords() -> Observable<[Keyword]> {
    let keywords = [Keyword(idx: 0, name: "가", isSelected: false),
                    Keyword(idx: 1, name: "나", isSelected: false),
                    Keyword(idx: 2, name: "다", isSelected: false)]
    
    return Observable.create { observer in
      observer.onNext(keywords)
      return Disposables.create()
    }
  }
}
