//
//  UpdateReviewUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class UpdateReviewUseCaseTest: XCTestCase {
  
  private var updateReviewUseCase: UpdateReviewUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.updateReviewUseCase = DefaultUpdateReviewUseCase(reviewRepository: MockReviewRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.updateReviewUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_updateReview() throws {
    
    // Given
    let reviewDetail = ReviewDetail.default
    let expected = "업데이트 되었습니다."

    // When
    let stringObserver = self.scheduler.createObserver(String.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.updateReviewUseCase.execute(reviewDetail: reviewDetail)
        .subscribe(stringObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(stringObserver.events, [.next(10, expected)])
    
  }
}

