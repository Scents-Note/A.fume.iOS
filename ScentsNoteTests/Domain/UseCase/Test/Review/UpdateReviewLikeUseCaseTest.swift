//
//  UpdateReviewLikeUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class UpdateReviewLikeUseCaseTest: XCTestCase {
  
  private var updateReviewLikeUseCase: UpdateReviewLikeUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.updateReviewLikeUseCase = DefaultUpdateReviewLikeUseCase(reviewRepository: MockReviewRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.updateReviewLikeUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_reportReview() throws {
    
    // Given
    let reviewIdx = 0
    let expected = true

    // When
    let boolObserver = self.scheduler.createObserver(Bool.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.updateReviewLikeUseCase.execute(reviewIdx: reviewIdx)
        .subscribe(boolObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(boolObserver.events, [.next(10, expected)])
    
  }
}

