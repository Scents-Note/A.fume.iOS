//
//  LoginUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class LoginUseCaseTest: XCTestCase {
  
  private var loginUseCase: LoginUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.loginUseCase = DefaultLoginUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.loginUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_autoLogin() throws {
    
    // Given
    // 실패한 케이스
    let loginInfo = LoginInfo(userIdx: 6, nickname: "득연", gender: "MAN", birth: 1995, token: "token", refreshToken: "refreshToken")
    
    // When
    let loginInfoObserver = self.scheduler.createObserver(LoginInfo.self)
    let observable = self.scheduler.createColdObservable([.next(10, ())])
    
    observable
      .subscribe(onNext: { [weak self] in
        self?.loginUseCase.execute()
          .subscribe(loginInfoObserver)
          .disposed(by: self?.disposeBag ?? DisposeBag())
      })
      .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(loginInfoObserver.events, [.next(10, loginInfo)])
    
  }
  
  func testExecute_login() throws {
    
    // Given
    let loginInfo = LoginInfo(userIdx: 6, nickname: "득연", gender: "MAN", birth: 1995, token: "token", refreshToken: "refreshToken")
    
    let email = "test@scentsnote.com"
    let password = "test"
    
    // When
    let loginInfoObserver = self.scheduler.createObserver(LoginInfo.self)
    let observable = self.scheduler.createColdObservable([.next(10, ())])
    
    observable
      .subscribe(onNext: { [weak self] in
        self?.loginUseCase.execute(email: email, password: password)
          .subscribe(loginInfoObserver)
          .disposed(by: self?.disposeBag ?? DisposeBag())
      })
      .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(loginInfoObserver.events, [.next(10, loginInfo)])
    
  }
}

