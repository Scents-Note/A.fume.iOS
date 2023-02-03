//
//  SignUpBirthViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/19.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SignUpBirthViewModelTest: XCTestCase {
  private var coordinator: SignUpCoordinator!
  private var viewModel: SignUpBirthViewModel!
  private var input: SignUpBirthViewModel.Input!
  private var popupInput : SignUpBirthViewModel.PopupInput!
  private var output: SignUpBirthViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSignUpCoordinator()
    self.viewModel = SignUpBirthViewModel(coordinator: self.coordinator,
                                          signUpUseCase: MockSignUpUseCase(),
                                          saveLoginInfoUseCase: MockSaveLoginInfoUseCase(),
                                          signUpInfo: SignUpInfo.init())
    self.input = self.viewModel.input
    self.popupInput = self.viewModel.popupInput
    self.output = self.viewModel.output
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.input = nil
    self.popupInput = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testTransform_clickBirthButton_showPopup() {
    
    // Given
    let birthButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])

    // When
    birthButtonObservable
      .bind(to: self.input.birthButtonDidTapEvent)
      .disposed(by: self.disposeBag)

    self.scheduler.start()

    // Then
    let expected = 1
    let acutal = (self.coordinator as! MockSignUpCoordinator).showBirthPopupViewControllerCalledCount
    XCTAssertEqual(acutal, expected)
  }
  
  func testTransform_doneBirthButton_showPopup() {
    
    // Given
    let doneButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])

    // When
    doneButtonObservable
      .bind(to: self.input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)

    self.scheduler.start()

    // Then
    let expected = 1
    let acutal = (self.coordinator as! MockSignUpCoordinator).finishFlowCalledCount
    XCTAssertEqual(acutal, expected)

  }
  
  func testTransform_birthPopUpDismiss_updateBirth() {
    
    // Given
    let birthObserver = self.scheduler.createObserver(Int.self)
    

    // When
    self.viewModel.confirm(with: 1995)
    
    self.output.birth
      .bind(to: birthObserver)
      .disposed(by: self.disposeBag)

    self.scheduler.start()

    // Then
    let expected = 1995
    XCTAssertEqual(birthObserver.events, [.next(0, expected)])
    XCTAssertEqual(self.viewModel.birth, expected)
  }

}
