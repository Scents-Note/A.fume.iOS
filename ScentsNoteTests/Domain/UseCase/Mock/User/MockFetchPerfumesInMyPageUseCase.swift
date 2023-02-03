//
//  MockFetchPerfumesInMyPageUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import RxSwift
@testable import ScentsNote

final class MockFetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase {
  
  var state: ResponseState = .success
  var error: Error = NetworkError.restError(statusCode: 403, description: "로그인이 안되어있습니다.")
  
  let perfumes = [PerfumeInMyPage(idx: 0, name: "가", brandName: "ㄱ", imageUrl: "", reviewIdx: 100),
                  PerfumeInMyPage(idx: 1, name: "나", brandName: "ㄴ", imageUrl: "", reviewIdx: 101),
                  PerfumeInMyPage(idx: 2, name: "다", brandName: "ㄷ", imageUrl: "", reviewIdx: 102),
                  PerfumeInMyPage(idx: 3, name: "라", brandName: "ㄹ", imageUrl: "", reviewIdx: 103)]
  
  func execute() -> Observable<[PerfumeInMyPage]> {
    Observable.create { [unowned self] observer in
      if state == .success {
        observer.onNext(self.perfumes)
      } else {
        observer.onError(self.error)
      }
      return Disposables.create()
    }
  }
  
  func updateState(state: ResponseState) {
    self.state = state
  }
}
