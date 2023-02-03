//
//  SearchViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class SearchViewModelTest: XCTestCase {
  private var coordinator: SearchCoordinator!
  private var fetchPerfumesNewUseCase: FetchPerfumesNewUseCase!
  private var updatePerfumeLikeUseCase: UpdatePerfumeLikeUseCase!
  private var viewModel: SearchViewModel!
  private var input: SearchViewModel.Input!
  private var cellInput: SearchViewModel.CellInput!
  private var output: SearchViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockSearchCoordinator()
    self.fetchPerfumesNewUseCase = MockFetchPerfumesNewUseCase()
    self.updatePerfumeLikeUseCase = MockUpdatePerfumeLikeUseCase()
    
    self.viewModel = SearchViewModel(coordinator: self.coordinator,
                                     fetchPerfumesNewUseCase: self.fetchPerfumesNewUseCase,
                                     updatePerfumeLikeUseCase: self.updatePerfumeLikeUseCase)
    
    self.input = self.viewModel.input
    self.cellInput = self.viewModel.cellInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchPerfumesNewUseCase = nil
    self.updatePerfumeLikeUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.cellInput = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testTransform_clickSearchButton_runSearchKeyword() throws {
    
    // Given
    let searchButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    let expected = 1
    
    // When
    searchButtonObservable
      .bind(to: self.input.searchButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchCoordinator).runSearchKeywordFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickFilterButton_runSearchFilter() throws {
    
    // Given
    let filterButtonObservable = self.scheduler.createHotObservable([.next(10, ())])
    let expected = 1
    
    // When
    filterButtonObservable
      .bind(to: self.input.filterButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchCoordinator).runSearchFilterFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickPerfume_runPerfumeDetail() throws {
    
    // Given
    let perfume = Perfume.default
    let perfumeTapObservable = self.scheduler.createHotObservable([.next(10, perfume)])
    let expected = 1
    
    // When
    perfumeTapObservable
      .bind(to: self.cellInput.perfumeDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchCoordinator).runPerfumeDetailFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickPerfumeHeart_ifSuccess_updatePerfumes() throws {
    
    // Given
    let perfume = Perfume(perfumeIdx: 1,
                          brandName: "나",
                          name: "ㄴ",
                          imageUrl: "",
                          keywordList: ["향기로움"],
                          isLiked: false)
    
    let perfumeHeartTapObservable = self.scheduler.createHotObservable([.next(10, perfume),
                                                                        .next(20, perfume)])
    let perfumesObserver = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let expectedPerfumesOld = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let expectedPerfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: true),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let itemsOld = expectedPerfumesOld.map { PerfumeDataSection.Item(perfume: $0) }
    let expectedModelsOld = PerfumeDataSection.Model(model: "perfume", items: itemsOld)
    let items = expectedPerfumes.map { PerfumeDataSection.Item(perfume: $0) }
    let expectedModels = PerfumeDataSection.Model(model: "perfume", items: items)
    
    // When
    perfumeHeartTapObservable
      .bind(to: self.cellInput.perfumeHeartDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(perfumesObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(perfumesObserver.events, [.next(0, [expectedModelsOld]),
                                             .next(10, [expectedModels]),
                                             .next(20, [expectedModelsOld])])
    
  }
  
  func testTransform_clickPerfumeHeart_ifNotSuccess_showPopup() throws {
    
    // Given
    let perfume = Perfume(perfumeIdx: 1,
                          brandName: "나",
                          name: "ㄴ",
                          imageUrl: "",
                          keywordList: ["향기로움"],
                          isLiked: false)
    
    let perfumeHeartTapObservable = self.scheduler.createHotObservable([.next(10, perfume)])
    (self.updatePerfumeLikeUseCase as! TestUseCase).setState(state: .failure)
    
    let expected = 1
    
    // When
    perfumeHeartTapObservable
      .bind(to: self.cellInput.perfumeHeartDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockSearchCoordinator).showPopupCalledCount
    XCTAssertEqual(actual, expected)
    
  }
  
}
