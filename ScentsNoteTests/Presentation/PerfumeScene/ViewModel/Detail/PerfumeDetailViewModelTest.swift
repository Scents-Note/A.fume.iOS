//
//  PerfumeDetailViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class PerfumeDetailViewModelTest: XCTestCase {
  private var coordinator: PerfumeDetailCoordinator!
  private var fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase!
  private var fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase!
  private var updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase!
  private var updateReviewLikeUseCase: UpdateReviewLikeUseCase!
  private var fetchUserDefaultUseCase: FetchUserDefaultUseCase!
  private var viewModel: PerfumeDetailViewModel!
  private var input: PerfumeDetailViewModel.Input!
  private var childInput: PerfumeDetailViewModel.ChildInput!
  private var output: PerfumeDetailViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeDetailCoordinator()
    self.fetchPerfumeDetailUseCase = MockFetchPerfumeDetailUseCase()
    self.fetchReviewsInPerfumeDetailUseCase = MockFetchReviewsInPerfumeDetailUseCase()
    self.updatePerfumeLikeUseCase = MockUpdatePerfumeLikeUseCase()
    self.updateReviewLikeUseCase = MockUpdateReviewLikeUseCase()
    self.fetchUserDefaultUseCase = MockFetchUserDefaultUseCase()
    self.viewModel = PerfumeDetailViewModel(coordinator: self.coordinator,
                                            fetchPerfumeDetailUseCase: self.fetchPerfumeDetailUseCase,
                                            fetchReviewsInPerfumeDetailUseCase: self.fetchReviewsInPerfumeDetailUseCase,
                                            updatePerfumeLikeUseCase: self.updatePerfumeLikeUseCase,
                                            updateReviewLikeUseCase: self.updateReviewLikeUseCase,
                                            fetchUserDefaultUseCase: self.fetchUserDefaultUseCase,
                                            perfumeIdx: 10)
    
    self.input = self.viewModel.input
    self.childInput = self.viewModel.childInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchPerfumeDetailUseCase = nil
    self.fetchReviewsInPerfumeDetailUseCase = nil
    self.updatePerfumeLikeUseCase = nil
    self.updateReviewLikeUseCase = nil
    self.fetchUserDefaultUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.childInput = nil
    self.output = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // Fetch 된 데이터가 output의 PerfumeDetail과 Reviews에 잘 들어가는지
  func testFetchDatas_setPerfumeDetailAndReviews() throws {
    
    // Given
    let perfumeDetailObserver = self.scheduler.createObserver(PerfumeDetail?.self)
    let reviewsObserver = self.scheduler.createObserver([ReviewInPerfumeDetail].self)
    
    let expectedPerfumeDetail = MockModel.perfumeDetail
    let expectedReviews = MockModel.reviews
    
    // When
    self.output.perfumeDetail
      .subscribe(perfumeDetailObserver)
      .disposed(by: self.disposeBag)
    
    self.output.reviews
      .subscribe(reviewsObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    // Then
    XCTAssertEqual(perfumeDetailObserver.events, [.next(0, expectedPerfumeDetail)])
    XCTAssertEqual(reviewsObserver.events, [.next(0, expectedReviews)])
  }
  
  // like Button 클릭시 로그인 상태라면 output의 isLiked 업데이트
  func testTransform_clickLikeButton_ifLogin_updateIsLiked() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ()),
                                                         .next(20, ())])
    let observer = self.scheduler.createObserver(Bool.self)
    
    let expectedAt10 = true
    let expectedAt20 = false
    
    // When
    observable
      .bind(to: self.input.likeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.isLiked
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [.next(10, expectedAt10),
                                     .next(20, expectedAt20)])
  }
  
  // like Button 클릭시 비로그인 상태라면 popup 띄우기
  func testTransform_clickLikeButton_ifLoggout_showPopup() throws {
    
    // Given
    
    // TODO: viewModel init에서 해줘야 할 부분 같음
    self.viewModel.isLoggedIn = false
    
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    observable
      .bind(to: self.input.likeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // review Button 클릭시 로그인 상태 & 작성된 리뷰가 없으면 runPerfumeReviewFlow 실행
  func testTransform_clickReviewButton_ifLoginAndNotExistReview_runPerfumeReviewFlow() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expectedDetail = MockModel.perfumeDetail
    let expectedPerfumeReviewCalledCount = 1
    
    // When
    observable
      .bind(to: self.input.reviewButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualDetail = (self.coordinator as! MockPerfumeDetailCoordinator).perfumeDetail
    XCTAssertEqual(actualDetail, expectedDetail)
    
    let actualPerfumeReviewCalledCount = (self.coordinator as! MockPerfumeDetailCoordinator).runPerfumeReviewFlowCalledCount
    XCTAssertEqual(actualPerfumeReviewCalledCount, expectedPerfumeReviewCalledCount)
  }
  
  // review Button 클릭시 로그인 상태 & 작성된 리뷰가 있으면 runPerfumeReviewFlow 실행
  func testTransform_clickReviewButton_ifLoginAndExistReview_runPerfumeReviewFlow() throws {
    
    // Given
    self.viewModel.perfumeDetail?.reviewIdx = 10
    
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 10
    
    // When
    observable
      .bind(to: self.input.reviewButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).reviewIdx
    XCTAssertEqual(actual, expected)
  }
  
  // review Button 클릭시 로그아웃 상태시 showPopup 실행
  func testTransform_clickReviewButton_ifLoggout_showPopup() throws {
    
    // Given
    self.viewModel.isLoggedIn = false
    
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    observable
      .bind(to: self.input.reviewButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // Tab Button 클릭시 output의 pageViewPosition 업데이트
  func testTransform_clickTabButton_updatePageViewPosition() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 1),
                                                         .next(20, 0)])
    
    let observer = self.scheduler.createObserver(Int.self)
    
    let expectedAt10 = 1
    let expectedAt20 = 0
    
    // When
    observable
      .bind(to: self.input.tabButtonTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.pageViewPosition
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [.next(0, 0),
                                     .next(10, expectedAt10),
                                     .next(20, expectedAt20)])
  }
  
  // showToast 실행시 output의 showToast 업데이트
  func testShowToast_updateShowToast() throws {
    
    // Given
    let observer = self.scheduler.createObserver(Void.self)
    
    // When
    self.scheduler.scheduleAt(10) {
      self.viewModel.showToast()
    }
    
    self.output.showToast
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events.map(VoidRecord.init), [.next(10, ())].map(VoidRecord.init))
    
  }
  
  // Suggestion Button 클릭시 runWebFlow 실행
  func testTransform_clickSuggestionButton_runWebFlow() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = WebURL.perfumeDetailSuggestion
    
    // When
    observable
      .bind(to: childInput.suggestionDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).url
    XCTAssertEqual(actual, expected)
  }
  
  // perfume cell 클릭시 runPerfumeDetailFlow 실행
  func testTransform_clickPerfume_runPerfumeDetailFlow() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 20)])
    
    let expected = 20
    
    // When
    observable
      .bind(to: childInput.perfumeDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).perfumeIdx
    XCTAssertEqual(actual, expected)
  }
  
  // review Heart 클릭시 output의 reviews 업데이트
  func testTransform_clickReviewHeart_updateReivews() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2)])
    let observer = self.scheduler.createObserver([ReviewInPerfumeDetail].self)
    
    let expected = [ReviewInPerfumeDetail(idx: 1, score: 5.0, access: true, content: "향이 좋아요", likeCount: 5,
                                          isLiked: false, gender: 1, age: "20대", nickname: "닉네임1", isReported: false),
                    ReviewInPerfumeDetail(idx: 2, score: 4.5, access: true, content: "가격이 좋아요", likeCount: 3,
                                          isLiked: true, gender: 1, age: "20대", nickname: "닉네임2", isReported: false)]
    
    // When
    observable
      .bind(to: childInput.reviewCellHeartTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.reviews
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [.next(0, MockModel.reviews),
                                     .next(10, expected)])
  }
  
  // review cell report 클릭시 로그인시 showReviewReportPopup 실행
  func testTransform_clickReviewReport_showReviewReportPopup() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2)])
    
    let expected = 1
    
    // When
    observable
      .bind(to: childInput.reviewCellReportTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).showReviewReportPopupViewControllerCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // review cell report 클릭시 비로그인시 showPopup 실행
  func testTransform_clickReviewReport_showPopup() throws {
    
    // Given
    self.viewModel.isLoggedIn = false

    let observable = self.scheduler.createHotObservable([.next(10, 2)])
    
    let expected = 1
    
    // When
    observable
      .bind(to: childInput.reviewCellReportTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // confirm 실행시 runOnboardingFlow 실행
  func testConfirm_runOnboardingFlow() throws {
    
    // Given
    let expected = 1
    
    // When
    self.viewModel.confirm()

    // Then
    let actual = (self.coordinator as! MockPerfumeDetailCoordinator).runOnboardingFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
}
