//
//  CheckDuplicateNicknameUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class CheckDuplicateNicknameUseCaseTest: XCTestCase {
  
  private var checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.checkDuplicateNicknameUseCase = DefaultCheckDuplicateNicknameUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.checkDuplicateNicknameUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let nickname = "Testemr"
    let expected = true
    
    // When
    let perfumesObserver = self.scheduler.createObserver(Bool.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.checkDuplicateNicknameUseCase.execute(nickname: nickname)
        .subscribe(perfumesObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(perfumesObserver.events, [.next(10, expected)])
    
  }
}

