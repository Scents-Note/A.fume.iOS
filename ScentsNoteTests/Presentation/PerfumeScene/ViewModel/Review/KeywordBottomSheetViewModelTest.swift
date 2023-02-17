//
//  KeywordBottomSheetViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/31.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class KeywordBottomSheetViewModelTest: XCTestCase {
  private var coordinator: PerfumeReviewCoordinator!
  private var delegate: BottomSheetDismissDelegate!
  private var viewModel: KeywordBottomSheetViewModel!
  private var input: KeywordBottomSheetViewModel.Input!
  private var output: KeywordBottomSheetViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeReviewCoordinator()
    self.delegate = MockBottomSheetDismissDelegate()
    let keywords = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 1, name: "키워드1", isSelected: false),
                    Keyword(idx: 2, name: "키워드2", isSelected: false),
                    Keyword(idx: 3, name: "키워드3", isSelected: false),
                    Keyword(idx: 4, name: "키워드4", isSelected: false),
                    Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    self.viewModel = KeywordBottomSheetViewModel(coordinator: self.coordinator,
                                                 delegate: self.delegate,
                                                 keywords: keywords)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.delegate = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // BottomSheet가 올라올 때 Keywords가 잘 업데이트 되는 지
  func testFetchDatas_updateKeywords() throws {
    
    // Given
    let observer = self.scheduler.createObserver([FilterKeywordDataSection.Model].self)
    
    let keywords = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 1, name: "키워드1", isSelected: false),
                    Keyword(idx: 2, name: "키워드2", isSelected: false),
                    Keyword(idx: 3, name: "키워드3", isSelected: false),
                    Keyword(idx: 4, name: "키워드4", isSelected: false),
                    Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let items = keywords.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expected = [FilterKeywordDataSection.Model(model: "keyword", items: items)]
    
    // When
    self.output.keywords
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    // Then
    XCTAssertEqual(observer.events, [.next(0, expected)])
  }
  
  // Keyword Cell 클릭시 output의 keywords 업데이트
  func testTransform_clickKeyword_updateKeywords() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2),
                                                         .next(20, 4)])
    
    let observer = self.scheduler.createObserver([FilterKeywordDataSection.Model].self)
    
    let keywordsAt10 = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: true),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: false),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let itemsAt10 = keywordsAt10.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expectedAt10 = [FilterKeywordDataSection.Model(model: "keyword", items: itemsAt10)]
    
    let keywordsAt20 = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: true),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: true),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let itemsAt20 = keywordsAt20.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expectedAt20 = [FilterKeywordDataSection.Model(model: "keyword", items: itemsAt20)]
    
    // When
    observable
      .bind(to: self.input.keywordCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywords
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events[1...2], [.next(10, expectedAt10),
                                            .next(20, expectedAt20)])
  }
  
  // Keyword Cell 클릭시 output의 keywords 업데이트
  func testTransform_clickConfirmButton_updateCloseAndKeywords() throws {
    
    // Given
    let keywordObservable = self.scheduler.createHotObservable([.next(0, 2),
                                                                .next(0, 4)])
    
    let confirmButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    
    let observer = self.scheduler.createObserver(Bool.self)
    let expected = true
    
    let expectedKeywords = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                            Keyword(idx: 1, name: "키워드1", isSelected: false),
                            Keyword(idx: 2, name: "키워드2", isSelected: true),
                            Keyword(idx: 3, name: "키워드3", isSelected: false),
                            Keyword(idx: 4, name: "키워드4", isSelected: true),
                            Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    // When
    keywordObservable
      .bind(to: self.input.keywordCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    confirmButtonObservable
      .bind(to: self.input.confirmButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.hideBottomSheet
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [.next(10, expected)])
    
    let actualKeywords = (self.delegate as! MockBottomSheetDismissDelegate).keywords
    XCTAssertEqual(actualKeywords, expectedKeywords)
  }
  
  // setState 실행시 state 업데이트
  func testSetstate_updateState() throws {
    
    // Given
    let expected = KeywordBottomSheetViewModel.State.fill
                            
    // When
    self.viewModel.setState(state: .fill)
    
    // Then
    let actual = self.viewModel.state
    XCTAssertEqual(actual, expected)
  }
  
}
