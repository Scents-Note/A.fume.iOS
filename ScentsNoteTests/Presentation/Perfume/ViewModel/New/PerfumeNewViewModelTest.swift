//
//  PerfumeNewViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/01.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class PerfumeNewViewModelTest: XCTestCase {
  private var coordinator: PerfumeNewCoordinator!
  private var fetchPerfumesNewUseCase: FetchPerfumesNewUseCase!
  private var viewModel: PerfumeNewViewModel!
  private var input: PerfumeNewViewModel.Input!
  private var cellInput: PerfumeNewViewModel.CellInput!
  private var output: PerfumeNewViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeNewCoordinator()
    self.fetchPerfumesNewUseCase = MockFetchPerfumesNewUseCase()
    self.viewModel = PerfumeNewViewModel(coordinator: self.coordinator,
                                         fetchPerfumesNewUseCase: self.fetchPerfumesNewUseCase)
    
    self.input = self.viewModel.input
    self.cellInput = self.viewModel.cellInput
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchPerfumesNewUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.cellInput = nil
    self.output = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // Fetch 된 데이터가 output의 Perfumes에 잘 들어가는지
  func testFetchDatas_updatePerfumes() throws {
    
    // Given
    let observer = self.scheduler.createObserver([PerfumeDataSection.Model].self)
    
    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
    let expected = [PerfumeDataSection.Model(model: "perfumeNew", items: items)]
    
    // When
    self.output.perfumes
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [.next(0, expected)])
  }
  
  // report 버튼 클릭시 Web 실행
  func testTransform_clickReportButton_runWebFlow() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])

    let expected = WebURL.reportPerfumeInNew
    
    // When
    observable
      .bind(to: self.input.reportButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeNewCoordinator).url
    XCTAssertEqual(actual, expected)
  }
  
  // perfume Cell 클릭시 PerfumeDetail 실행
  func testTransform_clickPerfume_runPerfumeDetailFlow() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 1)])

    let expected = 1
    
    // When
    observable
      .bind(to: self.cellInput.perfumeDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockPerfumeNewCoordinator).perfumeIdx
    XCTAssertEqual(actual, expected)
  }
  
  // perfume Cell 클릭시 PerfumeDetail 실행
  func testTransform_clickPerfumeHeart_updatePerfumes() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 1)])
    let observer = self.scheduler.createObserver([PerfumeDataSection.Model].self)

    let perfumes = [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                    Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: true),
                    Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)]
    
    let items = perfumes.map { PerfumeDataSection.Item(perfume: $0) }
    let expected = [PerfumeDataSection.Model(model: "perfumeNew", items: items)]
    
    // When
    observable
      .bind(to: self.cellInput.perfumeHeartDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.perfumes
      .subscribe(observer)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events.last, .next(10, expected))
  }
}
