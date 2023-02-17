//
//  LabelPopupViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class LabelPopupViewModelTest: XCTestCase {
  private var coordinator: PopUpCoordinator!
  private var delegate: LabelPopupDelegate!
  private var viewModel: LabelPopupViewModel!
  private var input: LabelPopupViewModel.Input!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPopUpCoordinator()
    self.delegate = MockLabelPopupDelegate()
    self.viewModel = LabelPopupViewModel(coordinator: self.coordinator,
                                         delegate: self.delegate)
    self.input = self.viewModel.input
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.delegate = nil
    self.viewModel = nil
    self.input = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // Dimmed View 클릭시 hidePopUp 실행
  func testTransform_clickDimmedView_hidePopUp() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    observable
      .bind(to: self.input.dimmedViewDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPopUpCoordinator).hidePopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // cancel Button 클릭시 hidePopUp 실행
  func testTransform_clickCancelButton_hidePopUp() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    observable
      .bind(to: self.input.cancelButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPopUpCoordinator).hidePopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // cancel Button 클릭시 confirm 과 hidePopUp 실행
  func testTransform_clickCancelButton_confirmAndHidePopUp() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expectedConfirmCalledCount = 1
    let expectedHidePopUpCalledCount = 1
    
    // When
    observable
      .bind(to: self.input.confirmButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualConfirmCalledCount = (self.delegate as! MockLabelPopupDelegate).confirmCalledCount
    XCTAssertEqual(actualConfirmCalledCount, expectedConfirmCalledCount)

    
    let actualHidePopUpCalledCount = (self.coordinator as! MockPopUpCoordinator).hidePopupCalledCount
    XCTAssertEqual(actualHidePopUpCalledCount, expectedHidePopUpCalledCount)
  }
  
}
