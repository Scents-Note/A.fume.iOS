//
//  MockUpdateReviewLikeUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

import RxSwift
@testable import ScentsNote_Dev

final class MockUpdateReviewLikeUseCase: UpdateReviewLikeUseCase {
  func execute(reviewIdx: Int) -> Observable<Bool> {
    return Observable.just(true)
  }
}
