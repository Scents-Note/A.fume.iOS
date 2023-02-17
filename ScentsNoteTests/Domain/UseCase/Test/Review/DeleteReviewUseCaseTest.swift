//
//  DeleteReviewUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class DeleteReviewUseCaseTest: XCTestCase {
  
  private var deleteReviewUseCase: DeleteReviewUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.deleteReviewUseCase = DefaultDeleteReviewUseCase(reviewRepository: MockReviewRepository())
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.deleteReviewUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_reportReview() throws {
    
    // Given
    let reviewIdx = 0
    let expected = "삭제 되었습니다."

    // When
    let stringObserver = self.scheduler.createObserver(String.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.deleteReviewUseCase.execute(reviewIdx: reviewIdx)
        .subscribe(stringObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(stringObserver.events, [.next(10, expected)])
    
  }
}
