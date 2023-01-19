//
//  SignUpInformationViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/17.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SignUpInformationViewModelTest: XCTestCase {
  private var coordinator: SignUpCoordinator!
  private var checkDuplicateEmailUseCase: CheckDuplicateEmailUseCase!
  private var checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase!
  private var viewModel: SignUpInformationViewModel!
  private var input: SignUpInformationViewModel.Input!
  private var output: SignUpInformationViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSignUpCoordinator()
    self.checkDuplicateEmailUseCase = MockCheckDuplicateEmailUseCase()
    self.checkDuplicateNicknameUseCase = MockCheckDuplicateNicknameUseCase()
    self.viewModel = SignUpInformationViewModel(coordinator: self.coordinator,
                                                checkDuplcateEmailUseCase: self.checkDuplicateEmailUseCase,
                                                checkDuplicateNicknameUseCase: self.checkDuplicateNicknameUseCase)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // emailTextField Edit
  func testTransform_editEmailTextField_updateEmailAndEmailState() {
    
    // Given
    let emailStateObserver = self.scheduler.createObserver(InputState.self)
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "dyh0624"),
      .next(20, "dyh0624@naver.com"),
      .next(30, "dyh0624@naver.com!"),
      .next(40, "")
    ])
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.emailState
      .subscribe(emailStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(emailStateObserver.events, [.next(0, .empty),
                                               .next(10, .wrongFormat),
                                               .next(20, .correctFormat),
                                               .next(30, .wrongFormat),
                                               .next(40, .empty)])
    let actual = self.viewModel.email
    let expexted = ""
    XCTAssertEqual(actual, expexted)
  }
  
  // nicknameTextField Edit
  func testTransform_editNicknameTextField_updateNicknameAndNicknameState() {
    
    // Given
    let NicknameStateObserver = self.scheduler.createObserver(InputState.self)
    let NicknameTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "!@#"),
      .next(20, "testemr"),
      .next(30, "testemr!"),
      .next(40, "")
    ])
    
    // When
    NicknameTextFieldObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.nicknameState
      .subscribe(NicknameStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(NicknameStateObserver.events, [.next(0, .empty),
                                                  .next(10, .wrongFormat),
                                                  .next(20, .correctFormat),
                                                  .next(30, .wrongFormat),
                                                  .next(40, .empty)])
    
    let actualNickname = self.viewModel.nickname
    let expextedNickname = ""
    XCTAssertEqual(actualNickname, expextedNickname)
  }
  
  // Email 중복 체크 성공
  func testTransform_clickEmailCheckButton_success() {
    
    // Given
    let emailStateObserver = self.scheduler.createObserver(InputState.self)
    let hideNicknameSectionObserver = self.scheduler.createObserver(Bool.self)
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "ghkdemrdus@gmail.com"),
    ])
    
    let emailCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ()),
    ])
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    emailCheckButtonObservable
      .bind(to: self.input.emailCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.emailState
      .subscribe(emailStateObserver)
      .disposed(by: self.disposeBag)
    
    self.output.hideNicknameSection
      .subscribe(hideNicknameSectionObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(emailStateObserver.events, [.next(0, .empty),
                                               .next(10, .correctFormat),
                                               .next(20, .success)])
    
    XCTAssertEqual(hideNicknameSectionObserver.events, [.next(0, true),
                                                        .next(20, false)])
  }
  
  // Email 중복 체크 실패
  func testTransform_clickEmailCheckButton_failure() {
    
    // Given
    (self.checkDuplicateEmailUseCase as! MockCheckDuplicateEmailUseCase).setState(state: .failure)
    
    let emailStateObserver = self.scheduler.createObserver(InputState.self)
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "ghkdemrdus@gmail.com"),
    ])
    
    let emailCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ()),
    ])
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    emailCheckButtonObservable
      .bind(to: self.input.emailCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.emailState
      .subscribe(emailStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(emailStateObserver.events, [.next(0, .empty),
                                               .next(10, .correctFormat),
                                               .next(20, .duplicate)])
  }
  
  // Nickname 중복 체크 성공
  func testTransform_clickNicknameCheckButton_success() {
    
    // Given
    let nicknameStateObserver = self.scheduler.createObserver(InputState.self)
    let nicknameTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "testemr"),
    ])
    
    let nicknameCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ()),
    ])
    
    // When
    nicknameTextFieldObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nicknameCheckButtonObservable
      .bind(to: self.input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.nicknameState
      .subscribe(nicknameStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(nicknameStateObserver.events, [.next(0, .empty),
                                                  .next(10, .correctFormat),
                                                  .next(20, .success)])
    
  }
  
  // Nickname 중복 체크 실패
  func testTransform_clickNicknameCheckButton_failure() {
    
    // Given
    (self.checkDuplicateNicknameUseCase as! MockCheckDuplicateNicknameUseCase).setState(state: .failure)
    
    let nicknameStateObserver = self.scheduler.createObserver(InputState.self)
    let nicknameTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "testemr"),
    ])
    
    let nicknameCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ()),
    ])
    
    // When
    nicknameTextFieldObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nicknameCheckButtonObservable
      .bind(to: self.input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.nicknameState
      .subscribe(nicknameStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(nicknameStateObserver.events, [.next(0, .empty),
                                                  .next(10, .correctFormat),
                                                  .next(20, .duplicate)])
  }
  
  func testTransform_editEmailAndNickname_updateCanDone() {
    
    // Given
    
    let canDoneObserver = self.scheduler.createObserver(Bool.self)
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "ghkdemrdus@gmail.com"),
      .next(50, "ghkdemrdus@gmail.co")
    ])
    
    let emailCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    let nicknameTextFieldObservable = self.scheduler.createHotObservable([
      .next(30, "testemr")
    ])
    
    let nicknameCheckButtonObservable = self.scheduler.createHotObservable([
      .next(40, ())
    ])
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    emailCheckButtonObservable
      .bind(to: self.input.emailCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    nicknameTextFieldObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nicknameCheckButtonObservable
      .bind(to: self.input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.canDone
      .subscribe(canDoneObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(canDoneObserver.events, [.next(0, false),
                                            .next(30, false),
                                            .next(40, true),
                                            .next(50, false)])
  }
  
  func testTransform_clickNextButton() {
    
    // Given
    let emailTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "ghkdemrdus@gmail.com"),
    ])
    
    let emailCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    let nicknameTextFieldObservable = self.scheduler.createHotObservable([
      .next(10, "testemr")
    ])
    
    let nicknameCheckButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    
    let nextButtonObservable = self.scheduler.createHotObservable([
      .next(30, ())
    ])
    
    // When
    emailTextFieldObservable
      .bind(to: self.input.emailTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    emailCheckButtonObservable
      .bind(to: self.input.emailCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    nicknameTextFieldObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nicknameCheckButtonObservable
      .bind(to: self.input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    nextButtonObservable
      .bind(to: self.input.nextButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSignUpCoordinator).showSignUpPasswordViewControllerCalledCount
    let expected = 1
    XCTAssertEqual(actual, expected)
  }
  
}

