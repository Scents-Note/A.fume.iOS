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
  private var viewModel: SignUpInformationViewModel!
  private var coordinator: SignUpCoordinator!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSignUpCoordinator()
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // Input emailTextField Edit 체크
//  func testTransform_editEmailTextField_updateEmailAndEmailState() {
//    
//    // Given
//    let emailTextFieldObservable = self.scheduler.createHotObservable([
//      .next(10, "dyh0624")
//      .next(20, "dyh0624@naver.com")
//      .next(30, "dyh0624@naver.com!")
//    ])
//    
//    // When
//    let input = SignUpInformationViewModel.Input(emailTextFieldDidEditEvent: <#T##Observable<String>#>,
//                                                 emailCheckButtonDidTapEvent: <#T##Observable<Void>#>,
//                                                 nicknameTextFieldDidEditEvent: <#T##Observable<String>#>,
//                                                 nicknameCheckButtonDidTapEvent: <#T##Observable<Void>#>,
//                                                 nextButtonDidTapEvent: <#T##Observable<Void>#>)
//    
//    let _ = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
//    
//    // Then
//    self.scheduler.start()
//    
//    let expected = 1
//    let actual = (self.coordinator as! MockSignUpCoordinator).finishFlowCalledCount =
//    
//    XCTAssertEqual(actual, expected)
//  }
//
//  // 회원가입 버튼 누를 시 signUpFlow 동작
//  func testTransform_clickLoginButton_runSignUpFlow() {
//    
//    // Given
//    let signUpButtonObservable = self.scheduler.createHotObservable([
//      .next(20, ())
//    ])
//    
//    // When
//    let input = OnboardingViewModel.Input(loginButtonDidTapEvent: Observable.just(()),
//                                          signUpButtonDidTapEvent: signUpButtonObservable.asObservable())
//    
//    let _ = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
//    
//    // Then
//    self.scheduler.start()
//    
//    let expected = 1
//    let actual = (self.coordinator as! MockOnboardingCoordinator).runSignUpFlowCalledCount
//    
//    XCTAssertEqual(actual, expected)
//  }
}

