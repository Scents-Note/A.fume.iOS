//
//  SearchFilterKeywordViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SearchFilterKeywordViewModelTest: XCTestCase {
  private var viewModel: SearchFilterKeywordViewModel!
  private var filterDelegate: FilterDelegate!
  private var fetchKeywordsUseCase: FetchKeywordsUseCase!
  private var input: SearchFilterKeywordViewModel.Input!
  private var output: SearchFilterKeywordViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.filterDelegate = MockFilterDelegate()
    self.fetchKeywordsUseCase = MockFetchKeywordsUseCase()
    self.viewModel = SearchFilterKeywordViewModel(filterDelegate: self.filterDelegate,
                                                  fetchKeywordsUseCase: self.fetchKeywordsUseCase)
    
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.viewModel = nil
    self.filterDelegate = nil
    self.fetchKeywordsUseCase = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  // keywords 데이터가 잘 Fetch 되어 Output이 잘 들어갔는지 확인
  func testFetchDatas_updateKeywords_success() throws {
    
    // Given
    let keywordsObserver = self.scheduler.createObserver([FilterKeywordDataSection.Model].self)
    
    let keywords = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 1, name: "키워드1", isSelected: false),
                    Keyword(idx: 2, name: "키워드2", isSelected: false),
                    Keyword(idx: 3, name: "키워드3", isSelected: false),
                    Keyword(idx: 4, name: "키워드4", isSelected: false),
                    Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let items = keywords.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expected = [FilterKeywordDataSection.Model(model: "keyword", items: items)]
    
    
    //When
    self.output.keywordDataSource
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(keywordsObserver.events.last, .next(0, expected))
  }
  
  // keyword Cell 클릭시 Output 및 필드에 값이 잘 들어갔는지 확인
  func testTransfom_clickKeyword_updateKeywords() throws {
    
    // Given
    let keywordsObservable = self.scheduler.createHotObservable([.next(10, 0),
                                                                 .next(20, 2)])
    let keywordsObserver = self.scheduler.createObserver([FilterKeywordDataSection.Model].self)
    
    let keywordsAt10 = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: false),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: false),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let keywordsAt20 = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: true),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: false),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let expected = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 2, name: "키워드2", isSelected: false)]
    
    let itemsAt10 = keywordsAt10.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expectedAt10 = [FilterKeywordDataSection.Model(model: "keyword", items: itemsAt10)]
    
    let itemsAt20 = keywordsAt20.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expectedAt20 = [FilterKeywordDataSection.Model(model: "keyword", items: itemsAt20)]
    
    
    //When
    keywordsObservable
      .bind(to: self.input.keywordCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywordDataSource
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let eventCnt = keywordsObserver.events.count
    XCTAssertEqual(keywordsObserver.events[eventCnt - 2], .next(10, expectedAt10))
    XCTAssertEqual(keywordsObserver.events[eventCnt - 1], .next(20, expectedAt20))
    
    let actual = self.viewModel.keywords
    XCTAssertEqual(actual, expected)
  }
  
  // 선택된 keyword Cell 클릭시 Output Keyword 값 업데이트
  func testTransfom_clickKeywordSelected_updateKeywords() throws {
    
    // Given
    let keywordsObservable = self.scheduler.createHotObservable([.next(10, 0),
                                                                 .next(20, 0)])
    
    let keywordsObserver = self.scheduler.createObserver([FilterKeywordDataSection.Model].self)
    
    let keywordsAt10 = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: false),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: false),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let keywordsAt20 = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: false),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: false),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let itemsAt10 = keywordsAt10.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expectedAt10 = [FilterKeywordDataSection.Model(model: "keyword", items: itemsAt10)]
    
    let itemsAt20 = keywordsAt20.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expectedAt20 = [FilterKeywordDataSection.Model(model: "keyword", items: itemsAt20)]
    
    
    //When
    keywordsObservable
      .bind(to: self.input.keywordCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywordDataSource
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let eventCnt = keywordsObserver.events.count
    XCTAssertEqual(keywordsObserver.events[eventCnt - 2], .next(10, expectedAt10))
    XCTAssertEqual(keywordsObserver.events[eventCnt - 1], .next(20, expectedAt20))
  }
  
  // 5개 넘어서 Keyword를 클릭할 때 더이상 업데이트 X
  func testTransfom_clickKeywordMoreThan5_notUpdateKeywords() throws {
    
    // Given
    let keywordsObservable = self.scheduler.createHotObservable([.next(10, 0),
                                                                 .next(10, 1),
                                                                 .next(10, 2),
                                                                 .next(10, 3),
                                                                 .next(10, 4),
                                                                 .next(20, 5)])
    
    let keywordsObserver = self.scheduler.createObserver([FilterKeywordDataSection.Model].self)
    
    let keywords = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                    Keyword(idx: 1, name: "키워드1", isSelected: true),
                    Keyword(idx: 2, name: "키워드2", isSelected: true),
                    Keyword(idx: 3, name: "키워드3", isSelected: true),
                    Keyword(idx: 4, name: "키워드4", isSelected: true),
                    Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let expectedKeywordsOnField = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                                   Keyword(idx: 1, name: "키워드1", isSelected: false),
                                   Keyword(idx: 2, name: "키워드2", isSelected: false),
                                   Keyword(idx: 3, name: "키워드3", isSelected: false),
                                   Keyword(idx: 4, name: "키워드4", isSelected: false)]
    
    let items = keywords.map { FilterKeywordDataSection.Item(keyword: $0) }
    let expected = [FilterKeywordDataSection.Model(model: "keyword", items: items)]
    
    //When
    keywordsObservable
      .bind(to: self.input.keywordCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywordDataSource
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(keywordsObserver.events.last, .next(20, expected))
    
    let actual = self.viewModel.keywords
    XCTAssertEqual(actual, expectedKeywordsOnField)
    
  }
  
  // keyword Cell 클릭시 filterDelegate의 updateKeyword 실행 여부
  func testTransfom_clickKeyword_updateKeywordsInFilterDelegate() throws {
    
    // Given
    let keywordsObservable = self.scheduler.createHotObservable([.next(10, 0),
                                                                 .next(20, 2)])
    
    let expectedAt10 = [Keyword(idx: 0, name: "키워드0", isSelected: false)]
    
    
    let expectedAt20 = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: false)]
    
    
    
    
    //When
    keywordsObservable
      .bind(to: self.input.keywordCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actualAt10 = (self.filterDelegate as! MockFilterDelegate).keywordsUpdated
      XCTAssertEqual(actualAt10, expectedAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actualAt20 = (self.filterDelegate as! MockFilterDelegate).keywordsUpdated
      XCTAssertEqual(actualAt20, expectedAt20)
    }
  }
  
}
