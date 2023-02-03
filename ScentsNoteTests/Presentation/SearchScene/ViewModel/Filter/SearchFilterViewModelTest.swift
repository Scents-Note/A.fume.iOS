//
//  SearchFilterViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/25.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SearchFilterViewModelTest: XCTestCase {
  private var coordinator: SearchFilterCoordinator!
  private var viewModel: SearchFilterViewModel!
  private var input: SearchFilterViewModel.Input!
  private var childInput: SearchFilterViewModel.ChildInput!
  private var output: SearchFilterViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSearchFilterCoordinator()
    self.viewModel = SearchFilterViewModel(coordinator: self.coordinator,
                                           from: .search)
    
    self.input = self.viewModel.input
    self.childInput = self.viewModel.childInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.input = nil
    self.childInput = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  // 탭 누를 시에 탭과 하이라이트 업데이트
  func testTransform_clickTab_updateTabAndHighlighe() throws {
    
    // Given
    let tabObserver = self.scheduler.createObserver(Int.self)
    let highlightObserver = self.scheduler.createObserver(Int.self)
    let tabObservable = self.scheduler.createColdObservable([.next(10, 1),
                                                             .next(20, 2)])
    
    //When
    tabObservable
      .bind(to: self.input.tabDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.tabSelected
      .subscribe(tabObserver)
      .disposed(by: self.disposeBag)
    
    self.output.hightlightViewTransform
      .subscribe(highlightObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(tabObserver.events, [.next(0, 0),
                                        .next(10, 1),
                                        .next(20, 2)])
    
    XCTAssertEqual(highlightObserver.events, [.next(0, 0),
                                              .next(10, 1),
                                              .next(20, 2)])
    
  }
  
  // 하위 뷰에서 Ingredient를 업데이트 했을 때 탭 카운드와 ingredients property 업데이트
  func testTransform_updateIngredients_updateTabAndIngredients() throws {
    
    // Given
    let tabObserver = self.scheduler.createObserver([SearchTab].self)
    
    let ingredients = [FilterIngredient(id: "0", idx: 0, name: "가", isSelected: true),
                       FilterIngredient(id: "1", idx: 1, name: "나", isSelected: true)]
    
    let expectedTabs = [SearchTab(name: "계열", count: 2),
                        SearchTab(name: "브랜드", count: 0),
                        SearchTab(name: "키워드", count: 0)]
    
    let expectedIngredients = [SearchKeyword(idx: 0, name: "가", category: .ingredient),
                               SearchKeyword(idx: 1, name: "나", category: .ingredient)]
    
    //When
    
    self.scheduler.scheduleAt(10) {
      self.viewModel.updateIngredients(ingredients: ingredients)
    }
    
    self.output.tabs
      .subscribe(tabObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(tabObserver.events, [.next(0, SearchTab.default),
                                        .next(10, expectedTabs)])
    
    let actualIngredients = self.viewModel.ingredients
    XCTAssertEqual(actualIngredients, expectedIngredients)
    
  }
  
  // 하위 뷰에서 Brands를 업데이트 했을 때 탭 카운드와 brands property 업데이트
  func testTransform_updateBrands_updateTabAndBrands() throws {
    
    // Given
    let tabObserver = self.scheduler.createObserver([SearchTab].self)
    
    let brands = [FilterBrand(idx: 0, name: "브랜드1", isSelected: true),
                  FilterBrand(idx: 1, name: "브랜드2", isSelected: true),
                  FilterBrand(idx: 2, name: "브랜드3", isSelected: true)]
    
    let expectedTabs = [SearchTab(name: "계열", count: 0),
                        SearchTab(name: "브랜드", count: 3),
                        SearchTab(name: "키워드", count: 0)]
    
    let expectedBrands = [SearchKeyword(idx: 0, name: "브랜드1", category: .brand),
                          SearchKeyword(idx: 1, name: "브랜드2", category: .brand),
                          SearchKeyword(idx: 2, name: "브랜드3", category: .brand)]
    
    
    //When
    
    self.scheduler.scheduleAt(10) {
      self.viewModel.updateBrands(brands: brands)
    }
    
    self.output.tabs
      .subscribe(tabObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(tabObserver.events, [.next(0, SearchTab.default),
                                        .next(10, expectedTabs)])
    
    let actualBrands = self.viewModel.brands
    XCTAssertEqual(actualBrands, expectedBrands)
  }
  
  // 하위 뷰에서 keywords를 업데이트 했을 때 탭 카운드와 keywords property 업데이트
  func testTransform_updateKeywords_updateTabAndKeywords() throws {
    
    // Given
    let tabObserver = self.scheduler.createObserver([SearchTab].self)
    
    let keywords = [Keyword(idx: 0, name: "키워드1", isSelected: true)]
    
    let expectedTabs = [SearchTab(name: "계열", count: 0),
                        SearchTab(name: "브랜드", count: 0),
                        SearchTab(name: "키워드", count: 1)]
    
    let expectedKeywords = [SearchKeyword(idx: 0, name: "키워드1", category: .keyword)]
    
    
    //When
    self.scheduler.scheduleAt(10) {
      self.viewModel.updateKeywords(keywords: keywords)
    }
    
    self.output.tabs
      .subscribe(tabObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(tabObserver.events, [.next(0, SearchTab.default),
                                        .next(10, expectedTabs)])
    
    let actualKeywords = self.viewModel.keywords
    XCTAssertEqual(expectedKeywords, actualKeywords)
  }
  
  // series, brand, keyword 업데이트 시 Done Button 카운트 업데이트
  func testTransform_updateProperties_updateSelectedCount() throws {
    
    // Given
    let selectedCountObserver = self.scheduler.createObserver(Int.self)
    
    let ingredients = [SearchKeyword(idx: 0, name: "가", category: .ingredient),
                       SearchKeyword(idx: 1, name: "나", category: .ingredient)]
    
    let brands = [SearchKeyword(idx: 0, name: "브랜드1", category: .brand),
                  SearchKeyword(idx: 1, name: "브랜드2", category: .brand),
                  SearchKeyword(idx: 2, name: "브랜드3", category: .brand)]
    
    let keywords = [SearchKeyword(idx: 0, name: "키워드1", category: .keyword)]
    
    //When
    self.scheduler.scheduleAt(10) {
      self.childInput.ingredientsDidUpdateEvent.accept(ingredients)
    }
    
    self.scheduler.scheduleAt(20) {
      self.childInput.brandsDidUpdateEvent.accept(brands)
    }
    
    self.scheduler.scheduleAt(30) {
      self.childInput.keywordsDidUpdateEvent.accept(keywords)
    }
    
    self.output.selectedCount
      .subscribe(selectedCountObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(selectedCountObserver.events, [.next(0, 0),
                                                  .next(10, 2),
                                                  .next(20, 5),
                                                  .next(30, 6)])
    
  }
  
  // Done 버튼 클릭시 종료
  func testTransform_clickDoneButton_finishFlow() throws {
    
    // Given
    let doneButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    let expected = 1
    
    //When
    doneButtonObservable
      .bind(to: self.input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let actual = (self.coordinator as! MockSearchFilterCoordinator).finishFlowCalledCount
    XCTAssertEqual(actual, expected)
    
  }
  
  // Close 버튼 클릭시 종료
  func testTransform_clickCloseButton_finishFlow() throws {
    
    // Given
    let closeButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    let expected = 1
    
    //When
    closeButtonObservable
      .bind(to: self.input.closeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let actual = (self.coordinator as! MockSearchFilterCoordinator).finishFlowCalledCount
    XCTAssertEqual(actual, expected)
    
  }
  
}
