//
//  MockFetchPerfumeSearchedUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

import RxSwift
@testable import ScentsNote

final class MockFetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase {
  
  var isInitial = true
  var perfumeSearch: PerfumeSearch?
  var executeCalledCount = 0
  
  func execute(perfumeSearch: PerfumeSearch) -> Observable<[Perfume]> {
    
    self.executeCalledCount += 1
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "브랜드0", name: "향수0", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "브랜드1", name: "향수1", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "브랜드2", name: "향수2", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    // 다시 Fetch하게 되면 데이터가 바뀌는 상황을 연출하기 위함 데이터
    let perfumes2 = [Perfume(perfumeIdx: 3, brandName: "브랜드3", name: "향수3", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "브랜드4", name: "향수4", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "브랜드5", name: "향수5", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    
    self.perfumeSearch = perfumeSearch
    
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

