//
//  ReportReviewUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class ReportReviewUseCaseTest: XCTestCase {
  
  private var reportReviewUseCase: ReportReviewUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.reportReviewUseCase = DefaultReportReviewUseCase(reviewRepository: MockReviewRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.reportReviewUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_reportReview() throws {
    
    // Given
    let reviewIdx = 0
    let reason = "욕설"
    let expected = "신고 되었습니다."

    // When
    let stringObserver = self.scheduler.createObserver(String.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.reportReviewUseCase.execute(reviewIdx: reviewIdx, reason: reason)
        .subscribe(stringObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(stringObserver.events, [.next(10, expected)])
    
  }
}
