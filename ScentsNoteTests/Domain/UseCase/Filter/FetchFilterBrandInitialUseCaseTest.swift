//
//  FetchFilterBrandInitialUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchFilterBrandInitialUseCaseTest: XCTestCase {
  
  private var fetchFilterBrandInitialUseCase: FetchFilterBrandInitialUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchFilterBrandInitialUseCase = DefaultFetchFilterBrandInitialUseCase(filterRepository: FilterRepositoryMock())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchFilterBrandInitialUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetch_success() throws {
    
    // Given
    let brands = [FilterBrandInitial(text: "ㄱ", isSelected: false),
                  FilterBrandInitial(text: "ㄴ", isSelected: false)]
    
    // When
    let brandsObserver = self.scheduler.createObserver([FilterBrandInitial].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchFilterBrandInitialUseCase.execute()
        .subscribe(brandsObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(brandsObserver.events, [.next(10, brands)])
    
  }
}

