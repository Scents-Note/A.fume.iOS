//
//  SearchKeywordViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SearchKeywordViewModelTest: XCTestCase {
  private var coordinator: SearchKeywordCoordinator!
  private var viewModel: SearchKeywordViewModel!
  private var input: SearchKeywordViewModel.Input!
  private var output: SearchKeywordViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSearchKeywordCoordinator()
    self.viewModel = SearchKeywordViewModel(coordinator: self.coordinator, from: .search)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testTransform_editKeywordAndClickSearch_finish() throws {
   
    // Given
    let keywordObservable = self.scheduler.createHotObservable([.next(10, "조 말론")])
    let searchButtonObservable = self.scheduler.createHotObservable([.next(20, ())])
    let finishObserver = self.scheduler.createObserver(CoordinatorType.self)
    
    let expectedSearchWord = "조 말론"
    let expectedFlowCalled = 1
    
    // When
    keywordObservable
      .bind(to: self.input.keywordTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    searchButtonObservable
      .bind(to: self.input.searchButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.finish
      .subscribe(finishObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualSearchWord = self.viewModel.searchWord
    let actualFlowCalled = (self.coordinator as! MockSearchKeywordCoordinator).finishFlowCalledCount
    
    XCTAssertEqual(actualSearchWord, expectedSearchWord)
    XCTAssertEqual(actualFlowCalled, expectedFlowCalled)
    XCTAssertEqual(finishObserver.events, [.next(0, .search),
                                           .next(20, .search)])
    
  }

}
