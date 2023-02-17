//
//  ChangePasswordViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class ChangePasswordViewModelTest: XCTestCase {
  
  private var coordinator: ChangePasswordCoordinator!
  private var fetchUserPasswordUseCase: FetchUserPasswordUseCase!
  private var changePasswordUseCase: ChangePasswordUseCase!
  private var savePasswordUseCase: SavePasswordUseCase!
  private var viewModel: ChangePasswordViewModel!
  private var input: ChangePasswordViewModel.Input!
  private var output: ChangePasswordViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockChangePasswordCoordinator()
    self.fetchUserPasswordUseCase = MockFetchUserPasswordUseCase()
    self.changePasswordUseCase = MockChangePasswordUseCase()
    self.savePasswordUseCase = MockSavePasswordUseCase()
    self.viewModel = ChangePasswordViewModel(coordinator: self.coordinator,
                                             fetchUserPasswordUseCase: self.fetchUserPasswordUseCase,
                                             changePasswordUseCase: self.changePasswordUseCase,
                                             savePasswordUseCase: self.savePasswordUseCase)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchUserPasswordUseCase = nil
    self.changePasswordUseCase = nil
    self.savePasswordUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testTransform_editPasswordCurrentAndCheckButton_updateState() throws {
    
    // Given
    let passwordObservable = self.scheduler.createHotObservable([.next(10, "!"),
                                                                 .next(20, "test"),
                                                                 .next(40, "")])
    
    let passwordCheckObservable = self.scheduler.createHotObservable([.next(30, ())])
    let passwordStateObserver = self.scheduler.createObserver(InputState.self)
    
    let expectedOld = "test"
    let expectedPassword = ""
    
    // When
    passwordObservable
      .bind(to: self.input.passwordCurrentDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCheckObservable
      .bind(to: self.input.passwordCurrentCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.passwordCurrentState
      .subscribe(passwordStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualOld = self.viewModel.passwordOld
    let actualPassword = self.viewModel.passwordCurrent
    
    XCTAssertEqual(passwordStateObserver.events, [.next(0, .empty),
                                                  .next(10, .wrongFormat),
                                                  .next(20, .correctFormat),
                                                  .next(30, .success),
                                                  .next(40, .empty)])
    
    
    XCTAssertEqual(actualOld, expectedOld)
    XCTAssertEqual(actualPassword, expectedPassword)
  }
  
  func testTransform_editPasswordAndPasswordCheck_updateStateAndCanDone() throws {
    
    // Given
    let passwordCurrentObservable = self.scheduler.createHotObservable([.next(0, "test")])
    let passwordCurrentCheckObservable = self.scheduler.createHotObservable([.next(0, ())])
    
    let passwordObservable = self.scheduler.createHotObservable([.next(3, ""),
                                                                 .next(5, "te"),
                                                                 .next(10, "test"),
                                                                 .next(20, "test2"),
                                                                 .next(50, "test22")])
    
    let passwordCheckObservable = self.scheduler.createHotObservable([.next(30, "t"),
                                                                      .next(40, "test2")])
    
    let passwordStateObserver = self.scheduler.createObserver(InputState.self)
    let passwordCheckStateObserver = self.scheduler.createObserver(InputState.self)
    let canDoneObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedPassword = "test22"
    let expectedPasswordCheck = "test2"
    
    // When
    passwordCurrentObservable
      .bind(to: self.input.passwordCurrentDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCurrentCheckObservable
      .bind(to: self.input.passwordCurrentCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    passwordObservable
      .bind(to: self.input.passwordDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCheckObservable
      .bind(to: self.input.passwordCheckDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.passwordState
      .subscribe(passwordStateObserver)
      .disposed(by: self.disposeBag)
    
    self.output.passwordCheckState
      .subscribe(passwordCheckStateObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canDone
      .subscribe(canDoneObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualPassword = self.viewModel.password
    let actualPasswordCheck = self.viewModel.passwordCheck
    
    XCTAssertEqual(passwordStateObserver.events, [.next(0, .empty),
                                                  .next(3, .empty),
                                                  .next(5, .wrongFormat),
                                                  .next(10, .duplicate),
                                                  .next(20, .success),
                                                  .next(50, .success)])
    
    XCTAssertEqual(passwordCheckStateObserver.events, [.next(0, .empty),
                                                       .next(3, .empty),
                                                       .next(5, .empty),
                                                       .next(10, .empty),
                                                       .next(20, .empty),
                                                       .next(30, .wrongFormat),
                                                       .next(40, .success),
                                                       .next(50, .wrongFormat)])
    
    XCTAssertEqual(canDoneObserver.events, [.next(0, false),
                                            .next(30, false),
                                            .next(40, true),
                                            .next(50, true),
                                            .next(50, false)])
    
    XCTAssertEqual(actualPassword, expectedPassword)
    XCTAssertEqual(actualPasswordCheck, expectedPasswordCheck)
  }
  
  func testTransform_clickDoneButton_ifSuccessChangingPassword_savePWAndFinish() throws {
    
    // Given
    let passwordCurrentObservable = self.scheduler.createHotObservable([.next(10, "test")])
    let passwordCurrentCheckObservable = self.scheduler.createHotObservable([.next(10, ())])
    let passwordObservable = self.scheduler.createHotObservable([.next(20, "test2")])
    let passwordCheckObservable = self.scheduler.createHotObservable([.next(20, "test2")])
    let doneButtonObservable = self.scheduler.createHotObservable([.next(30, ())])
    
    let expectedSavePassword = 1
    let expectedFinishCalled = 1
    
    // When
    passwordCurrentObservable
      .bind(to: self.input.passwordCurrentDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCurrentCheckObservable
      .bind(to: self.input.passwordCurrentCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    passwordObservable
      .bind(to: self.input.passwordDidEditEvent)
      .disposed(by: self.disposeBag)
    
    passwordCheckObservable
      .bind(to: self.input.passwordCheckDidEditEvent)
      .disposed(by: self.disposeBag)
    
    doneButtonObservable
      .bind(to: self.input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualSavePassword = (self.savePasswordUseCase as! MockSavePasswordUseCase).executeCalledCount
    let actualFinishCalled = (self.coordinator as! MockChangePasswordCoordinator).finishFlowCalledCount
    
    XCTAssertEqual(actualSavePassword, expectedSavePassword)
    XCTAssertEqual(actualFinishCalled, expectedFinishCalled)
  }
  
}
