//
//  SignUpUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SignUpUseCaseTest: XCTestCase {
  
  private var signUpUseCase: SignUpUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.signUpUseCase = DefaultSignUpUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.signUpUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let signUpInfo = SignUpInfo()
    let expected = true
    let loginInfo = LoginInfo(userIdx: 0, nickname: "Testemr", gender: "MAN", birth: 1995, token: "", refreshToken: "")
    
    // When
    let signUpInfoObserver = self.scheduler.createObserver(LoginInfo.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.signUpUseCase.execute(signUpInfo: signUpInfo)
        .subscribe(signUpInfoObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(signUpInfoObserver.events, [.next(10, loginInfo)])
  }
}
