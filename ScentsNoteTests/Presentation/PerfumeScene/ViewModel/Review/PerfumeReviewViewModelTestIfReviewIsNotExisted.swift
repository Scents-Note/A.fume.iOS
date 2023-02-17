//
//  PerfumeReviewViewModelTestIfReviewIsNotExisted.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/29.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class PerfumeReviewViewModelTestIfReviewIsNotExisted: XCTestCase {
  private var coordinator: PerfumeReviewCoordinator!
  private var addReviewUseCase: AddReviewUseCase!
  private var fetchKeywordsUseCase: FetchKeywordsUseCase!
  private var viewModel: PerfumeReviewViewModel!
  private var input: PerfumeReviewViewModel.Input!
  private var bottomSheetInput: PerfumeReviewViewModel.BottomSheetInput!
  private var output: PerfumeReviewViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeReviewCoordinator()
    self.addReviewUseCase = MockAddReviewUseCase()
    self.fetchKeywordsUseCase = MockFetchKeywordsUseCase()
    let perfumeDetail = PerfumeDetail(perfumeIdx: 10,
                                      name: "향수1",
                                      brandName: "브랜드",
                                      story: "스토리~~",
                                      abundanceRate: "~~",
                                      volumeAndPrice: ["100ml/50,000원"],
                                      imageUrls: [],
                                      score: 5.0,
                                      seasonal: [Seasonal(season: "여름", percent: 100, color: .SNDarkBeige1, isAccent: true)],
                                      sillage: [],
                                      longevity: [],
                                      gender: [],
                                      isLiked: false,
                                      Keywords: [],
                                      noteType: 0,
                                      ingredients: [],
                                      reviewIdx: 0,
                                      similarPerfumes: [Perfume(perfumeIdx: 0, brandName: "브랜드", name: "향수2", imageUrl: "", keywordList: [], isLiked: false),
                                                        Perfume(perfumeIdx: 1, brandName: "브랜드2", name: "향수3", imageUrl: "", keywordList: ["차가운"], isLiked: false)])
    self.viewModel = PerfumeReviewViewModel(coordinator: self.coordinator,
                                             perfumeDetail: perfumeDetail,
                                             addReviewUseCase: self.addReviewUseCase,
                                             fetchKeywordsUseCase: self.fetchKeywordsUseCase)
    
    self.input = self.viewModel.input
    self.bottomSheetInput = self.viewModel.bottomSheetInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.addReviewUseCase = nil
    self.fetchKeywordsUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.bottomSheetInput = nil
    self.output = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // 키워드 Fetch
  func testFetchDatas_fetchKeywords() throws {
    
    // Given
    let expected = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 1, name: "키워드1", isSelected: false),
                    Keyword(idx: 2, name: "키워드2", isSelected: false),
                    Keyword(idx: 3, name: "키워드3", isSelected: false),
                    Keyword(idx: 4, name: "키워드4", isSelected: false),
                    Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    // Then
    let actual = self.viewModel.keywords
    XCTAssertEqual(actual, expected)
  }
  
  // StarView와 Note 업데이트 시에 Output의 CanDone 업데이트
  func testTransform_updateStarViewAndNote_updateCanDone() throws {
    
    // Given
    let starObservable = self.scheduler.createHotObservable([.next(10, 5.0)])
    let noteObservable = self.scheduler.createHotObservable([.next(20, "향수가 좋아요"),
                                                             .next(30, "")])
    
    let observer = self.scheduler.createObserver(Bool.self)
    
    let expectedAt0 = false
    let expectedAt10 = true
    let expectedAt20 = false
    
    // When
    starObservable
      .bind(to: self.input.starViewDidUpdateEvent)
      .disposed(by: self.disposeBag)
    
    noteObservable
      .bind(to: self.input.noteTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.canDone
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [.next(0, expectedAt0),
                                     .next(20, expectedAt10),
                                     .next(30, expectedAt20)])
  }
  
  // Done 버튼 클릭시 addReview
  func testTransform_clickDoneButton_AddReview() throws {
    
    // Given
    self.viewModel.newReviewDetail = ReviewDetail(score: 5.0,
                                                  sillage: -1,
                                                  longevity: -1,
                                                  seasonal: [],
                                                  gender: -1,
                                                  content: "향수가 좋아요",
                                                  reviewIdx: 0,
                                                  perfume: nil,
                                                  keywords: [],
                                                  brand: nil,
                                                  isShared: false)
    
    let doneObservable = self.scheduler.createHotObservable([.next(10, ())])
        
    let expectedAddReviewCalledCount = 1
    let expectedFinishCalledCount = 1
    // When
    doneObservable
      .bind(to: self.input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualAddReviewCalledCount = (self.addReviewUseCase as! MockAddReviewUseCase).excuteCallCount
    XCTAssertEqual(actualAddReviewCalledCount, expectedAddReviewCalledCount)
    
    let actualFinishCalledCount = (self.coordinator as! MockPerfumeReviewCoordinator).finishFlowCalledCount
    XCTAssertEqual(actualFinishCalledCount, expectedFinishCalledCount)
  }
  
  // Done 버튼 클릭시 addReview
  func testTransform_clickDoneButton_ifIsSharedAndNotOnCondition_showToast() throws {
    
    // Given
    self.viewModel.newReviewDetail = ReviewDetail(score: 5.0,
                                                  sillage: 2,
                                                  longevity: 4,
                                                  seasonal: [],
                                                  gender: -1,
                                                  content: "향수가 좋아요",
                                                  reviewIdx: 0,
                                                  perfume: nil,
                                                  keywords: [],
                                                  brand: nil,
                                                  isShared: true)
    
    let doneObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver(Void.self)

    // When
    doneObservable
      .bind(to: self.input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.showToast
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events.map(VoidRecord.init),  [.next(10, ())].map(VoidRecord.init))
  }
}
