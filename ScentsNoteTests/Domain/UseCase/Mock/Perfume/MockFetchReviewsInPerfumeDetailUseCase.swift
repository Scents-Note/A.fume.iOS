//
//  MockFetchReviewsInPerfumeDetailUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

import RxSwift
@testable import ScentsNote

final class MockFetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase {
  func execute(perfumeIdx: Int) -> Observable<[ReviewInPerfumeDetail]> {
    let reviews = MockModel.reviews
    return Observable.just(reviews)
  }
}
