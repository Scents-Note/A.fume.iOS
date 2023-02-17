//
//  MockFetchPerfumesRecommendedUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/27.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase {
  
  var isInitial = true
  var executeCalledCount = 0
  
  func execute() -> Observable<[Perfume]> {
    
    self.executeCalledCount += 1
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "브랜드", name: "향수4", imageUrl: "", keywordList: ["따뜻함"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "브랜드", name: "향수4", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    // 다시 Fetch하게 되면 데이터가 바뀌는 상황을 연출하기 위함 데이터
    let perfumes2 = [Perfume(perfumeIdx: 10, brandName: "브랜드4", name: "향수10", imageUrl: "", keywordList: ["달콤한, 나무향"], isLiked: false),
                     Perfume(perfumeIdx: 11, brandName: "브랜드2", name: "향수11", imageUrl: "", keywordList: ["따뜻함"], isLiked: false),
                     Perfume(perfumeIdx: 12, brandName: "브랜드2", name: "향수12", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    
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
