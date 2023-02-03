//
//  HomeViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/27.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class HomeViewModelTest: XCTestCase {
  private var coordinator: HomeCoordinator!
  private var fetchUserDefaultUseCase: FetchUserDefaultUseCase!
  private var updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase!
  private var fetchPerfumesRecommendedUseCase: FetchPerfumesRecommendedUseCase!
  private var fetchPerfumesPopularUseCase: FetchPerfumesPopularUseCase!
  private var fetchPerfumesRecentUseCase: FetchPerfumesRecentUseCase!
  private var fetchPerfumesNewUseCase: FetchPerfumesNewUseCase!
  private var viewModel: HomeViewModel!
  private var input: HomeViewModel.Input!
  private var cellInput: HomeViewModel.CellInput!
  private var output: HomeViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockHomeCoordinator()
    self.fetchUserDefaultUseCase = MockFetchUserDefaultUseCase()
    self.updatePerfumeLikeUseCase = MockUpdatePerfumeLikeUseCase()
    self.fetchPerfumesRecommendedUseCase = MockFetchPerfumesRecommendedUseCase()
    self.fetchPerfumesPopularUseCase = MockFetchPerfumesPopularUseCase()
    self.fetchPerfumesRecentUseCase = MockFetchPerfumesRecentUseCase()
    self.fetchPerfumesNewUseCase = MockFetchPerfumesNewUseCase()
    
    self.viewModel = HomeViewModel(coordinator: self.coordinator,
                                   fetchUserDefaultUseCase: self.fetchUserDefaultUseCase,
                                   updatePerfumeLikeUseCase: self.updatePerfumeLikeUseCase,
                                   fetchPerfumesRecommendedUseCase: self.fetchPerfumesRecommendedUseCase,
                                   fetchPerfumesPopularUseCase: self.fetchPerfumesPopularUseCase,
                                   fetchPerfumesRecentUseCase: self.fetchPerfumesRecentUseCase,
                                   fetchPerfumesNewUseCase: self.fetchPerfumesNewUseCase)
    
    self.input = self.viewModel.input
    self.cellInput = self.viewModel.cellInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchUserDefaultUseCase = nil
    self.updatePerfumeLikeUseCase = nil
    self.fetchPerfumesRecommendedUseCase = nil
    self.fetchPerfumesPopularUseCase = nil
    self.fetchPerfumesRecentUseCase = nil
    self.fetchPerfumesNewUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.cellInput = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  /// HomeDatas 가 방대해서 특정 index만 꺼내서 검사
  /// 1: Recommendation
  /// 2: Popular
  /// 3: Recent
  /// 4: New (비로그인시 3)
  
  func testFetchDatas_fetchPerfumesRecommended_success() throws {
    
    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                               Perfume(perfumeIdx: 4, brandName: "브랜드", name: "향수4", imageUrl: "", keywordList: ["따뜻함"], isLiked: false),
                               Perfume(perfumeIdx: 5, brandName: "브랜드", name: "향수4", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let expected = [HomeDataSection.HomeItem.recommendation(perfumes)]
    let expectedTime = 10
    
    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    let actual = observer.events.last!.value.element![1].items
    XCTAssertEqual(actual, expected)

    let actualTime = observer.events.last!.time
    XCTAssertEqual(actualTime, expectedTime)
  }
  
  func testFetchDatas_fetchPerfumesPopular_success() throws {
    
    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let perfumes = [Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: false),
                    Perfume(perfumeIdx: 7, brandName: "브랜드6", name: "향수7", imageUrl: "", keywordList: ["상큼한"], isLiked: false),
                    Perfume(perfumeIdx: 8, brandName: "브랜드1", name: "향수8", imageUrl: "", keywordList: [], isLiked: false)]
    
    let expected = perfumes.map {HomeDataSection.HomeItem.popularity($0) }
    let expectedTime = 10

    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    /// Datas 가 방대해서 특정 index만 꺼내서 검사
    let actual = observer.events.last!.value.element![2].items
    XCTAssertEqual(actual, expected)
    
    let actualTime = observer.events.last!.time
    XCTAssertEqual(actualTime, expectedTime)
    
  }
  
  func testFetchDatas_fetchPerfumesRecent_success() throws {
    
    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let perfumes = [Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: false)]
    
    let expected = perfumes.map {HomeDataSection.HomeItem.recent($0) }
    let expectedTime = 10

    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    /// Datas 가 방대해서 특정 index만 꺼내서 검사
    let actual = observer.events.last!.value.element![3].items
    XCTAssertEqual(actual, expected)
    
    let actualTime = observer.events.last!.time
    XCTAssertEqual(actualTime, expectedTime)
    
  }
  
  func testFetchDatas_ifLogout_NotFetchPerfumesRecent() throws {
    
    // Given
    (self.fetchUserDefaultUseCase as! MockFetchUserDefaultUseCase).isLoggedIn = false

    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let expectedIsRecent = false
    let expectedIsNew = true

    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    /// Datas 가 방대해서 특정 index만 꺼내서 검사
    let mockContent = HomeDataSection.Content(title: "", content: "")
    let actualIsRecent = observer.events.last!.value.element![3].model.hasSameCaseAs(.recent(mockContent))
    XCTAssertEqual(actualIsRecent, expectedIsRecent)
    
    let actualIsNew = observer.events.last!.value.element![3].model.hasSameCaseAs(.new(mockContent))
    XCTAssertEqual(actualIsNew, expectedIsNew)
    
  }
  
  func testFetchDatas_fetchPerfumesNew_success() throws {
    
    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let expected = perfumes.map {HomeDataSection.HomeItem.new($0) }
    let expectedTime = 10

    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    /// Datas 가 방대해서 특정 index만 꺼내서 검사
    let actual = observer.events.last!.value.element![4].items
    XCTAssertEqual(actual, expected)
    
    let actualTime = observer.events.last!.time
    XCTAssertEqual(actualTime, expectedTime)
  }
  
  // 로그인 시에 Collection View 헤더 Content가 잘 들어오는지
  // 닉네임과 출생년도 정보에 맞게 잘 들어가야 됨
  func testBindOutput_ifLogin_setHeaderContent() throws {
    
    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let expectedRecommended = HomeDataSection.Content(title: "득연님을 위한\n향수 추천", content: "센츠노트를 사용할수록\n더 잘 맞는 향수를 보여드려요.")
    
    let expectedPopular = HomeDataSection.Content(title: "20대 남성을 위한\n향수 추천", content: "득연님 연령대 분들에게 인기 많은 향수 입니다.")
    
    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    let actualRecommended = observer.events.last!.value.element![1].model.content()
    XCTAssertEqual(actualRecommended, expectedRecommended)

    let actualPopular = observer.events.last!.value.element![2].model.content()
    XCTAssertEqual(actualPopular, expectedPopular)
  }
  
  // 로그아웃 시에 Collection View 헤더 Content가 잘 들어오는지
  // Default 값이 들어가야댐
  func testBindOutput_ifLogout_setHeaderContent() throws {
    
    // Given
    (self.fetchUserDefaultUseCase as! MockFetchUserDefaultUseCase).isLoggedIn = false
    
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(10, ())])
    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)
    
    let expectedRecommended = HomeDataSection.Content(title: "당신을 위한\n향수 추천", content: "센츠노트를 사용할수록\n더 잘 맞는 향수를 보여드려요.")
    
    let expectedPopular = HomeDataSection.Content(title: "20대 여성이\n많이 찾는 향수", content: "설정에서 연령과 성별을 선택하면 더 잘 맞는 향수를 보여드려요.")
    
    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    
    let actualRecommended = observer.events.last!.value.element![1].model.content()
    XCTAssertEqual(actualRecommended, expectedRecommended)

    let actualPopular = observer.events.last!.value.element![2].model.content()
    XCTAssertEqual(actualPopular, expectedPopular)
  }
  
  // Perfume 클릭시 runPerfumeDetail 실행
  func testTransform_clickPerfume_runPerfumeDetail() throws {

    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(5, ())])
    
    let perfumeHeart = Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)
    let perfumeObservable = self.scheduler.createHotObservable([.next(10, perfumeHeart)])

    let expectedPerfumeIdx = 2
    let expectedCalledCount = 1
    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    perfumeObservable
      .bind(to: self.cellInput.perfumeCellDidTapEvent)
      .disposed(by: self.disposeBag)

    self.scheduler.start()

    // Then
    let actualPerfumeIdx = (self.coordinator as! MockHomeCoordinator).perfumeIdx
    XCTAssertEqual(actualPerfumeIdx, expectedPerfumeIdx)
    
    let actualCalledCount = (self.coordinator as! MockHomeCoordinator).runPerfumeDetailFlowCalledCount
    XCTAssertEqual(actualCalledCount, expectedCalledCount)
  }

  // 로그인 시에 PerfumeHeart 클릭시 Perfume 업데이트
  func testTransform_ifLogin_clickPerfumeHeart_updatePerfumes() throws {

    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(5, ())])
    
    let perfumeHeartClicked = Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: false)
    let perfumeHeartObservable = self.scheduler.createHotObservable([.next(10, perfumeHeartClicked)])

    let observer = self.scheduler.createObserver([HomeDataSection.Model].self)

    let perfumesPopular = [Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: true),
                               Perfume(perfumeIdx: 7, brandName: "브랜드6", name: "향수7", imageUrl: "", keywordList: ["상큼한"], isLiked: false),
                               Perfume(perfumeIdx: 8, brandName: "브랜드1", name: "향수8", imageUrl: "", keywordList: [], isLiked: false)]

    let expectedPopular = perfumesPopular.map { HomeDataSection.HomeItem.popularity($0) }

    let perfumesRecent = [Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: true)]

    let expectedRecent = perfumesRecent.map { HomeDataSection.HomeItem.recent($0) }

    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    perfumeHeartObservable
      .bind(to: self.cellInput.perfumeHeartButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.homeDatas
      .subscribe(observer)
      .disposed(by: self.disposeBag)

    self.scheduler.start()

    // Then
    let actualPopular = observer.events.last!.value.element![2].items
    XCTAssertEqual(actualPopular, expectedPopular)
    
    let actualRecent = observer.events.last!.value.element![3].items
    XCTAssertEqual(actualRecent, expectedRecent)
  }
  
  // 로그아웃 시에 PerfumeHeart 클릭시 showPopup 실행
  func testTransform_ifLogout_clickPerfumeHeart_showPopup() throws {

    // Given
    (self.updatePerfumeLikeUseCase as! MockUpdatePerfumeLikeUseCase).setState(state: .failure)

    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(5, ())])
    let perfumeHeartClicked = Perfume(perfumeIdx: 6, brandName: "브랜드4", name: "향수6", imageUrl: "", keywordList: [], isLiked: false)
    let perfumeHeartObservable = self.scheduler.createHotObservable([.next(10, perfumeHeartClicked)])
    
    let expected = 1
    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    perfumeHeartObservable
      .bind(to: self.cellInput.perfumeHeartButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockHomeCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // more cell 클릭시 perfumeNew 실행
  func testTransform_clickMore_runPerfumeNew() throws {

    // Given
    let viewWillAppearObservable = self.scheduler.createHotObservable([.next(5, ())])
    let moreButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    // When
    viewWillAppearObservable
      .bind(to: self.input.viewWillAppearEvent)
      .disposed(by: self.disposeBag)
    
    moreButtonObservable
      .bind(to: self.cellInput.moreCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()

    // Then
    let actual = (self.coordinator as! MockHomeCoordinator).runPerfumeNewFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // 팝업에서 Delegate로 confirm 실행됐을 때 runOnboarding 실행
  func testConfirm_runOnboardingFlow() throws {

    // Given
    let expected = 1
    
    // When
    self.viewModel.confirm()

    // Then
    let actual = (self.coordinator as! MockHomeCoordinator).runOnboardingFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
}
