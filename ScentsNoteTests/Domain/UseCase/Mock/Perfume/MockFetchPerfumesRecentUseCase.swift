//
//  MockFetchPerfumesRecentUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/27.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase {
  
  var isInitial = true
  var executeCalledCount = 0
  
  func execute() -> Observable<[Perfume]> {
    
    self.executeCalledCount += 1
    
    let perfumes = [Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: false)]
    
    // 다시 Fetch하게 되면 데이터가 바뀌는 상황을 연출하기 위함 데이터
    let perfumes2 = [Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: false),
                     Perfume(perfumeIdx: 8, brandName: "브랜드1", name: "향수8", imageUrl: "", keywordList: [], isLiked: false)]
    
    return Observable.create { [weak self] observer in
      if self?.isInitial == true {
        self?.isInitial = false
        observer.onNext(perfumes)
      } else {
        observer.onNext(perfumes2)
      }
      
      return Disposables.create()
    }
  }
  
}
