//
//  SearchFilterSeriesViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/25.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SearchFilterSeriesViewModelTest: XCTestCase {
  private var viewModel: SearchFilterSeriesViewModel!
  private var filterDelegate: FilterDelegate!
  private var fetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase!
  private var input: SearchFilterSeriesViewModel.Input!
  private var output: SearchFilterSeriesViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.filterDelegate = MockFilterDelegate()
    self.fetchSeriesForFilterUseCase = MockFetchSeriesForFilterUseCase()
    self.viewModel = SearchFilterSeriesViewModel(filterDelegate: self.filterDelegate,
                                                 fetchSeriesForFilterUseCase: self.fetchSeriesForFilterUseCase)
    
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.viewModel = nil
    self.filterDelegate = nil
    self.fetchSeriesForFilterUseCase = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  
  
  // series 데이터가 잘 Fetch 되었는지 확인
  func testFetchDatas_updateSeries() throws {
    
    // Given
    let seriesObserver = self.scheduler.createObserver([FilterSeriesDataSection.Model].self)
    let series = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                   FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                   FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                  
                  FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                  FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                  FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let expected = series.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    //When
    self.output.seriesDataSource
      .subscribe(seriesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(seriesObserver.events, [.next(0, expected)])
  }
  
  // ingredient Cell을 눌렀을때 seriesDataSource 업데이트
  func testTransform_clickIngredient_updateSeries() throws {
    
    // Given
    let ingredientObservable = self.scheduler.createColdObservable([.next(10, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false))),
                                                                    .next(20, (1, FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false)))])
    let seriesObserver = self.scheduler.createObserver([FilterSeriesDataSection.Model].self)
    
    let seriesAt0 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                      FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                      FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                     
                     FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                     FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                     FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let seriesAt10 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: true),
                                                                       FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                       FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                      
                      FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                      FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                      FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let seriesAt20 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: true),
                                                                       FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                       FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                      
                      FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: true),
                                                                      FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                      FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let expectedAt0 = seriesAt0.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt10 = seriesAt10.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt20 = seriesAt20.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    //When
    ingredientObservable
      .bind(to: self.input.ingredientDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.seriesDataSource
      .subscribe(seriesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(seriesObserver.events, [.next(0, expectedAt0),
                                           .next(10, expectedAt10),
                                           .next(20, expectedAt20)])
  }
  
  // ingredient Cell을 눌렀다 다시 눌렀을때 seriesDataSource 업데이트
  func testTransform_clickIngredientTwice_updateSeries() throws {
    
    // Given
    let ingredientObservable = self.scheduler.createColdObservable([.next(10, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false))),
                                                                    .next(20, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false)))])
    let seriesObserver = self.scheduler.createObserver([FilterSeriesDataSection.Model].self)
    
    let seriesAt0 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                      FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                      FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                     
                     FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                     FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                     FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let seriesAt10 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: true),
                                                                       FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                       FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                      
                      FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                      FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                      FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let seriesAt20 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                       FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                       FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                      
                      FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                      FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                      FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let expectedAt0 = seriesAt0.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt10 = seriesAt10.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt20 = seriesAt20.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    //When
    ingredientObservable
      .bind(to: self.input.ingredientDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.seriesDataSource
      .subscribe(seriesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(seriesObserver.events, [.next(0, expectedAt0),
                                           .next(10, expectedAt10),
                                           .next(20, expectedAt20)])
  }
  
  // ingredient Cell을 눌렀다 다시 눌렀을때 seriesDataSource 업데이트
  func testTransform_clickIngredientMoreThan5_updateSeries() throws {
    
    // Given
    let ingredientObservable = self.scheduler.createColdObservable([.next(10, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false))),
                                                                    .next(10, (0, FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false))),
                                                                    .next(10, (0, FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false))),
                                                                    .next(10, (1, FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false))),
                                                                    .next(10, (1, FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false))),
                                                                    .next(20, (1, FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)))])
    
    let seriesObserver = self.scheduler.createObserver([FilterSeriesDataSection.Model].self)
    
    let series = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: true),
                                                                       FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: true),
                                                                       FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: true)]),
                      
                      FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: true),
                                                                      FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: true),
                                                                      FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    
    let expected = series.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    //When
    ingredientObservable
      .bind(to: self.input.ingredientDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.seriesDataSource
      .subscribe(seriesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(seriesObserver.events.last, .next(20, expected))
  }
  
  // ingredient Cell을 눌렀을때 ingredients property 업데이트
  func testTransform_clickIngredient_updateIngredients() throws {
    
    // Given
    let ingredientObservable = self.scheduler.createColdObservable([.next(10, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false))),
                                                                    .next(20, (1, FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false)))])
    
    let expectedAt10 = [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false)]
    
    let expectedAt20 = [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                    FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false)]
    
    //When
    ingredientObservable
      .bind(to: self.input.ingredientDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actualAt10 = self.viewModel.ingredients
      XCTAssertEqual(actualAt10, expectedAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actualAt20 = self.viewModel.ingredients
      XCTAssertEqual(actualAt20, expectedAt20)
    }
  }
  
  // ingredient Cell을 눌렀을때 ingredients property 업데이트
  func testTransform_clickIngredientTwice_updateIngredients() throws {
    
    // Given
    let ingredientObservable = self.scheduler.createColdObservable([.next(10, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false))),
                                                                    .next(20, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false)))])
    
    let expectedAt10 = [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false)]
    
    let expectedAt20: [FilterIngredient] = []
    
    //When
    ingredientObservable
      .bind(to: self.input.ingredientDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actualAt10 = self.viewModel.ingredients
      XCTAssertEqual(actualAt10, expectedAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actualAt20 = self.viewModel.ingredients
      XCTAssertEqual(actualAt20, expectedAt20)
    }
  }
  
  // ingredient Cell을 눌렀을때 updateIngredient 함수 호출 여부
  func testUpdateIngredient_clickIngredient_called() throws {
    
    // Given
    let ingredientObservable = self.scheduler.createColdObservable([.next(10, (0, FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false))),
                                                                    .next(20, (1, FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false)))])
    
    let expectedAt10 = [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false)]
    
    let expectedAt20 = [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                        FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false)]
    
    //When
    ingredientObservable
      .bind(to: self.input.ingredientDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actualAt10 = (self.filterDelegate as! MockFilterDelegate).ingredientsUpdated
      XCTAssertEqual(actualAt10, expectedAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actualAt20 = (self.filterDelegate as! MockFilterDelegate).ingredientsUpdated
      XCTAssertEqual(actualAt20, expectedAt20)
    }
    
  }
  
  // series cell의 Header의 more을 눌렀을때 seriesDataSource 업데이트
  func testTransform_clickSeriesMore_updateSeries() throws {
    
    // Given
    let seriesMoreButtonObserver = self.scheduler.createColdObservable([.next(10, 0),
                                                                        .next(20, 1),
                                                                        .next(30, 0),])
    
    let seriesObserver = self.scheduler.createObserver([FilterSeriesDataSection.Model].self)
    
    let seriesAt0 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                      FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                      FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                     
                     FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                     FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                     FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
       
    
    let seriesAt10 = [FilterSeries(idx: 0, name: "시트러스", ingredients: []),
                      FilterSeries(idx: 1, name: "플라워", ingredients: [FilterIngredient(id: "3", idx: 3, name: "장미", isSelected: false),
                                                                      FilterIngredient(id: "4", idx: 4, name: "오리스", isSelected: false),
                                                                      FilterIngredient(id: "5", idx: 5, name: "바이올렛", isSelected: false)])]
    
    let seriesAt20 = [FilterSeries(idx: 0, name: "시트러스", ingredients: []),
                      FilterSeries(idx: 1, name: "플라워", ingredients: [])]
    
    let seriesAt30 = [FilterSeries(idx: 0, name: "시트러스", ingredients: [FilterIngredient(id: "0", idx: 0, name: "오렌지", isSelected: false),
                                                                       FilterIngredient(id: "1", idx: 1, name: "라임", isSelected: false),
                                                                       FilterIngredient(id: "2", idx: 2, name: "딸기", isSelected: false)]),
                      FilterSeries(idx: 1, name: "플라워", ingredients: [])]
    
    
    let expectedAt0 = seriesAt0.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt10 = seriesAt10.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt20 = seriesAt20.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    let expectedAt30 = seriesAt30.map { series in
      let items = series.ingredients.map { FilterSeriesDataSection.Item(ingredient: $0) }
      return FilterSeriesDataSection.Model(model: series.name, items: items)
    }
    
    //When
    seriesMoreButtonObserver
      .bind(to: self.input.seiresMoreButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.seriesDataSource
      .subscribe(seriesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(seriesObserver.events, [.next(0, expectedAt0),
                                           .next(10, expectedAt10),
                                           .next(20, expectedAt20),
                                           .next(30, expectedAt30)])
  }
}
