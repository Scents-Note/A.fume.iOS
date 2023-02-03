//
//  SearchFilterBrandViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SearchFilterBrandViewModelTest: XCTestCase {
  private var viewModel: SearchFilterBrandViewModel!
  private var filterDelegate: FilterDelegate!
  private var fetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase!
  private var input: SearchFilterBrandViewModel.Input!
  private var output: SearchFilterBrandViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.filterDelegate = MockFilterDelegate()
    self.fetchBrandsForFilterUseCase = MockFetchBrandsForFilterUseCase()
    self.viewModel = SearchFilterBrandViewModel(filterDelegate: self.filterDelegate,
                                                fetchBrandsForFilterUseCase: self.fetchBrandsForFilterUseCase)
    
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.viewModel = nil
    self.filterDelegate = nil
    self.fetchBrandsForFilterUseCase = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  // brandInfos 데이터가 잘 Fetch 되어 Output이 잘 들어갔는지 확인
  // 1. 브랜드 이니셜, 2. 브랜드 처음 선택된 셀 3. 선택된 브랜드 셀의 브랜드 리스트
  func testFetchDatas_updateBrands_success() throws {
    
    // Given
    let brandInitialObserver = self.scheduler.createObserver([FilterBrandInitial].self)
    let brandObserver = self.scheduler.createObserver([FilterBrand].self)
    
    let expectedInitials = [FilterBrandInitial(text: "ㄱ", isSelected: true),
                            FilterBrandInitial(text: "ㄴ", isSelected: false),
                            FilterBrandInitial(text: "ㄷ", isSelected: false)]
    
    let expectedBrands = [FilterBrand(idx: 0, name: "브랜드1", isSelected: false),
                          FilterBrand(idx: 1, name: "브랜드2", isSelected: false),
                          FilterBrand(idx: 2, name: "브랜드3", isSelected: false)]
    
    //When
    self.output.brandInitials
      .subscribe(brandInitialObserver)
      .disposed(by: self.disposeBag)
    
    self.output.brands
      .subscribe(brandObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(brandInitialObserver.events.last, .next(0, expectedInitials))
    XCTAssertEqual(brandObserver.events.last, .next(0, expectedBrands))
  }
  
  // brandInitial Cell 클릭시 Initials 와 brands 업데이트
  func testTransform_clickBrandInitial_updateInitialsAndBrands() throws {
    
    // Given
    let brandInitialObservable = self.scheduler.createHotObservable([.next(10, 1)])
    let brandInitialObserver = self.scheduler.createObserver([FilterBrandInitial].self)
    let brandObserver = self.scheduler.createObserver([FilterBrand].self)
    
    let expectedInitials = [FilterBrandInitial(text: "ㄱ", isSelected: false),
                            FilterBrandInitial(text: "ㄴ", isSelected: true),
                            FilterBrandInitial(text: "ㄷ", isSelected: false)]
    
    let expectedBrands = [FilterBrand(idx: 3, name: "브랜드4", isSelected: false),
                          FilterBrand(idx: 4, name: "브랜드5", isSelected: false),
                          FilterBrand(idx: 5, name: "브랜드6", isSelected: false)]
    
    //When
    brandInitialObservable
      .bind(to: self.input.brandInitialCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.brandInitials
      .subscribe(brandInitialObserver)
      .disposed(by: self.disposeBag)
    
    self.output.brands
      .subscribe(brandObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(brandInitialObserver.events.last, .next(10, expectedInitials))
    XCTAssertEqual(brandObserver.events.last, .next(10, expectedBrands))
  }
  
  // brand Cell 클릭시 Initials 와 brands 업데이트
  func testTransform_clickBrand_updateBrands() throws {
    
    // Given
    let brandObservable = self.scheduler.createHotObservable([.next(10, 1)])
    let brandObserver = self.scheduler.createObserver([FilterBrand].self)
    
    let expected = [FilterBrand(idx: 0, name: "브랜드1", isSelected: false),
                    FilterBrand(idx: 1, name: "브랜드2", isSelected: true),
                    FilterBrand(idx: 2, name: "브랜드3", isSelected: false)]
    
    let expectedOnField = [FilterBrand(idx: 1, name: "브랜드2", isSelected: false)]
    
    //When
    brandObservable
      .bind(to: self.input.brandCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.brands
      .subscribe(brandObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(brandObserver.events.last, .next(10, expected))
    
    let actual = self.viewModel.brands
    XCTAssertEqual(actual, expectedOnField)
  }
  
  // 선택된 brand Cell 클릭시 해당 Brand isSelected false로 업데이트
  func testTransform_clickBrandSelected_updateBrands() throws {
    
    // Given
    let brandObservable = self.scheduler.createHotObservable([.next(10, 1),
                                                              .next(20, 1)])
    
    let brandObserver = self.scheduler.createObserver([FilterBrand].self)
    
    let expected = [FilterBrand(idx: 0, name: "브랜드1", isSelected: false),
                    FilterBrand(idx: 1, name: "브랜드2", isSelected: false),
                    FilterBrand(idx: 2, name: "브랜드3", isSelected: false)]
    
    //When
    brandObservable
      .bind(to: self.input.brandCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.brands
      .subscribe(brandObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(brandObserver.events.last, .next(20, expected))
  }
  
  // 5개 이상의 brand를 클릭했을시에 brands 업데이트가 안됨
  func testTransform_clickBrandMoreThan5_updateBrands() throws {
    
    // Given
    let brandObservable = self.scheduler.createHotObservable([.next(10, 0),
                                                              .next(10, 1),
                                                              .next(10, 2),
                                                              .next(20, 0),
                                                              .next(20, 1),
                                                              .next(30, 2)])
    
    let brandInitialObservable = self.scheduler.createHotObservable([.next(15, 1)])
    
    let brandObserver = self.scheduler.createObserver([FilterBrand].self)
    
    let expected = [FilterBrand(idx: 3, name: "브랜드4", isSelected: true),
                    FilterBrand(idx: 4, name: "브랜드5", isSelected: true),
                    FilterBrand(idx: 5, name: "브랜드6", isSelected: false)]
    
    let expectedOnField = [FilterBrand(idx: 0, name: "브랜드1", isSelected: false),
                           FilterBrand(idx: 1, name: "브랜드2", isSelected: false),
                           FilterBrand(idx: 2, name: "브랜드3", isSelected: false),
                           FilterBrand(idx: 3, name: "브랜드4", isSelected: false),
                           FilterBrand(idx: 4, name: "브랜드5", isSelected: false)]
    //When
    brandInitialObservable
      .bind(to: self.input.brandInitialCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    brandObservable
      .bind(to: self.input.brandCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.brands
      .subscribe(brandObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(brandObserver.events.last, .next(30, expected))
    
    let actual = self.viewModel.brands
    XCTAssertEqual(actual, expectedOnField)
  }
  
  // ingredient Cell을 눌렀을때 filterDelegate의 updateIngredient 함수 호출 여부
  func testUpdateIngredient_clickBrand_updateBrandsInFilterDelegate() throws {
    
    // Given
    let brandObservable = self.scheduler.createHotObservable([.next(10, 0),
                                                              .next(20, 1)])
    
    let expectedAt10 = [FilterBrand(idx: 0, name: "브랜드1", isSelected: false)]
    
    let expectedAt20 = [FilterBrand(idx: 0, name: "브랜드1", isSelected: false),
                        FilterBrand(idx: 1, name: "브랜드2", isSelected: false)]
    
    //When
    brandObservable
      .bind(to: self.input.brandCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actualAt10 = (self.filterDelegate as! MockFilterDelegate).brandsUpdated
      XCTAssertEqual(actualAt10, expectedAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actualAt20 = (self.filterDelegate as! MockFilterDelegate).brandsUpdated
      XCTAssertEqual(actualAt20, expectedAt20)
    }
    
  }
  
}
