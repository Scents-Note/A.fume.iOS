//
//  FetchReviewDetailUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchReviewDetailUseCaseTest: XCTestCase {
  
  private var fetchReviewDetailUseCase: FetchReviewDetailUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchReviewDetailUseCase = DefaultFetchReviewDetailUseCase(reviewRepository: MockReviewRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchReviewDetailUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchReviewDetail() throws {
    
    // Given
    let reviewDetail = ReviewDetail(score: 5.0, sillage: 1, longevity: 1, seasonal: ["여름"], gender: 1, content: "향이 좋네여", reviewIdx: 0, perfume: PerfumeInReviewDetail(idx: 0, name: "가", imageUrl: ""), keywords: [Keyword(idx: 0, name: "고",isSelected: false)], brand: BrandInReviewDetail(idx: 0, name: "ㄱ"), access: true)
   
    let reviewIdx = 0
    // When
    let reviewDetailObserver = self.scheduler.createObserver(ReviewDetail.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchReviewDetailUseCase.execute(reviewIdx: reviewIdx)
        .subscribe(reviewDetailObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(reviewDetailObserver.events, [.next(10, reviewDetail)])
    
  }
}
