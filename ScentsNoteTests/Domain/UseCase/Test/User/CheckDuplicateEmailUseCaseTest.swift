//
//  CheckDuplcateEmailUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class CheckDuplicateEmailUseCaseTest: XCTestCase {
  
  private var checkDuplcateEmailUseCase: CheckDuplicateEmailUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.checkDuplcateEmailUseCase = DefaultCheckDuplcateEmailUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.checkDuplcateEmailUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let email = "test@scentsnote.com"
    let expected = true
    
    // When
    let boolObserver = self.scheduler.createObserver(Bool.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.checkDuplcateEmailUseCase.execute(email: email)
        .subscribe(boolObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(boolObserver.events, [.next(10, expected)])
  }
}
