//
//  FetchReviewsInPerfumeDetailUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchReviewsInPerfumeDetailUseCaseTest: XCTestCase {
  
  private var fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchReviewsInPerfumeDetailUseCase = DefaultFetchReviewsInPerfumeDetailUseCase(perfumeRepository: PerfumeRepositoryMock())
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchReviewsInPerfumeDetailUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetch_success() throws {
    
    // Given
    let perfumeIdx = 0
    let reviews: [ReviewInPerfumeDetail] = [ReviewInPerfumeDetail(idx: 0, score: 5, access: true, content: "가", likeCount: 0, isLiked: false, gender: 1, age: "20", nickname: "득연1", isReported: false),
                                            ReviewInPerfumeDetail(idx: 1, score: 4.5, access: true, content: "나", likeCount: 0, isLiked: false, gender: 1, age: "30", nickname: "득연2", isReported: false)]
    
    
    // When
    let reviewsObserver = self.scheduler.createObserver([ReviewInPerfumeDetail].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchReviewsInPerfumeDetailUseCase.execute(perfumeIdx: perfumeIdx)
        .subscribe(reviewsObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(reviewsObserver.events, [.next(10, reviews)])
  }
}


