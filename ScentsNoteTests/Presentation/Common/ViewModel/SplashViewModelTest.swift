//
//  SplashViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SplashViewModelTest: XCTestCase {
  private var coordinator: SplashCoordinator!
  private var loginUseCase: LoginUseCase!
  private var logoutUseCase: LogoutUseCase!
  private var saveLoginInfoUseCase: SaveLoginInfoUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSplashCoordinator()
    self.loginUseCase = MockLoginUseCase()
    self.logoutUseCase = MockLogoutUseCase()
    self.saveLoginInfoUseCase = MockSaveLoginInfoUseCase()
    
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.loginUseCase = nil
    self.logoutUseCase = nil
    self.saveLoginInfoUseCase = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // 로그인 시에 자동로그인 되어있으면 로그인 정보 저장 후 FinishFlow 실행
  func testLogin_ifAutoLogin_saveLoginAndFinish() throws {
    
    // Given
    // TODO: 이런 경우에 그냥 ViewModel을 분리해서 Test를 하는 것이 더 깔끔한지?
    let _ = SplashViewModel(coordinator: self.coordinator,
                                    loginUseCase: self.loginUseCase,
                                    logoutUseCase: self.logoutUseCase,
                                    saveLoginInfoUseCase: self.saveLoginInfoUseCase)
    
    let expectedLoginCalledCount = 1
    let expectedSaveLoginCalledCount = 1
    let expectedFinishCalledCount = 1
    
    // Then
    let actualLoginCalledCount = (self.loginUseCase as! MockLoginUseCase).excuteCalledCount
    XCTAssertEqual(actualLoginCalledCount, expectedLoginCalledCount)
    
    let actualSaveLoginCalledCount = (self.saveLoginInfoUseCase as! MockSaveLoginInfoUseCase).excuteCalledCount
    XCTAssertEqual(actualSaveLoginCalledCount, expectedSaveLoginCalledCount)
    
    let actualFinishCalledCount = (self.coordinator as! MockSplashCoordinator).finishFlowCalledCount
    XCTAssertEqual(actualFinishCalledCount, expectedFinishCalledCount)
  }
  
  // 로그인 시에 자동로그인 안되어있으면 FinishFlow 실행
  func testLogin_ifNotAutoLogin_finish() throws {
    
    // Given
    (self.loginUseCase as! MockLoginUseCase).setState(state: .failure)
    let _ = SplashViewModel(coordinator: self.coordinator,
                                    loginUseCase: self.loginUseCase,
                                    logoutUseCase: self.logoutUseCase,
                                    saveLoginInfoUseCase: self.saveLoginInfoUseCase)
    
    
    let expectedLoginCalledCount = 1
    let expectedSaveLoginCalledCount = 0
    let expectedFinishCalledCount = 1
    
    // Then
    let actualLoginCalledCount = (self.loginUseCase as! MockLoginUseCase).excuteCalledCount
    XCTAssertEqual(actualLoginCalledCount, expectedLoginCalledCount)
    
    let actualSaveLoginCalledCount = (self.saveLoginInfoUseCase as! MockSaveLoginInfoUseCase).excuteCalledCount
    XCTAssertEqual(actualSaveLoginCalledCount, expectedSaveLoginCalledCount)
    
    let actualFinishCalledCount = (self.coordinator as! MockSplashCoordinator).finishFlowCalledCount
    XCTAssertEqual(actualFinishCalledCount, expectedFinishCalledCount)
  }
}
