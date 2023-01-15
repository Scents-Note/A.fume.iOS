//
//  FetchPerfumeDetailUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class FetchPerfumeDetailUseCaseTest: XCTestCase {
  
  private var fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchPerfumeDetailUseCase = DefaultFetchPerfumeDetailUseCase(perfumeRepository: PerfumeRepositoryMock())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchPerfumeDetailUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetch_success() throws {
    
    // Given
    let perfumeDetail = PerfumeDetail(perfumeIdx: 0, name: "가", brandName: "ㄱ", story: "story", abundanceRate: "풍부", volumeAndPrice: ["90ml, 50,000원"], imageUrls: [], score: 5.0, seasonal: [], sillage: [], longevity: [], gender: [], isLiked: false, Keywords: [], noteType: 0, ingredients: [], reviewIdx: 0, similarPerfumes: [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false), Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false), Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false), Perfume(perfumeIdx: 3, brandName: "라", name: "ㄹ", imageUrl: "", keywordList: ["향기로움"], isLiked: false), Perfume(perfumeIdx: 4, brandName: "마", name: "ㅁ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)])
    
    // When
    let perfumeDetailObserver = self.scheduler.createObserver(PerfumeDetail.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchPerfumeDetailUseCase.execute(perfumeIdx: 0)
        .subscribe(perfumeDetailObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    XCTAssertEqual(perfumeDetailObserver.events, [.next(10, perfumeDetail)])
  }
  
}
