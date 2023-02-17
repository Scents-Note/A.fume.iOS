//
//  MockFetchPerfumesNewUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchPerfumesNewUseCase: FetchPerfumesNewUseCase {
  func execute(size: Int?) -> Observable<[Perfume]> {
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    return Observable.create { observer in
      observer.onNext(perfumes)
      return Disposables.create()
    }
  }
}
