//
//  EditInformationViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class EditInformationViewModelTest: XCTestCase {
  
  private var coordinator: EditInformationCoordinator!
  private var fetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase!
  private var checkDuplicateNicknameUseCase: CheckDuplicateNicknameUseCase!
  private var updateUserInformationUseCase: UpdateUserInformationUseCase!
  private var saveEditUserInfoUseCase: SaveEditUserInfoUseCase!
  private var viewModel: EditInformationViewModel!
  private var input: EditInformationViewModel.Input!
  private var popupInput: EditInformationViewModel.PopupInput!
  private var output: EditInformationViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockEditInformationCoordinator()
    self.fetchUserInfoForEditUseCase = MockFetchUserInfoForEditUseCase()
    self.checkDuplicateNicknameUseCase = MockCheckDuplicateNicknameUseCase()
    self.updateUserInformationUseCase = MockUpdateUserInformationUseCase()
    self.saveEditUserInfoUseCase = MockSaveEditUserInfoUseCase()
    self.viewModel = EditInformationViewModel(coordinator: self.coordinator,
                                              fetchUserInfoForEditUseCase: self.fetchUserInfoForEditUseCase,
                                              checkDuplicateNicknameUseCase: self.checkDuplicateNicknameUseCase,
                                              updateUserInformationUseCase: self.updateUserInformationUseCase,
                                              saveUserInfoUseCase: self.saveEditUserInfoUseCase)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchUserInfoForEditUseCase = nil
    self.checkDuplicateNicknameUseCase = nil
    self.updateUserInformationUseCase = nil
    self.saveEditUserInfoUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.popupInput = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testTransform_editNicknameAndCheck_ifSuccess_updateCanDone() throws {
    
    // Given
    let nicknameObservable = self.scheduler.createHotObservable([.next(0, ""),
                                                                 .next(10, "득연2"),
                                                                 .next(30, "득연"),
                                                                 .next(40, "득연!")])
    let nicknameCheckObservable = self.scheduler.createHotObservable([.next(20, ())])
    let nicknameStateObserver = self.scheduler.createObserver(InputState.self)
    let canDoneObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedOld = EditUserInfo(nickname: "득연", gender: "MAN", birth: 1995)
    let expectedNew = EditUserInfo(nickname: "득연!", gender: "MAN", birth: 1995)
    
    // When
    nicknameObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nicknameCheckObservable
      .bind(to: self.input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.nicknameState
      .subscribe(nicknameStateObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canDone
      .subscribe(canDoneObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualOld = self.viewModel.oldUserInfo
    let actualNew = self.viewModel.newUserInfo
    
    XCTAssertEqual(nicknameStateObserver.events, [.next(0, .success),
                                                  .next(10, .correctFormat),
                                                  .next(20, .success),
                                                  .next(30, .empty),
                                                  .next(40, .wrongFormat)])
    
    XCTAssertEqual(canDoneObserver.events, [.next(0, false),
                                            .next(10, false),
                                            .next(20, true),
                                            .next(30, false),
                                            .next(40, false)])
    
    XCTAssertEqual(actualOld, expectedOld)
    XCTAssertEqual(actualNew, expectedNew)
  }
  
  func testTransform_checkNickname_failure() throws {
    
    // Given
    let nicknameObservable = self.scheduler.createHotObservable([.next(10, "득연2")])
    let nicknameCheckObservable = self.scheduler.createHotObservable([.next(20, ())])
    let nicknameStateObserver = self.scheduler.createObserver(InputState.self)
    
    (self.checkDuplicateNicknameUseCase as! MockCheckDuplicateNicknameUseCase).setState(state: .failure)
    
    // When
    nicknameObservable
      .bind(to: self.input.nicknameTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    nicknameCheckObservable
      .bind(to: self.input.nicknameCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.nicknameState
      .subscribe(nicknameStateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    XCTAssertEqual(nicknameStateObserver.events, [.next(0, .success),
                                                  .next(20, .duplicate)])
  }
  
  func testTransform_checkManAndWoman_updateGenderAndCanDone() throws {
    
    // Given
    let manButtonObservable = self.scheduler.createHotObservable([.next(20, ())])
    let womanButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    let genderObserver = self.scheduler.createObserver(String?.self)
    let canDoneObserver = self.scheduler.createObserver(Bool.self)
  
    let expectedOld = EditUserInfo(nickname: "득연", gender: "MAN", birth: 1995)
    let expectedNew = EditUserInfo(nickname: "득연", gender: "MAN", birth: 1995)
    
    // When
    manButtonObservable
      .bind(to: self.input.manButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    womanButtonObservable
      .bind(to: self.input.womanButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.gender
      .subscribe(genderObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canDone
      .subscribe(canDoneObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualOld = self.viewModel.oldUserInfo
    let actualNew = self.viewModel.newUserInfo
    
    XCTAssertEqual(genderObserver.events, [.next(0, "MAN"),
                                           .next(10, "WOMAN"),
                                           .next(20, "MAN")])
    
    XCTAssertEqual(canDoneObserver.events, [.next(0, false),
                                            .next(10, true),
                                            .next(20, false)])
    
    XCTAssertEqual(actualOld, expectedOld)
    XCTAssertEqual(actualNew, expectedNew)
  }
  
  func testTransform_clickBirthButton_showBirthPopup() throws {
    
    // Given
    let birthButtonObservable = self.scheduler.createHotObservable([.next(20, ())])
    let expected = 1
    // When
    birthButtonObservable
      .bind(to: self.input.birthButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockEditInformationCoordinator).showBirthPopupViewControllerCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_doneButton_updateInfoAndrunFinish() throws {
    
    // Given
    let womanButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    let doneButtonObservable = self.scheduler.createHotObservable([.next(20, ())])
    let expectedFinishCalled = 1
    let expectedSaveEditInfoCalled = 1
    // When
    womanButtonObservable
      .bind(to: self.input.womanButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    doneButtonObservable
      .bind(to: self.input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualFinishCalled = (self.coordinator as! MockEditInformationCoordinator).finishFlowCalledCount
    let actualSaveEditInfoCalled = (self.saveEditUserInfoUseCase as! MockSaveEditUserInfoUseCase).executeCalledCount
    
    XCTAssertEqual(actualFinishCalled, expectedFinishCalled)
    XCTAssertEqual(actualSaveEditInfoCalled, expectedSaveEditInfoCalled)
  }
  
  func testTransform_clickwithdrawalButton_showBirthPopup() throws {
    
    // Given
    let withdrawalButtonObservable = self.scheduler.createHotObservable([.next(20, ())])
    let expected = 1
    
    // When
    withdrawalButtonObservable
      .bind(to: self.input.withdrawalButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockEditInformationCoordinator).showWebViewControllerCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testBirthPopupDismiss_updateBirth() throws {
    
    // Given
    let birthObserver = self.scheduler.createObserver(Int?.self)
    
    self.scheduler.scheduleAt(10) {
      self.viewModel.confirm(with: 1990)
    }
    
    // When
    self.output.birth
      .subscribe(birthObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(birthObserver.events, [.next(0, 1995),
                                          .next(10, 1990)])
  }
  
}
