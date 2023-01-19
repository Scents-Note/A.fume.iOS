//
//  SignUpPasswordViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/19.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SignUpPasswordViewModelTest: XCTestCase {
  private var coordinator: SignUpCoordinator!
  private var viewModel: SignUpPasswordViewModel!
  private var input: SignUpPasswordViewModel.Input!
  private var output: SignUpPasswordViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSignUpCoordinator()
    self.viewModel = SignUpPasswordViewModel(coordinator: self.coordinator, signUpInfo: SignUpInfo.init())
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.input = nil
    self.input = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // passwordTextField Edit
  func testTransform_editPassword_updatePasswordAndPasswordState() {
    
    // Given
    let passwordStateObserver = self.scheduler.createObserver(InputState.self)
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "te"),
      .next(20, "test"),
      .next(30, "tes"),
    ])
    
    // When
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.passwordState
      .subscribe(passwordStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(passwordStateObserver.events, [.next(0, .empty),
                                                  .next(10, .wrongFormat),
                                                  .next(20, .success),
                                                  .next(30, .wrongFormat)])
    let actual = self.viewModel.password
    let expexted = "tes"
    XCTAssertEqual(actual, expexted)
  }
  
  // passwordCheckTextField Edit
  func testTransform_editPasswordCheck_updatePasswordCheckAndPasswordCheckState() {
    
    // Given
    let passwordCheckStateObserver = self.scheduler.createObserver(InputState.self)
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(0, "test"),
    ])
    let passwordCheckTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test1"),
      .next(20, "test"),
      .next(30, "tes"),
    ])
    
    // When
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCheckTextFieldObservable
      .bind(to: self.input.passwordCheckTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.passwordCheckState
      .subscribe(passwordCheckStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(passwordCheckStateObserver.events, [.next(0, .empty),
                                                       .next(10, .wrongFormat),
                                                       .next(20, .success),
                                                       .next(30, .wrongFormat)])
    let actual = self.viewModel.passwordCheck
    let expexted = "tes"
    XCTAssertEqual(actual, expexted)
  }
  
  // passwordCheckTextField Edit
  func testTransform_editPassword_ifSuccess_showPasswordCheckSection() {
    
    // Given
    let hidePasswordCheckSectionObserver = self.scheduler.createObserver(Bool.self)
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test"),
    ])
    
    // When
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.hidePasswordCheckSection
      .subscribe(hidePasswordCheckSectionObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(hidePasswordCheckSectionObserver.events, [.next(0, true),
                                                             .next(10, false)])
    
  }
  
  // passwordCheckTextField Edit
  func testTransform_editpasswordAndPasswordCheck_updateCanDone() {
    
    // Given
    let canDoneObserver = self.scheduler.createObserver(Bool.self)
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test"),
    ])
    
    let passwordCheckTextFieldObservable = self.scheduler.createHotObservable([
      .next(20, "test"),
      .next(30, "test1")
    ])
    
    // When
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCheckTextFieldObservable
      .bind(to: self.input.passwordCheckTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.canDone
      .subscribe(canDoneObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(canDoneObserver.events, [.next(0, false),
                                            .next(20, true),
                                            .next(30, false)])
    
  }
  
  func testTransform_clickNextButtonWhenCanDone() {
    
    // Given
    let passwordTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test"),
    ])
    
    let passwordCheckTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "test"),
    ])
    
    let nextButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    // When
    passwordTextFieldObservable
      .bind(to: self.input.passwordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCheckTextFieldObservable
      .bind(to: self.input.passwordCheckTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nextButtonObservable
      .bind(to: self.input.nextButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let actual = (self.coordinator as! MockSignUpCoordinator).showSignUpGenderViewControllerCalledCount
    let expected = 1
    XCTAssertEqual(actual, expected)
    
  }
  
}
