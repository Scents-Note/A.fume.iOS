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

}
