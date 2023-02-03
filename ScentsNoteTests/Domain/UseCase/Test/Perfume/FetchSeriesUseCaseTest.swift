//
//  FetchSeriesUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/14.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchSeriesUseCaseTest: XCTestCase {
  
  private var fetchSeriesUseCase: FetchSeriesUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchSeriesUseCase = DefaultFetchSeriesUseCase(perfumeRepository: MockPerfumeRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.fetchSeriesUseCase = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testExecute_fetchSurveySeries() throws {
    
    // Given
    let series = [SurveySeries(seriesIdx: 0, name: "가", imageUrl: ""),
                  SurveySeries(seriesIdx: 1, name: "나", imageUrl: ""),
                  SurveySeries(seriesIdx: 2, name: "다", imageUrl: ""),
                  SurveySeries(seriesIdx: 3, name: "라", imageUrl: "")]
    
    // When
    let surveysObserver = self.scheduler.createObserver([SurveySeries].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchSeriesUseCase.execute()
        .subscribe(surveysObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(surveysObserver.events, [.next(10, series)])
    
  }
}
