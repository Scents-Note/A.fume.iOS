//
//  FetchKeywordsUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchKeywordsUseCaseTest: XCTestCase {
  
  private var fetchKeywordsUseCase: FetchKeywordsUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchKeywordsUseCase = DefaultFetchKeywordsUseCase(keywordRepository: MockKeywordRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchKeywordsUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchKeywords() throws {
    
    // Given
    let keywords = [Keyword(idx: 0, name: "가", isSelected: false),
                    Keyword(idx: 1, name: "나", isSelected: false),
                    Keyword(idx: 2, name: "다", isSelected: false)]
    // When
    let keywordsObserver = self.scheduler.createObserver([Keyword].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchKeywordsUseCase.execute()
        .subscribe(keywordsObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(keywordsObserver.events, [.next(10, keywords)])
    
  }
}

