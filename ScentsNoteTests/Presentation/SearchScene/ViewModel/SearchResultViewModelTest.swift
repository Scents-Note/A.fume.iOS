//
//  SearchResultViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class SearchResultViewModelTest: XCTestCase {
  private var coordinator: SearchResultCoordinator!
  private var fetchPerfumeSearchedUseCase: FetchPerfumeSearchedUseCase!
  private var updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase!
  private var perfumeSearch: PerfumeSearch!
  private var viewModel: SearchResultViewModel!
  private var input: SearchResultViewModel.Input!
  private var cellInput: SearchResultViewModel.CellInput!
  private var output: SearchResultViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSearchResultCoordinator()
    self.fetchPerfumeSearchedUseCase = MockFetchPerfumeSearchedUseCase()
    self.updatePerfumeLikeUseCase = MockUpdatePerfumeLikeUseCase()
    self.perfumeSearch = PerfumeSearch(ingredients: [SearchKeyword(idx: 0, name: "장미", category: .ingredient),
                                                     SearchKeyword(idx: 1, name: "오렌지", category: .ingredient)],
                                       brands: [SearchKeyword(idx: 0, name: "구찌", category: .brand),
                                                SearchKeyword(idx: 1, name: "디올", category: .brand)],
                                       keywords: [SearchKeyword(idx: 0, name: "가벼운", category: .keyword),
                                                  SearchKeyword(idx: 1, name: "따뜻한", category: .keyword)])
    self.viewModel = SearchResultViewModel(coordinator: self.coordinator,
                                           fetchPerfumeSearchedUseCase: self.fetchPerfumeSearchedUseCase,
                                           updatePerfumeLikeUseCase: self.updatePerfumeLikeUseCase,
                                           perfumeSearch: self.perfumeSearch)
    self.input = self.viewModel.input
    self.cellInput = self.viewModel.cellInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  // Fetch된 Perfumes 와 SearchKeywords가 Output이 잘 들어갔는지
  func testFetchDatas_fetchPerfumes_success() throws {
    
    // Given
    let keywordsObserver = self.scheduler.createObserver([KeywordDataSection.Model].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let keywords = [SearchKeyword(idx: 0, name: "장미", category: .ingredient),
                    SearchKeyword(idx: 1, name: "오렌지", category: .ingredient),
                    SearchKeyword(idx: 0, name: "구찌", category: .brand),
                    SearchKeyword(idx: 1, name: "디올", category: .brand),
                    SearchKeyword(idx: 0, name: "가벼운", category: .keyword),
                    SearchKeyword(idx: 1, name: "따뜻한", category: .keyword)]
    
    let keywordItems = keywords.map { KeywordDataSection.Item(keyword: $0) }
    let expectedKeywords = [KeywordDataSection.Model(model: "keyword", items: keywordItems)]
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "브랜드0", name: "향수0", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "브랜드1", name: "향수1", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "브랜드2", name: "향수2", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    let perfumeItems = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
    let expectedPerfumes = [PerfumeDataSection.Model(model: "perfume", items: perfumeItems)]
    
    // When
    self.output.keywords
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(keywordsObserver.events.last, .next(0, expectedKeywords))
    XCTAssertEqual(perfumesObserver.events.last, .next(0, expectedPerfumes))
  }
  
  // Search Button 클릭시 runSearchKeywordFlow 가 실행되는 지
  func testTransform_clickSearchButton_runSearchKeywordFlow() throws {
    
    // Given
    let searchButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    searchButtonObservable
      .bind(to: self.input.searchButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchResultCoordinator).runSearchKeywordFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // Filter Button 클릭시 runSearchFilterFlow 가 실행되는 지
  func testTransform_clickFilterButton_runSearchFilterFlow() throws {
    
    // Given
    let filterButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = 1
    
    // When
    filterButtonObservable
      .bind(to: self.input.filterButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchResultCoordinator).runSearchFilterFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // Report Button 클릭시 runWebFlow 가 실행되는 지
  func testTransform_clickReportButton_runWebFlow() throws {
    
    // Given
    let reportButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    
    let expected = WebURL.reportPerfumeInSearch
    
    // When
    reportButtonObservable
      .bind(to: self.input.reportButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchResultCoordinator).url
    XCTAssertEqual(actual, expected)
  }
  
  // Ingredient 카테고리 Keyword Cell을 삭제했을 시 새로운 Perfumes Fetch 및 Keywords 업데이트
  func testTransform_deleteIngredientKeyword_updatePerfumesAndKeywords() throws {
    
    // Given
    let keywordDeleteObservable = self.scheduler.createHotObservable([.next(10, SearchKeyword(idx: 0, name: "장미", category: .ingredient))])
    
    let keywordsObserver = self.scheduler.createObserver([KeywordDataSection.Model].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let keywords = [SearchKeyword(idx: 1, name: "오렌지", category: .ingredient),
                    SearchKeyword(idx: 0, name: "구찌", category: .brand),
                    SearchKeyword(idx: 1, name: "디올", category: .brand),
                    SearchKeyword(idx: 0, name: "가벼운", category: .keyword),
                    SearchKeyword(idx: 1, name: "따뜻한", category: .keyword)]
    
    let expectedKeywords = keywords.toSectionModel()
    
    let perfumes = [Perfume(perfumeIdx: 3, brandName: "브랜드3", name: "향수3", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "브랜드4", name: "향수4", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "브랜드5", name: "향수5", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    let expectedPerfumes = perfumes.toSectionModel()
    
    // When
    keywordDeleteObservable
      .bind(to: self.cellInput.keywordDeleteDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywords
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(keywordsObserver.events.last, .next(10, expectedKeywords))
    XCTAssertEqual(perfumesObserver.events.last, .next(10, expectedPerfumes))
  }
  
  // Brand 카테고리 Keyword Cell을 삭제했을 시 새로운 Perfumes Fetch 및 Keywords 업데이트
  func testTransform_deleteBrandKeyword_updatePerfumesAndKeywords() throws {
    
    // Given
    let keywordDeleteObservable = self.scheduler.createHotObservable([.next(10, SearchKeyword(idx: 1, name: "디올", category: .brand))])
    
    let keywordsObserver = self.scheduler.createObserver([KeywordDataSection.Model].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let keywords = [SearchKeyword(idx: 0, name: "장미", category: .ingredient),
                    SearchKeyword(idx: 1, name: "오렌지", category: .ingredient),
                    SearchKeyword(idx: 0, name: "구찌", category: .brand),
                    SearchKeyword(idx: 0, name: "가벼운", category: .keyword),
                    SearchKeyword(idx: 1, name: "따뜻한", category: .keyword)]
    
    let expectedKeywords = keywords.toSectionModel()
    
    let perfumes = [Perfume(perfumeIdx: 3, brandName: "브랜드3", name: "향수3", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "브랜드4", name: "향수4", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "브랜드5", name: "향수5", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    let expectedPerfumes = perfumes.toSectionModel()
    
    // When
    keywordDeleteObservable
      .bind(to: self.cellInput.keywordDeleteDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywords
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(keywordsObserver.events.last, .next(10, expectedKeywords))
    XCTAssertEqual(perfumesObserver.events.last, .next(10, expectedPerfumes))
  }
  
  // Keyword 카테고리 Keyword Cell을 삭제했을 시 새로운 Perfumes Fetch 및 Keywords 업데이트
  func testTransform_deleteKeywordKeyword_updatePerfumesAndKeywords() throws {
    
    // Given
    let keywordDeleteObservable = self.scheduler.createHotObservable([.next(10, SearchKeyword(idx: 0, name: "가벼운", category: .keyword))])
    
    let keywordsObserver = self.scheduler.createObserver([KeywordDataSection.Model].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let keywords = [SearchKeyword(idx: 0, name: "장미", category: .ingredient),
                    SearchKeyword(idx: 1, name: "오렌지", category: .ingredient),
                    SearchKeyword(idx: 0, name: "구찌", category: .brand),
                    SearchKeyword(idx: 1, name: "디올", category: .brand),
                    SearchKeyword(idx: 1, name: "따뜻한", category: .keyword)]
    
    let expectedKeywords = keywords.toSectionModel()
    
    let perfumes = [Perfume(perfumeIdx: 3, brandName: "브랜드3", name: "향수3", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "브랜드4", name: "향수4", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "브랜드5", name: "향수5", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    let expectedPerfumes = perfumes.toSectionModel()
    
    // When
    keywordDeleteObservable
      .bind(to: self.cellInput.keywordDeleteDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.keywords
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(keywordsObserver.events.last, .next(10, expectedKeywords))
    XCTAssertEqual(perfumesObserver.events.last, .next(10, expectedPerfumes))
  }
  
  // Perfume 클릭시 runPerfumeDetailFlow 실행
  func testTransform_clickPerfume_runPerfumeDetailFlow() throws {
    
    // Given
    let perfume = Perfume(perfumeIdx: 2, brandName: "브랜드2", name: "향수2", imageUrl: "", keywordList: ["3", "4"], isLiked: false)
    let perfumeObservable = self.scheduler.createHotObservable([.next(10, perfume)])
    
    let expected = 2
    
    // When
    perfumeObservable
      .bind(to: self.cellInput.perfumeDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchResultCoordinator).perfumeDetailIdx
    XCTAssertEqual(actual, expected)
  }
  
  // Perfume Heart 클릭시 perfumes 업데이트
  func testTransform_clickPerfumeHeart_ifSuccess_updatePerfumes() throws {
    
    // Given
    let perfumeHeartObservable = self.scheduler.createHotObservable([.next(10, Perfume(perfumeIdx: 0, brandName: "브랜드0", name: "향수0", imageUrl: "", keywordList: ["0", "1"], isLiked: false))])
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "브랜드0", name: "향수0", imageUrl: "", keywordList: ["0", "1"], isLiked: true),
                    Perfume(perfumeIdx: 1, brandName: "브랜드1", name: "향수1", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "브랜드2", name: "향수2", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
    let expected = [PerfumeDataSection.Model(model: "perfume", items: items)]
    
    
    // When
    perfumeHeartObservable
      .bind(to: self.cellInput.perfumeHeartDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(perfumesObserver.events.last, .next(10, expected))
  }
  
  // Perfume Heart 클릭할 때 실패시 showPopup 실행
  func testTransform_clickPerfumeHeart_ifFailure_showPopup() throws {
    
    // Given
    let perfumeHeartObservable = self.scheduler.createHotObservable([.next(10, Perfume(perfumeIdx: 0, brandName: "브랜드0", name: "향수0", imageUrl: "", keywordList: ["0", "1"], isLiked: false))])
    
    let expected = 1
    (self.updatePerfumeLikeUseCase as! MockUpdatePerfumeLikeUseCase).setState(state: .failure)
    
    // When
    perfumeHeartObservable
      .bind(to: self.cellInput.perfumeHeartDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchResultCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // 외부에서 UpdateSearchWords 실행시 데이터 업데이트
  func testUpdateSearchWords_updatePerfumesAndKeywords() throws {
    
    // Given
    let keywordsObserver = self.scheduler.createObserver([KeywordDataSection.Model].self)
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let keywords = [SearchKeyword(idx: -1, name: "조 말론", category: .searchWord)]
    let expectedKeywords = keywords.toSectionModel()
    
    let perfumes = [Perfume(perfumeIdx: 3, brandName: "브랜드3", name: "향수3", imageUrl: "", keywordList: ["0", "1"], isLiked: false),
                    Perfume(perfumeIdx: 4, brandName: "브랜드4", name: "향수4", imageUrl: "", keywordList: ["0", "2"], isLiked: false),
                    Perfume(perfumeIdx: 5, brandName: "브랜드5", name: "향수5", imageUrl: "", keywordList: ["3", "4"], isLiked: false)]
    
    let expectedPerfumes = perfumes.toSectionModel()
    
    // When
    self.scheduler.scheduleAt(10) {
      self.viewModel.updateSearchWords(perfumeSearch: PerfumeSearch(searchWord: "조 말론"))
    }
    
    self.output.keywords
      .subscribe(keywordsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(keywordsObserver.events.last, .next(10, expectedKeywords))
    XCTAssertEqual(perfumesObserver.events.last, .next(10, expectedPerfumes))
  }
  
  // 외부에서 Confrim 실행시 runOnBoardingFlow 실행
  func testConfirm_runOnBoardingFlow() throws {
    
    // Given
    let expected = 1
    
    // When
    self.viewModel.confirm()

    // Then
    let actual = (self.coordinator as! MockSearchResultCoordinator).runOnboardingFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
}
