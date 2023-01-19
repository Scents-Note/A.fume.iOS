//
//  AddReviewUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class AddReviewUseCaseTest: XCTestCase {
  
  private var addReviewUseCase: AddReviewUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.addReviewUseCase = DefaultAddReviewUseCase(perfumeRepository: MockPerfumeRepository())
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.addReviewUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_addReview() throws {
    
    // Given
    let perfumeIdx = 0
    let reviewDetail = ReviewDetail.default
    let expected = "노트 작성에 성공하였습니다."
    
    // When
    let stringObserver = self.scheduler.createObserver(String.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.addReviewUseCase.execute(perfumeIdx: perfumeIdx, perfumeReview: reviewDetail)
        .subscribe(stringObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(stringObserver.events, [.next(10, expected)])
  }
}

