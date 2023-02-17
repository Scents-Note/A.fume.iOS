//
//  FetchPerfumeSearchedUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class FetchPerfumeSearchedUseCaseTest: XCTestCase {
  
  private var fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchPerfumeSearchedUseCase = DefaultFetchPerfumeSearchedUseCase(perfumeRepository: MockPerfumeRepository())
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchPerfumeSearchedUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchPerfumeSearched() throws {
    
    // Given
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 3, brandName: "라", name: "ㄹ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "마", name: "ㅁ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "바", name: "ㅂ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 6, brandName: "사", name: "ㅅ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 7, brandName: "아", name: "ㅇ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 8, brandName: "자", name: "ㅈ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 9, brandName: "차", name: "ㅊ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 10, brandName: "카", name: "ㅋ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 11, brandName: "티", name: "ㅌ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let perfumeSearch = PerfumeSearch()
    
    // When
    let perfumesObserver = self.scheduler.createObserver([Perfume].self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchPerfumeSearchedUseCase.execute(perfumeSearch: perfumeSearch)
        .subscribe(perfumesObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)
    
    // Then
    self.scheduler.start()
    
    XCTAssertEqual(perfumesObserver.events, [.next(10, perfumes)])
  }
}

