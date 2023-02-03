//
//  FetchPerfumesInMyPageUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchPerfumesInMyPageUseCaseTest: XCTestCase {
  
  private var fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchPerfumesInMyPageUseCase = DefaultFetchPerfumesInMyPageUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchPerfumesInMyPageUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchPerfumesInMyPage() throws {
    
    // Given
    let perfumes = [PerfumeInMyPage(idx: 0, name: "가", brandName: "ㄱ", imageUrl: "", reviewIdx: 100),
                    PerfumeInMyPage(idx: 1, name: "나", brandName: "ㄴ", imageUrl: "", reviewIdx: 101),
                    PerfumeInMyPage(idx: 2, name: "다", brandName: "ㄷ", imageUrl: "", reviewIdx: 102),
                    PerfumeInMyPage(idx: 3, name: "라", brandName: "ㄹ", imageUrl: "", reviewIdx: 103)]
    // When
    let perfumesObserver = self.scheduler.createObserver([PerfumeInMyPage].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchPerfumesInMyPageUseCase.execute()
        .subscribe(perfumesObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(perfumesObserver.events, [.next(10, perfumes)])
    
  }
}

