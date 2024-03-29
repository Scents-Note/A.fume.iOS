//
//  OnboardingViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/17.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class OnboardingViewModelTest: XCTestCase {
  private var coordinator: OnboardingCoordinator!
  private var viewModel: OnboardingViewModel!
  private var input: OnboardingViewModel.Input!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockOnboardingCoordinator()
    self.viewModel = OnboardingViewModel(coordinator: self.coordinator)
    self.input = self.viewModel.input
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.viewModel = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // 로그인 버튼 누를 시 LoginFlow 동작
  func testTransform_clickLoginButton_runLoginFlow() {
    
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
    let expected = 1
    let actual = (self.coordinator as! MockOnboardingCoordinator).runLoginFlowCalledCount
    
    XCTAssertEqual(actual, expected)
  }

  // 회원가입 버튼 누를 시 signUpFlow 동작
  func testTransform_clickLoginButton_runSignUpFlow() {

    // Given
    let signUpButtonObservable = self.scheduler.createHotObservable([
      .next(20, ())
    ])

    // When
    signUpButtonObservable
      .bind(to: self.input.signUpButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    self.scheduler.start()

    // Then
    let expected = 1
    let actual = (self.coordinator as! MockOnboardingCoordinator).runSignUpFlowCalledCount

    XCTAssertEqual(actual, expected)
  }
}

