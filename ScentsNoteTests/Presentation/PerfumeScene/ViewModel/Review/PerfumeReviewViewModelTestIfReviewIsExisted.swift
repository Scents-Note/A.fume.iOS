//
//  PerfumeReviewViewModelTestIfReviewIsExisted.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/29.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class PerfumeReviewViewModelTestIfReviewIsExisted: XCTestCase {
  private var coordinator: PerfumeReviewCoordinator!
  private var fetchReviewDetailUseCase: FetchReviewDetailUseCase!
  private var updateReviewUseCase: UpdateReviewUseCase!
  private var deleteReviewUseCase: DeleteReviewUseCase!
  private var fetchKeywordsUseCase: FetchKeywordsUseCase!
  private var viewModel: PerfumeReviewViewModel!
  private var input: PerfumeReviewViewModel.Input!
  private var bottomSheetInput: PerfumeReviewViewModel.BottomSheetInput!
  private var output: PerfumeReviewViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeReviewCoordinator()
    self.fetchReviewDetailUseCase = MockFetchReviewDetailUseCase()
    self.updateReviewUseCase = MockUpdateReviewUseCase()
    self.deleteReviewUseCase = MockDeleteReviewUseCase()
    self.fetchKeywordsUseCase = MockFetchKeywordsUseCase()
    self.viewModel = PerfumeReviewViewModel(coordinator: self.coordinator,
                                            reviewIdx: 10,
                                            fetchReviewDetailUseCase: self.fetchReviewDetailUseCase,
                                            updateReviewUseCase: self.updateReviewUseCase,
                                            fetchKeywordsUseCase: self.fetchKeywordsUseCase,
                                            deleteReviewUseCase: self.deleteReviewUseCase)
    
    self.input = self.viewModel.input
    self.bottomSheetInput = self.viewModel.bottomSheetInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchReviewDetailUseCase = nil
    self.updateReviewUseCase = nil
    self.deleteReviewUseCase = nil
    self.fetchKeywordsUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.bottomSheetInput = nil
    self.output = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // 키워드와 ReviewDetail Fetch
  func testFetchDatas_fetchReviewAndKeywords() throws {
    
    // Given
    let expectedPerfumeIdx = 5
    let expectedReviewDetail = ReviewDetail(score: 4.5,
                                            sillage: 2,
                                            longevity: 0,
                                            seasonal: ["여름", "겨울"],
                                            gender: 2,
                                            content: "향수가 좋아요",
                                            reviewIdx: 10,
                                            perfume: PerfumeInReviewDetail(idx: 5, name: "향수", imageUrl: ""),
                                            keywords: [Keyword(idx: 0, name: "키워드0"), Keyword(idx: 1, name: "키워드1")],
                                            brand: BrandInReviewDetail(idx: 24, name: "조 말론"),
                                            isShared: true)
    
    let expectedKeywords = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                            Keyword(idx: 1, name: "키워드1", isSelected: true),
                            Keyword(idx: 2, name: "키워드2", isSelected: false),
                            Keyword(idx: 3, name: "키워드3", isSelected: false),
                            Keyword(idx: 4, name: "키워드4", isSelected: false),
                            Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    
    // Then
    let actualPerfumeIdx = self.viewModel.perfumeIdx
    XCTAssertEqual(actualPerfumeIdx, expectedPerfumeIdx)
    
    let actualOldReviewDetail = self.viewModel.oldReviewDetail
    XCTAssertEqual(actualOldReviewDetail, expectedReviewDetail)
    
    let actualNewReviewDetail = self.viewModel.newReviewDetail
    XCTAssertEqual(actualNewReviewDetail, expectedReviewDetail)
    
    let actualKeywords = self.viewModel.keywords
    XCTAssertEqual(actualKeywords, expectedKeywords)
  }
  
  // output의 ReviewDetail의 업데이트
  func testSetReviewDetail_updateReviewDetail() throws {
    
    // Given
    let observer = self.scheduler.createObserver(ReviewDetail?.self)
    let expected = ReviewDetail(score: 4.5,
                                sillage: 2,
                                longevity: 0,
                                seasonal: ["여름", "겨울"],
                                gender: 2,
                                content: "향수가 좋아요",
                                reviewIdx: 10,
                                perfume: PerfumeInReviewDetail(idx: 5, name: "향수", imageUrl: ""),
                                keywords: [Keyword(idx: 0, name: "키워드0"), Keyword(idx: 1, name: "키워드1")],
                                brand: BrandInReviewDetail(idx: 24, name: "조 말론"),
                                isShared: true)
    
    // When
    self.output.reviewDetail
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // output의 Keyword의 업데이트
  func testSetReviewDetail_updateKeywords() throws {
    
    // Given
    let observer = self.scheduler.createObserver([Keyword].self)
    let expected = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                    Keyword(idx: 1, name: "키워드1", isSelected: false)]
    
    // When
    self.output.keywords
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // output의 longevities의 업데이트
  func testSetReviewDetail_updateLongevities() throws {
    
    // Given
    let observer = self.scheduler.createObserver([Longevity].self)
    let expected = [Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: 20, isAccent: true, isEmpty: false),
                    Longevity(longevity: "약함", duration: "1~3시간", percent: 20, isAccent: false, isEmpty: false),
                    Longevity(longevity: "보통", duration: "3~5시간", percent: 20, isAccent: false, isEmpty: false),
                    Longevity(longevity: "강함", duration: "5~7시간", percent: 20, isAccent: false, isEmpty: false),
                    Longevity(longevity: "매우 강함", duration: "7시간", percent: 20, isAccent: false, isEmpty: false)]
    
    // When
    self.output.longevities
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // output의 genders의 업데이트
  func testSetReviewDetail_updateGenders() throws {
    
    // Given
    let observer = self.scheduler.createObserver([Gender].self)
    let expected = [Gender(gender: "남성",
                           percent: 33,
                           color: .clear,
                           isAccent: false),
                    Gender(gender: "",
                           percent: 0,
                           color: .clear,
                           isAccent: false),
                    Gender(gender: "중성",
                           percent: 33,
                           color: .clear,
                           isAccent: false),
                    Gender(gender: "",
                           percent: 0,
                           color: .clear,
                           isAccent: false),
                    Gender(gender: "여성",
                           percent: 33,
                           color: .clear,
                           isAccent: true)]
    
    // When
    self.output.genders
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // output의 Seasonals의 업데이트
  func testSetReviewDetail_updateSeasonals() throws {
    
    // Given
    let observer = self.scheduler.createObserver([Seasonal].self)
    let expected = [Seasonal(season: "봄", percent: 25, color: .clear, isAccent: false),
                    Seasonal(season: "여름", percent: 25, color: .clear, isAccent: true),
                    Seasonal(season: "가을", percent: 25, color: .clear, isAccent: false),
                    Seasonal(season: "겨울", percent: 25, color: .clear, isAccent: true)]
    
    
    // When
    self.output.seasonals
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // output의 Sillages의 업데이트
  func testSetReviewDetail_updateSillages() throws {
    
    // Given
    let observer = self.scheduler.createObserver([Sillage].self)
    let expected = [Sillage(sillage: "가벼움", percent: 20, isAccent: false),
                    Sillage(sillage: "", percent: 20, isAccent: false),
                    Sillage(sillage: "보통", percent: 20, isAccent: false),
                    Sillage(sillage: "", percent: 20, isAccent: false),
                    Sillage(sillage: "무거움", percent: 20, isAccent: true)]
    
    // When
    self.output.sillages
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // output의 IsShared의 업데이트
  func testSetReviewDetail_updateIsShared() throws {
    
    // Given
    let observer = self.scheduler.createObserver(Bool.self)
    let expected = true
    
    // When
    self.output.isShared
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    //Then
    XCTAssertEqual(observer.events.last!, .next(0, expected))
  }
  
  // 이미지 클릭시 PerfumeDetail이 기존에 존재하지 않았다면 PerfumeDetail 실행 및 현재 VC는 pop
  func testTransform_clickImageContainer_ifNotPerfumeDetailPushed_runPerfumeDetailAndPop() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver(Void.self)
    
    // When
    observable
      .bind(to: self.input.perfumeDetailViewDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.pop
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(observer.events.map(VoidRecord.init), [.next(10, ())].map(VoidRecord.init))
  }
  
  // starView 업데이트시 newReviewDetail과 output canUpdate 업데이트
  func testTransform_updateStarView_updateReviewDetailAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 4.0),
                                                         .next(20, 4.5)])
    
    let observer = self.scheduler.createObserver(Bool.self)
    
    let expectedNewScoreAt10 = 4.0
    let expectedNewScoreAt20 = 4.5
    
    let expectedCanUpdateAt10 = true
    let expectedCanUpdateAt20 = false
    
    // When
    observable
      .bind(to: self.input.starViewDidUpdateEvent)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actual = self.viewModel.newReviewDetail.score
      XCTAssertEqual(actual, expectedNewScoreAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actual = self.viewModel.newReviewDetail.score
      XCTAssertEqual(actual, expectedNewScoreAt20)
    }
    
    XCTAssertEqual(observer.events, [.next(0, false),
                                     .next(10, expectedCanUpdateAt10),
                                     .next(20, expectedCanUpdateAt20)])
    
  }
  
  // starView 업데이트시 newReviewDetail과 output canUpdate 업데이트
  func testTransform_editNote_updateReviewDetailAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, "향수가 좋아요!!"),
                                                         .next(20, ""),
                                                         .next(30, "냄새가 좋아요"),
                                                         .next(40, "향수가 좋아요")])
    
    let observer = self.scheduler.createObserver(Bool.self)
    
    let expectedContentAt10 = "향수가 좋아요!!"
    let expectedContentAt20 = ""
    let expectedContentAt30 = "냄새가 좋아요"
    let expectedContentAt40 = "향수가 좋아요"
    
    let expectedCanUpdateAt10 = true
    let expectedCanUpdateAt20 = false
    let expectedCanUpdateAt30 = true
    let expectedCanUpdateAt40 = false
    
    // When
    observable
      .bind(to: self.input.noteTextFieldDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actual = self.viewModel.newReviewDetail.content
      XCTAssertEqual(actual, expectedContentAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      let actual = self.viewModel.newReviewDetail.content
      XCTAssertEqual(actual, expectedContentAt20)
    }
    
    self.scheduler.scheduleAt(30) {
      let actual = self.viewModel.newReviewDetail.content
      XCTAssertEqual(actual, expectedContentAt30)
    }
    
    self.scheduler.scheduleAt(40) {
      let actual = self.viewModel.newReviewDetail.content
      XCTAssertEqual(actual, expectedContentAt40)
    }
    
    XCTAssertEqual(observer.events, [.next(0, false),
                                     .next(10, expectedCanUpdateAt10),
                                     .next(20, expectedCanUpdateAt20),
                                     .next(30, expectedCanUpdateAt30),
                                     .next(40, expectedCanUpdateAt40)])
    
  }
  
  // keywordAddButton 클릭시 현재 Keyword를 가지고 BottomSheet 보여주기
  func testTransform_clickKeywordAddButton_showBottomSheet() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expectedKeywords = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                            Keyword(idx: 1, name: "키워드1", isSelected: true),
                            Keyword(idx: 2, name: "키워드2", isSelected: false),
                            Keyword(idx: 3, name: "키워드3", isSelected: false),
                            Keyword(idx: 4, name: "키워드4", isSelected: false),
                            Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let expectedCalledCount = 1
    
    // When
    observable
      .bind(to: self.input.keywordAddButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let actualKeywords = (self.coordinator as! MockPerfumeReviewCoordinator).keywords
    XCTAssertEqual(actualKeywords, expectedKeywords)
    
    let actualCalledCount = (self.coordinator as! MockPerfumeReviewCoordinator).showKeywordBottomSheetViewControllerCalledCount
    XCTAssertEqual(actualCalledCount, expectedCalledCount)
  }
  
  // longevity Cell 클릭시 output의 Longevities & canUpdate 업데이트
  func testTransform_clickLongevity_updateLongevitiesAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2),
                                                         .next(20, 0)])
    
    let longevityObserver = self.scheduler.createObserver([Longevity].self)
    let canUpdateObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedLongevitiesAt10 = [Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: 20, isAccent: false, isEmpty: false),
                                   Longevity(longevity: "약함", duration: "1~3시간", percent: 20, isAccent: false, isEmpty: false),
                                   Longevity(longevity: "보통", duration: "3~5시간", percent: 20, isAccent: true, isEmpty: false),
                                   Longevity(longevity: "강함", duration: "5~7시간", percent: 20, isAccent: false, isEmpty: false),
                                   Longevity(longevity: "매우 강함", duration: "7시간", percent: 20, isAccent: false, isEmpty: false)]
    let expectedLongevitiesAt20 = [Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: 20, isAccent: true, isEmpty: false),
                                   Longevity(longevity: "약함", duration: "1~3시간", percent: 20, isAccent: false, isEmpty: false),
                                   Longevity(longevity: "보통", duration: "3~5시간", percent: 20, isAccent: false, isEmpty: false),
                                   Longevity(longevity: "강함", duration: "5~7시간", percent: 20, isAccent: false, isEmpty: false),
                                   Longevity(longevity: "매우 강함", duration: "7시간", percent: 20, isAccent: false, isEmpty: false)]
    
    let expectedCanUpateAt10 = true
    let expectedCanUpateAt20 = false
    
    // When
    observable
      .bind(to: self.input.longevityCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.longevities
      .subscribe(longevityObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(canUpdateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(longevityObserver.events, [.next(0, expectedLongevitiesAt20),
                                              .next(10, expectedLongevitiesAt10),
                                              .next(20, expectedLongevitiesAt20)])
    
    XCTAssertEqual(canUpdateObserver.events, [.next(0, false),
                                              .next(10, expectedCanUpateAt10),
                                              .next(20, expectedCanUpateAt20)])
  }
  
  // sillage Cell 클릭시 output의 sillages & canUpdate  업데이트
  func testTransform_clickSillage_updateSillagesAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2),
                                                         .next(20, 4),
                                                         .next(30, 1)])
    
    let sillagesObserver = self.scheduler.createObserver([Sillage].self)
    let canUpdateObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedSillagesAt10 = [Sillage(sillage: "가벼움", percent: 20, isAccent: false),
                                Sillage(sillage: "", percent: 20, isAccent: false),
                                Sillage(sillage: "보통", percent: 20, isAccent: true),
                                Sillage(sillage: "", percent: 20, isAccent: false),
                                Sillage(sillage: "무거움", percent: 20, isAccent: false)]
    
    let expectedSillagesAt20 = [Sillage(sillage: "가벼움", percent: 20, isAccent: false),
                                Sillage(sillage: "", percent: 20, isAccent: false),
                                Sillage(sillage: "보통", percent: 20, isAccent: false),
                                Sillage(sillage: "", percent: 20, isAccent: false),
                                Sillage(sillage: "무거움", percent: 20, isAccent: true)]
    
    let expectedCanUpateAt10 = true
    let expectedCanUpateAt20 = false
    
    // When
    observable
      .bind(to: self.input.sillageCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.sillages
      .subscribe(sillagesObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(canUpdateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(sillagesObserver.events, [.next(0, expectedSillagesAt20),
                                             .next(10, expectedSillagesAt10),
                                             .next(20, expectedSillagesAt20)])
    
    XCTAssertEqual(canUpdateObserver.events, [.next(0, false),
                                              .next(10, expectedCanUpateAt10),
                                              .next(20, expectedCanUpateAt20)])
  }
  
  // seasonal Cell 클릭시 output의 seasonals & canUpdate 업데이트
  func testTransform_clickSeasonal_updateSeasonalsAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 1),
                                                         .next(20, 1)])
    
    let seasonalObserver = self.scheduler.createObserver([Seasonal].self)
    let canUpdateObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedSeasonalsAt10 = [Seasonal(season: "봄", percent: 25, color: .clear, isAccent: false),
                                 Seasonal(season: "여름", percent: 25, color: .clear, isAccent: false),
                                 Seasonal(season: "가을", percent: 25, color: .clear, isAccent: false),
                                 Seasonal(season: "겨울", percent: 25, color: .clear, isAccent: true)]
    
    let expectedSeasonalsAt20 = [Seasonal(season: "봄", percent: 25, color: .clear, isAccent: false),
                                 Seasonal(season: "여름", percent: 25, color: .clear, isAccent: true),
                                 Seasonal(season: "가을", percent: 25, color: .clear, isAccent: false),
                                 Seasonal(season: "겨울", percent: 25, color: .clear, isAccent: true)]
    
    let expectedCanUpateAt10 = true
    let expectedCanUpateAt20 = false
    
    // When
    observable
      .bind(to: self.input.seasonalCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.seasonals
      .subscribe(seasonalObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(canUpdateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(seasonalObserver.events, [.next(0, expectedSeasonalsAt20),
                                             .next(10, expectedSeasonalsAt10),
                                             .next(20, expectedSeasonalsAt20)])
    
    XCTAssertEqual(canUpdateObserver.events, [.next(0, false),
                                              .next(10, expectedCanUpateAt10),
                                              .next(20, expectedCanUpateAt20)])
  }
  
  // gender Cell 클릭시 output의 genders & canUpdate 업데이트
  func testTransform_clickGender_updateGendersAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2),
                                                         .next(20, 4),
                                                         .next(30, 3)])
    
    let gendersObserver = self.scheduler.createObserver([Gender].self)
    let canUpdateObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedGendersAt10 = [Gender(gender: "남성",
                                      percent: 33,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "",
                                      percent: 0,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "중성",
                                      percent: 33,
                                      color: .clear,
                                      isAccent: true),
                               Gender(gender: "",
                                      percent: 0,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "여성",
                                      percent: 33,
                                      color: .clear,
                                      isAccent: false)]
    
    let expectedGendersAt20 = [Gender(gender: "남성",
                                      percent: 33,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "",
                                      percent: 0,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "중성",
                                      percent: 33,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "",
                                      percent: 0,
                                      color: .clear,
                                      isAccent: false),
                               Gender(gender: "여성",
                                      percent: 33,
                                      color: .clear,
                                      isAccent: true)]
    
    let expectedCanUpateAt10 = true
    let expectedCanUpateAt20 = false
    
    // When
    observable
      .bind(to: self.input.genderCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.genders
      .subscribe(gendersObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(canUpdateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(gendersObserver.events, [.next(0, expectedGendersAt20),
                                            .next(10, expectedGendersAt10),
                                            .next(20, expectedGendersAt20)])
    
    XCTAssertEqual(canUpdateObserver.events, [.next(0, false),
                                              .next(10, expectedCanUpateAt10),
                                              .next(20, expectedCanUpateAt20)])
  }
  
  // share 버튼 클릭시 output의 isShared & canUpdate 업데이트
  func testTransform_clickShareButton_updateIsSharedAndCanUpdate() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ()),
                                                         .next(20, ())])
    
    let isSharedObserver = self.scheduler.createObserver(Bool.self)
    let canUpdateObserver = self.scheduler.createObserver(Bool.self)
    
    let expectedIsSharedAt10 = false
    let expectedIsSharedAt20 = true
    
    let expectedCanUpateAt10 = true
    let expectedCanUpateAt20 = false
    
    // When
    observable
      .bind(to: self.input.shareButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.isShared
      .subscribe(isSharedObserver)
      .disposed(by: self.disposeBag)
    
    self.output.canUpdate
      .subscribe(canUpdateObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    XCTAssertEqual(isSharedObserver.events, [.next(0, true),
                                             .next(10, expectedIsSharedAt10),
                                             .next(20, expectedIsSharedAt20)])
    
    XCTAssertEqual(canUpdateObserver.events, [.next(0, false),
                                              .next(10, expectedCanUpateAt10),
                                              .next(20, expectedCanUpateAt20)])
  }
  
  // delete 버튼 클릭시 popup 보여주기
  func testTransform_clickDeleteButton_showPopup() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    observable
      .bind(to: self.input.deleteButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let actual = (self.coordinator as! MockPerfumeReviewCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // update 버튼 클릭시 update 및 finish 실행
  func testTransform_clickUpdateButton_updateReviewDetailAndFinish() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expectedReviewDetail = ReviewDetail(score: 4.0,
                                            sillage: 0,
                                            longevity: 2,
                                            seasonal: ["봄"],
                                            gender: 4,
                                            content: "향수가 좋아요!",
                                            reviewIdx: 10,
                                            perfume: nil,
                                            keywords: [Keyword(idx: 0, name: "키워드0", isSelected: true),
                                                       Keyword(idx: 1, name: "키워드1", isSelected: true)],
                                            brand: nil,
                                            isShared: false)
    
    let expectedCalledCount = 1
    
    self.viewModel.newReviewDetail = ReviewDetail(score: 4.0,
                                                  sillage: 0,
                                                  longevity: 2,
                                                  seasonal: ["봄"],
                                                  gender: 4,
                                                  content: "향수가 좋아요!",
                                                  reviewIdx: 10,
                                                  perfume: PerfumeInReviewDetail(idx: 5, name: "향수", imageUrl: ""),
                                                  keywords: [Keyword(idx: 0, name: "키워드0"),
                                                             Keyword(idx: 1, name: "키워드1")],
                                                  brand: BrandInReviewDetail(idx: 24, name: "조 말론"),
                                                  isShared: false)
    
    // When
    observable
      .bind(to: self.input.updateButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    let actualReviewDetail = (self.updateReviewUseCase as! MockUpdateReviewUseCase).reviewDetail!
    XCTAssertEqual(actualReviewDetail, expectedReviewDetail)
    
    let actualCalledCount = (self.coordinator as! MockPerfumeReviewCoordinator).finishFlowCalledCount
    XCTAssertEqual(actualCalledCount, expectedCalledCount)
  }
  
  // bottomSheet에서 keywords 업데이트 시 데이터 업데이트
  func testSetKeywordsFromBottomSheet_updateKeywordsAndCanUpdate() throws {
    
    // Given
    let expectedKeywordsAt0 = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                               Keyword(idx: 1, name: "키워드1", isSelected: false)]
    
    let expectedKeywordsAt10 = [Keyword(idx: 3, name: "키워드3", isSelected: true),
                                Keyword(idx: 4, name: "키워드4", isSelected: true)]
    
    let expectedKeywordsAt20 = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                                Keyword(idx: 1, name: "키워드1", isSelected: true)]
    
    
    
    let keywordsAt10 = [Keyword(idx: 0, name: "키워드0", isSelected: false),
                        Keyword(idx: 1, name: "키워드1", isSelected: false),
                        Keyword(idx: 2, name: "키워드2", isSelected: false),
                        Keyword(idx: 3, name: "키워드3", isSelected: true),
                        Keyword(idx: 4, name: "키워드4", isSelected: true),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let keywordsAt20 = [Keyword(idx: 0, name: "키워드0", isSelected: true),
                        Keyword(idx: 1, name: "키워드1", isSelected: true),
                        Keyword(idx: 2, name: "키워드2", isSelected: false),
                        Keyword(idx: 3, name: "키워드3", isSelected: false),
                        Keyword(idx: 4, name: "키워드4", isSelected: false),
                        Keyword(idx: 5, name: "키워드5", isSelected: false)]
    
    let keywordsObserver = self.scheduler.createObserver([Keyword].self)
    
    // When
    self.scheduler.scheduleAt(10) {
      self.viewModel.setKeywordsFromBottomSheet(keywords: keywordsAt10)
    }
    
    self.scheduler.scheduleAt(20) {
      self.viewModel.setKeywordsFromBottomSheet(keywords: keywordsAt20)
    }
    
    self.output.keywords
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    //Then
    self.scheduler.scheduleAt(10) {
      let actualKeywordsInField = self.viewModel.keywords
      XCTAssertEqual(actualKeywordsInField, keywordsAt10)
      
      let actualKeywords = self.viewModel.newReviewDetail.keywords
      XCTAssertEqual(actualKeywords, expectedKeywordsAt10)

    }
    
    self.scheduler.scheduleAt(20) {
      let actualKeywordsInField = self.viewModel.keywords
      XCTAssertEqual(actualKeywordsInField, keywordsAt20)
      
      let actualKeywords = self.viewModel.newReviewDetail.keywords
      XCTAssertEqual(actualKeywords, expectedKeywordsAt20)
    }
    
    XCTAssertEqual(keywordsObserver.events, [.next(0, expectedKeywordsAt0),
                                             .next(10, expectedKeywordsAt10),
                                             .next(20, expectedKeywordsAt20)])
    
  }
  
  // Popup에서 삭제 확인 누를 시에 Finish
  func testConfirm_ifSuccess_runFinish() throws {
    
    // Given
    let expectedReviewIdx = 10
    let expectedCalledCount = 1
    
    // When
    self.viewModel.confirm()
    
    // Then
    let actualReviewIdx = (self.deleteReviewUseCase as! MockDeleteReviewUseCase).reviewIdx
    XCTAssertEqual(actualReviewIdx, expectedReviewIdx)
    
    let actualCalledCount = (self.coordinator as! MockPerfumeReviewCoordinator).finishFlowCalledCount
    XCTAssertEqual(actualCalledCount, expectedCalledCount)
  }
  
  
  
  
}
