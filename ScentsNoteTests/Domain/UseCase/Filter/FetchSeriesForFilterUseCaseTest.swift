//
//  FetchSeriesForFilterUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchSeriesForFilterUseCaseTest: XCTestCase {
  
  private var fetchSeriesForFilterUseCase: FetchSeriesForFilterUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchSeriesForFilterUseCase = DefaultFetchSeriesForFilterUseCase(filterRepository: FilterRepositoryMock())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchSeriesForFilterUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetch_success() throws {
    
    // Given
    let series = [FilterSeries(idx: 0, name: "가", ingredients: [FilterIngredient(idx: 0, name: "ㄱ", isSelected: false),
                                                                FilterIngredient(idx: 1, name: "ㄴ", isSelected: false),
                                                                FilterIngredient(idx: 2, name: "ㄷ", isSelected: false)]),
                  FilterSeries(idx: 1, name: "나", ingredients: [FilterIngredient(idx: 3, name: "ㄹ", isSelected: false),
                                                                FilterIngredient(idx: 4, name: "ㅁ", isSelected: false),
                                                                FilterIngredient(idx: 5, name: "ㅂ", isSelected: false)])]
    
    // When
    let seriesObserver = self.scheduler.createObserver([FilterSeries].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchSeriesForFilterUseCase.execute()
        .subscribe(seriesObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(seriesObserver.events, [.next(10, series)])
    
  }
}

