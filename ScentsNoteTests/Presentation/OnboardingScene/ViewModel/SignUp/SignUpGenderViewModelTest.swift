//
//  SignUpGenderViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/19.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SignUpGenderViewModelTest: XCTestCase {
  private var coordinator: SignUpCoordinator!
  private var viewModel: SignUpGenderViewModel!
  private var input: SignUpGenderViewModel.Input!
  private var output: SignUpGenderViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSignUpCoordinator()
    self.viewModel = SignUpGenderViewModel(coordinator: self.coordinator, signUpInfo: SignUpInfo.init())
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
  
  func testTransform_clickManAndWomanButton_updateGenderState() {
    
    // Given
    let genderStateObserver = self.scheduler.createObserver(GenderState.self)
    let manButtonObservable = self.scheduler.createHotObservable([
      .next(10, ()),
      .next(30, ())
    ])
    
    let womanButtonObservable = self.scheduler.createHotObservable([
      .next(20, ()),
      .next(40, ())
    ])

    // When
    manButtonObservable
      .bind(to: self.input.manButtonDidTapEvent)
      .disposed(by: self.disposeBag)

    womanButtonObservable
      .bind(to: self.input.womanButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.genderState
      .subscribe(genderStateObserver)
      .disposed(by: self.disposeBag)

    self.scheduler.start()

    // Then
    XCTAssertEqual(genderStateObserver.events, [.next(0, .none),
                                                .next(10, .man),
                                                .next(20, .woman),
                                                .next(30, .man),
                                                .next(40, .woman)])
  }
  
  func testTransform_clickNextButton_success() {
    
    // Given
    let nextButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])
    let manButtonObservable = self.scheduler.createHotObservable([
      .next(10, ()),
    ])
    
    // When
    manButtonObservable
      .bind(to: self.input.manButtonDidTapEvent)
      .disposed(by: self.disposeBag)

    nextButtonObservable
      .bind(to: self.input.nextButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    

    self.scheduler.start()

    // Then
    let expected = 1
    let actual = (self.coordinator as! MockSignUpCoordinator).showSignUpBirthViewControllerCalledCount
    XCTAssertEqual(actual, expected)
  }
}
