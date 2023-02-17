//
//  FetchBrandsForFilterUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class FetchBrandsForFilterUseCaseTest: XCTestCase {
  
  private var fetchBrandsForFilterUseCase: FetchBrandsForFilterUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchBrandsForFilterUseCase = DefaultFetchBrandsForFilterUseCase(filterRepository: MockFilterRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchBrandsForFilterUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchBrandsForFilter() throws {
    
    // Given
    let brands = [FilterBrandInfo(initial: "ㄱ", brands: [FilterBrand(idx: 0, name: "가", isSelected: false),
                                                         FilterBrand(idx: 1, name: "나", isSelected: false)]),
                  FilterBrandInfo(initial: "ㄴ", brands: [FilterBrand(idx: 2, name: "다", isSelected: false),
                                                         FilterBrand(idx: 3, name: "라", isSelected: false)])]
    
    // When
    let brandsObserver = self.scheduler.createObserver([FilterBrandInfo].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchBrandsForFilterUseCase.execute()
        .subscribe(brandsObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(brandsObserver.events, [.next(10, brands)])
    
  }
}

