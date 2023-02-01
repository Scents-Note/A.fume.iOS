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
  private var output: PerfumeNewViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeNewCoordinator()
    self.fetchReviewDetailUseCase = MockFetchPerfumesNewUseCase()
    self.viewModel = PerfumeNewViewModel(coordinator: self.coordinator,
                                         fetchPerfumesNewUseCase: self.fetchPerfumesNewUseCase)
    
    self.input = self.viewModel.input
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
  
}
