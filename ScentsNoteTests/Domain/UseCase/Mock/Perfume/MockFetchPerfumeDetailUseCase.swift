//
//  MockFetchPerfumeDetailUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockFetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase {
  
  var state: State = .writtenReview
  
  enum State {
    case writtenReview
    case none
  }
  
  func setState(state: State) {
    self.state = state
  }
  
  func execute(perfumeIdx: Int) -> Observable<PerfumeDetail> {
    if self.state == .writtenReview {
      let perfumeDetail = MockModel.perfumeDetail
      return Observable.just(perfumeDetail)
    } else {
      let perfumeDetail = MockModel.perfumeDetailWrittenReview
      return Observable.just(perfumeDetail)
    }
  }
}
