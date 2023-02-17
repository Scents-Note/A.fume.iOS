//
//  FetchReviewsInMyPageUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class FetchReviewsInMyPageUseCaseTest: XCTestCase {
  
  private var fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchReviewsInMyPageUseCase = DefaultFetchReviewsInMyPageUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchReviewsInMyPageUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchReviewsInMyPage() throws {
    
    // Given
    let reviews = [[ReviewInMyPage(reviewIdx: 0, score: 5.0, perfume: "가", imageUrl: "", brand: "ㄱ"),
                    ReviewInMyPage(reviewIdx: 1, score: 4.5, perfume: "나", imageUrl: "", brand: "ㄴ"),
                    ReviewInMyPage(reviewIdx: 2, score: 3.7, perfume: "다", imageUrl: "", brand: "ㄱ")],
                   [ReviewInMyPage(reviewIdx: 3, score: 5.0, perfume: "라", imageUrl: "", brand: "ㄱ"),
                    ReviewInMyPage(reviewIdx: 4, score: 4.5, perfume: "마", imageUrl: "", brand: "ㄴ"),
                    ReviewInMyPage(reviewIdx: 5, score: 3.7, perfume: "바", imageUrl: "", brand: "ㄱ")]]
    // When
    let keywordsObserver = self.scheduler.createObserver([[ReviewInMyPage]].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchReviewsInMyPageUseCase.execute()
        .subscribe(keywordsObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(keywordsObserver.events, [.next(10, reviews)])
    
  }
}

