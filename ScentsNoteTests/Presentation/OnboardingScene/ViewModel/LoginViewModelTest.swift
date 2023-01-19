//
//  LoginViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/16.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class LoginViewModelTest: XCTestCase {
  private var coordinator: LoginCoordinator!
  private var loginUseCase: LoginUseCase!
  private var saveLoginInfoUseCase: SaveLoginInfoUseCase!
  private var viewModel: LoginViewModel!
  private var input: LoginViewModel.Input!
  private var output: LoginViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockLoginCoordinator()
    self.loginUseCase = MockLoginUseCase()
    self.saveLoginInfoUseCase = MockSaveLoginInfoUseCase()
    
    self.viewModel = LoginViewModel(coordinator: self.coordinator,
                                    loginUseCase: self.loginUseCase,
                                    saveLoginInfoUseCase: self.saveLoginInfoUseCase)
    
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.disposeBag = nil
    self.loginUseCase = nil
    self.saveLoginInfoUseCase = nil
    self.scheduler = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
  }
  
  // Email & Password TextField 입력시 Login Button State 업데이트
  func testTransform_inputEmailAndPasswordTextField_updateCanButton() {
    
    // Given
    let doneButtonObserver = self.scheduler.createObserver(Bool.self)
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(20, "dyh0624"),
      .next(30, "dyh0624@naver.com"),
    ])
    
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test"),
      .next(40, "")
    ])
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    
    self.output.canDone
      .subscribe(doneButtonObserver)
      .disposed(by: self.disposeBag)
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(doneButtonObserver.events, [.next(0, false),
                                               .next(10, false),
                                               .next(20, false),
                                               .next(30, true),
                                               .next(40, false)])
  }

  // 최종 email & password TextField값이 email & password property에 들어갔는지
  func testTransform_updateEmailAndPasswordTextField_updateEmailAndPassword() {
    
    // Given
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "dyh0624"),
      .next(20, "dyh0624@naver.com"),
    ])
    
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "te"),
      .next(20, "test"),
    ])
    
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let expectedEmail = "dyh0624@naver.com"
    let expectedPassword = "test"
    XCTAssertEqual(self.viewModel.email, expectedEmail)
    XCTAssertEqual(self.viewModel.password, expectedPassword)
    
  }
  
  
  // 로그인 버튼 클릭할 때 성공할 때 UseCase Excute & finishFlow 테스트 호출 테스트
  func testTransform_clickLogin_success() {
    
    // Given
    let loginButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    // When
    loginButtonObservable
      .bind(to: self.input.loginButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let expectedExcuteCalledCount = 1
    let expectedFinishFlowCalledCount = 1
    
    let actualExcuteCalledCount = (self.saveLoginInfoUseCase as? MockSaveLoginInfoUseCase)?.excuteCalledCount
    XCTAssertEqual(actualExcuteCalledCount, expectedExcuteCalledCount)
    
    let actualFinishFlowCalledCount = (self.coordinator as? MockLoginCoordinator)?.finishFlowCalledCount
    XCTAssertEqual(actualFinishFlowCalledCount, expectedFinishFlowCalledCount)
  }
  
  // 로그인 버튼 클릭할 때 실패할 때 UseCase Excute & finishFlow 테스트 호출 테스트
  func testTransform_clickLogin_failure() {
    
    // Given
    (self.loginUseCase as! MockLoginUseCase).setState(state: .failure)
    
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "dyh0624@naver.com"),
    ])
    
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test"),
    ])
    
    let loginButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    let notCorrentObserver = self.scheduler.createObserver(Void.self)
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    loginButtonObservable
      .bind(to: self.input.loginButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.notCorrect
      .subscribe(notCorrentObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualExcuteCalledCount = (self.saveLoginInfoUseCase as? MockSaveLoginInfoUseCase)?.excuteCalledCount
    XCTAssertEqual(actualExcuteCalledCount, 0)
    
    XCTAssertEqual(notCorrentObserver.events.map(VoidRecord.init), [.next(20, ())].map(VoidRecord.init))
  }
  
  // 로그인 버튼 클릭할 때 실패할 때 UseCase Excute & finishFlow 테스트 호출 테스트
  func testTransform_clickSignUp_runSignUpFlow() {
    
    // Given
    let signUpButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    // When
    signUpButtonObservable
      .bind(to: self.input.signupButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let expected = 1
    let actual = (self.coordinator as? MockLoginCoordinator)?.runSignUpFlowCalledCount
    
    XCTAssertEqual(actual, expected)
    
  }
  
}
