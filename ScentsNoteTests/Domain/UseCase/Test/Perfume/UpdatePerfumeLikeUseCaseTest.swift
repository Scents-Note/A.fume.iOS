//
//  UpdatePerfumeLikeUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class UpdatePerfumeLikeUseCaseTest: XCTestCase {
  
  private var updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.updatePerfumeLikeUseCase = DefaultUpdatePerfumeLikeUseCase(perfumeRepository: MockPerfumeRepository())
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.updatePerfumeLikeUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_updatePerfumeLike() throws {
    
    // Given
    let perfumeIdx = 0
    let result = true
    
    // When
    let successObserver = self.scheduler.createObserver(Bool.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.updatePerfumeLikeUseCase.execute(perfumeIdx: perfumeIdx)
        .subscribe(successObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(successObserver.events, [.next(10, result)])
  }
}
