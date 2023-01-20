//
//  MyPageViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class MyPageViewModelTest: XCTestCase {
  private var coordinator: MyPageCoordinator!
  private var fetchUserDefaultUseCase: FetchUserDefaultUseCase!
  private var fetchReviewsInMyPageUseCase: FetchReviewsInMyPageUseCase!
  private var fetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase!
  private var viewModel: MyPageViewModel!
  private var input: MyPageViewModel.Input!
  private var scrollInput: MyPageViewModel.ScrollInput!
  private var output: MyPageViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockMyPageCoordinator()
    self.fetchUserDefaultUseCase = MockFetchUserDefaultUseCase()
    self.fetchReviewsInMyPageUseCase = MockFetchReviewsInMyPageUseCase()
    self.fetchPerfumesInMyPageUseCase = MockFetchPerfumesInMyPageUseCase()
    
    self.viewModel = MyPageViewModel(coordinator: self.coordinator,
                                     fetchUserDefaultUseCase: self.fetchUserDefaultUseCase,
                                     fetchReviewsInMyPageUseCase: self.fetchReviewsInMyPageUseCase,
                                     fetchPerfumesInMyPageUseCase: self.fetchPerfumesInMyPageUseCase)
    
    self.input = self.viewModel.input
    self.scrollInput = self.viewModel.scrollInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchUserDefaultUseCase = nil
    self.fetchReviewsInMyPageUseCase = nil
    self.fetchPerfumesInMyPageUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.scrollInput = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  // MARK: - Input Test
  
  // Login & Loggout 업데이트 시 데이터와 UI 변화
  // Login -> Loggout -> Login
  func testTransform_viewWillAppear_updateLoginState_updateDatasAndState() throws {
    
    // Given
    let viewWillAppearObserable = self.scheduler.createHotObservable([.next(10, ()),
                                                                      .next(30, ()),
                                                                      .next(50, ())])
    let loginStateObserver = self.scheduler.createObserver(Bool.self)
    let reviewsObserver = self.scheduler.createObserver([[ReviewInMyPage]].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeInMyPage].self)
    
    self.scheduler.scheduleAt(20) {
      (self.fetchUserDefaultUseCase as! MockFetchUserDefaultUseCase).updateMock(false)
    }
    
    self.scheduler.scheduleAt(40) {
      (self.fetchUserDefaultUseCase as! MockFetchUserDefaultUseCase).updateMock(true)
    }
    
    let expectedPerfumes = [PerfumeInMyPage(idx: 0, name: "가", brandName: "ㄱ", imageUrl: "", reviewIdx: 100),
                            PerfumeInMyPage(idx: 1, name: "나", brandName: "ㄴ", imageUrl: "", reviewIdx: 101),
                            PerfumeInMyPage(idx: 2, name: "다", brandName: "ㄷ", imageUrl: "", reviewIdx: 102),
                            PerfumeInMyPage(idx: 3, name: "라", brandName: "ㄹ", imageUrl: "", reviewIdx: 103)]
    
    let expectedReviews = [[ReviewInMyPage(reviewIdx: 0, score: 5.0, perfume: "가", imageUrl: "", brand: "ㄱ"),
                            ReviewInMyPage(reviewIdx: 1, score: 4.5, perfume: "나", imageUrl: "", brand: "ㄴ"),
                            ReviewInMyPage(reviewIdx: 2, score: 3.7, perfume: "다", imageUrl: "", brand: "ㄱ")],
                           [ReviewInMyPage(reviewIdx: 3, score: 5.0, perfume: "라", imageUrl: "", brand: "ㄱ"),
                            ReviewInMyPage(reviewIdx: 4, score: 4.5, perfume: "마", imageUrl: "", brand: "ㄴ"),
                            ReviewInMyPage(reviewIdx: 5, score: 3.7, perfume: "바", imageUrl: "", brand: "ㄱ")]]
    
    // When
    viewWillAppearObserable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.loginState
      .subscribe(loginStateObserver)
      .disposed(by: self.disposeBag)
    
    self.output.reviews
      .subscribe(reviewsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(loginStateObserver.events, [.next(0, false),
                                               .next(10, true),
                                               .next(30, false),
                                               .next(50, true)])
    
    XCTAssertEqual(reviewsObserver.events, [.next(0, []),
                                            .next(10, expectedReviews),
                                            .next(30, []),
                                            .next(50, expectedReviews)])
    
    XCTAssertEqual(perfumesObserver.events, [.next(0, []),
                                             .next(10, expectedPerfumes),
                                             .next(30, []),
                                             .next(50, expectedPerfumes)])
  }
  
  
  func testTransform_clickMyPerfumeButton_updateTab() throws {
    
    // Given
    let myPerfumeButtonObserable = self.scheduler.createHotObservable([.next(10, ())])
    let selectedTabObserver = self.scheduler.createObserver(Int.self)

    // When
    myPerfumeButtonObserable
      .bind(to: self.input.myPerfumeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.selectedTab
      .subscribe(selectedTabObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    XCTAssertEqual(selectedTabObserver.events, [.next(0, 0),
                                                .next(10, 0)])
  }
  
  func testTransform_clickWishListButton_updateTab() throws {
    
    // Given
    let wishListButtonObserable = self.scheduler.createHotObservable([.next(10, ())])
    let selectedTabObserver = self.scheduler.createObserver(Int.self)

    // When
    wishListButtonObserable
      .bind(to: self.input.wishListButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.selectedTab
      .subscribe(selectedTabObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    XCTAssertEqual(selectedTabObserver.events, [.next(0, 0),
                                                .next(10, 1)])
  }
  
  func testTransform_clickMenuButton_showMyPageMenu() throws {
    
    // Given
    let menuButtonObserable = self.scheduler.createHotObservable([.next(10, ())])

    let expected = 1
    // When
    menuButtonObserable
      .bind(to: self.input.menuButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).showMyPageMenuViewControllerCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // MARK: - ScrollInput Test
  
  func testTransform_clickReviewCell_runPerfumeReview() throws {
    
    // Given
    let reviewCellObserable = self.scheduler.createHotObservable([.next(10, 1)])

    let expected = 1
    // When
    reviewCellObserable
      .bind(to: self.scrollInput.reviewCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runPerfumeReviewFlowWithReviewIdxCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickPerfumeCell_runPerfumeDetail() throws {
    
    // Given
    let perfumeCellObserable = self.scheduler.createHotObservable([.next(10, 1)])

    let expected = 1
    // When
    perfumeCellObserable
      .bind(to: self.scrollInput.perfumeCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runPerfumeDetailFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickReviewButton_ifHasReview_runPerfumeReview() throws {
    
    // Given
    let review = PerfumeInMyPage(idx: 0,
                                 name: "향수",
                                 brandName: "조 말론",
                                 imageUrl: "",
                                 reviewIdx: 10)
    
    let reviewButtonObserable = self.scheduler.createHotObservable([.next(10, review)])

    let expected = 1
    // When
    reviewButtonObserable
      .bind(to: self.scrollInput.reviewButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runPerfumeReviewFlowWithReviewIdxCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickReviewButton_ifHasNotReview_runPerfumeReview() throws {
    
    // Given
    let review = PerfumeInMyPage(idx: 0,
                                 name: "향수",
                                 brandName: "조 말론",
                                 imageUrl: "",
                                 reviewIdx: 0)
    
    let reviewButtonObserable = self.scheduler.createHotObservable([.next(10, review)])

    let expected = 1
    // When
    reviewButtonObserable
      .bind(to: self.scrollInput.reviewButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runPerfumeReviewFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickLoginButton_runOnboarding() throws {
    
    // Given
    let loginButtonObserable = self.scheduler.createHotObservable([.next(10, ())])

    let expected = 1
    // When
    loginButtonObserable
      .bind(to: self.scrollInput.loginButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runOnboardingFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testReloadData_viewWillAppear() throws {
    
    // Given
    let loginStateObserver = self.scheduler.createObserver(Bool.self)
    let reviewsObserver = self.scheduler.createObserver([[ReviewInMyPage]].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeInMyPage].self)
    
    self.scheduler.scheduleAt(20) {
      self.viewModel.reloadData()
    }
    
    let expectedPerfumes = [PerfumeInMyPage(idx: 0, name: "가", brandName: "ㄱ", imageUrl: "", reviewIdx: 100),
                            PerfumeInMyPage(idx: 1, name: "나", brandName: "ㄴ", imageUrl: "", reviewIdx: 101),
                            PerfumeInMyPage(idx: 2, name: "다", brandName: "ㄷ", imageUrl: "", reviewIdx: 102),
                            PerfumeInMyPage(idx: 3, name: "라", brandName: "ㄹ", imageUrl: "", reviewIdx: 103)]
    
    let expectedReviews = [[ReviewInMyPage(reviewIdx: 0, score: 5.0, perfume: "가", imageUrl: "", brand: "ㄱ"),
                            ReviewInMyPage(reviewIdx: 1, score: 4.5, perfume: "나", imageUrl: "", brand: "ㄴ"),
                            ReviewInMyPage(reviewIdx: 2, score: 3.7, perfume: "다", imageUrl: "", brand: "ㄱ")],
                           [ReviewInMyPage(reviewIdx: 3, score: 5.0, perfume: "라", imageUrl: "", brand: "ㄱ"),
                            ReviewInMyPage(reviewIdx: 4, score: 4.5, perfume: "마", imageUrl: "", brand: "ㄴ"),
                            ReviewInMyPage(reviewIdx: 5, score: 3.7, perfume: "바", imageUrl: "", brand: "ㄱ")]]
    
    // When
    self.output.loginState
      .subscribe(loginStateObserver)
      .disposed(by: self.disposeBag)
    
    self.output.reviews
      .subscribe(reviewsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(loginStateObserver.events, [.next(0, false),
                                               .next(20, true)])
    
    XCTAssertEqual(reviewsObserver.events, [.next(0, []),
                                            .next(20, expectedReviews)])
    
    XCTAssertEqual(perfumesObserver.events, [.next(0, []),
                                             .next(20, expectedPerfumes)])
    
  }
  
}
