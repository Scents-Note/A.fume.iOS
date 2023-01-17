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
  private var viewModel: LoginViewModel!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  private var coordinator: LoginCoordinator!
  private var loginUseCase: LoginUseCase!
  private var saveLoginInfoUseCase: SaveLoginInfoUseCase!
  
  override func setUpWithError() throws {
    self.coordinator = MockLoginCoordinator()
    self.loginUseCase = MockLoginUseCase(state: .success)
    self.saveLoginInfoUseCase = MockSaveLoginInfoUseCase()
    
    self.viewModel = LoginViewModel(coordinator: self.coordinator,
                                    loginUseCase: self.loginUseCase,
                                    saveLoginInfoUseCase: self.saveLoginInfoUseCase)
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
  }
  
  // Email & Password TextField 입력시 Login Button State 테스트
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
    let input = LoginViewModel.Input(emailTextFieldDidEditEvent: emailTextFieldObservable.asObservable(),
                                     passwordTextFieldDidEditEvent: passwordTextFieldObservable.asObservable(),
                                     loginButtonDidTapEvent: Observable.just(()),
                                     signupButtonDidTapEvent: Observable.just(()))
    
    let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    output.canDone
      .subscribe(doneButtonObserver)
      .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(doneButtonObserver.events, [.next(0, false),
                                               .next(10, false),
                                               .next(20, false),
                                               .next(30, true),
                                               .next(40, false)])
  }

  // 최종 email Observable이 email property에 들어갔는지 Test
  func testTransform_updateEmailTextField_updateEmail() {
    
    // Given
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "dyh0624"),
      .next(20, "dyh0624@naver.com"),
    ])
    let expected = "dyh0624@naver.com"
    
    // When
    let input = LoginViewModel.Input(emailTextFieldDidEditEvent: emailTextFieldObservable.asObservable(),
                                     passwordTextFieldDidEditEvent: Observable.just(""),
                                     loginButtonDidTapEvent: Observable.just(()),
                                     signupButtonDidTapEvent: Observable.just(()))
    
    let _ = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(self.viewModel.email, expected)
    
  }
  
  // 최종 password Observable이 password property에 들어갔는지 Test
  func testTransform_updatePasswordTextField_updatePassword() {
    
    // Given
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "t"),
      .next(20, "test"),
    ])
    let expected = "test"
    
    // When
    let input = LoginViewModel.Input(emailTextFieldDidEditEvent:Observable.just(""),
                                     passwordTextFieldDidEditEvent: passwordTextFieldObservable.asObservable(),
                                     loginButtonDidTapEvent: Observable.just(()),
                                     signupButtonDidTapEvent: Observable.just(()))
    
    let _ = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(self.viewModel.password, expected)
  }
  
  // 로그인 버튼 클릭할 때 성공할 때 UseCase Excute & finishFlow 테스트 호출 테스트
  func testTransform_clickLogin_success() {
    
    // Given
    let loginButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    // When
    let input = LoginViewModel.Input(emailTextFieldDidEditEvent: Observable.just("dyh0624@naver.com"),
                                     passwordTextFieldDidEditEvent: Observable.just("test"),
                                     loginButtonDidTapEvent: loginButtonObservable.asObservable(),
                                     signupButtonDidTapEvent: Observable.just(()))
    
    
    let _ = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
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
    self.viewModel = LoginViewModel(coordinator: self.coordinator,
                                    loginUseCase: MockLoginUseCase(state: .failure),
                                    saveLoginInfoUseCase: self.saveLoginInfoUseCase)
    
    let loginButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    let notCorrentObserver = self.scheduler.createObserver(Void.self)
    // 실패 조건을 위해 한번 새로운 인스턴스 할당
    
    // When
    let input = LoginViewModel.Input(emailTextFieldDidEditEvent: Observable.just("dyh0624@naver.com"),
                                     passwordTextFieldDidEditEvent: Observable.just("test"),
                                     loginButtonDidTapEvent: loginButtonObservable.asObservable(),
                                     signupButtonDidTapEvent: Observable.just(()))
    
    
    let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    output.notCorrect
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
    // 실패 조건을 위해 한번 새로운 인스턴스 할당
    
    // When
    let input = LoginViewModel.Input(emailTextFieldDidEditEvent: Observable.just("dyh0624@naver.com"),
                                     passwordTextFieldDidEditEvent: Observable.just("test"),
                                     loginButtonDidTapEvent: Observable.just(()),
                                     signupButtonDidTapEvent: signUpButtonObservable.asObservable())
    
    let _ = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let expected = 1
    let actual = (self.coordinator as? MockLoginCoordinator)?.runSignUpFlowCalledCount
    
    XCTAssertEqual(actual, expected)
    
  }
  
}
