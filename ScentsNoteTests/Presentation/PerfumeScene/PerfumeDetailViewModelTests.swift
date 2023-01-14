//
//  PerfumeDetailViewModelTests.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2022/12/26.
//

import XCTest
import RxSwift
import RxRelay
import RxTest
@testable import ScentsNote

final class PerfumeDetailViewModelTests: XCTestCase {
  private var viewModel: PerfumeDetailViewModel!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  private var input: PerfumeDetailViewModel.Input!
  private var output: PerfumeDetailViewModel.Output!
  private var fetchPerfumeDetailUseCase: FetchPerfumeDetailUseCase!
  private var fetchReviewsInPerfumeDetailUseCase: FetchReviewsInPerfumeDetailUseCase!
  private let dummyReviews: [ReviewInPerfumeDetail] = [ReviewInPerfumeDetail(idx: 0, score: 5, access: true, content: "가", likeCount: 0, isLiked: false, gender: 1, age: "20", nickname: "득연1", isReported: false),
                                                       ReviewInPerfumeDetail(idx: 1, score: 4.5, access: true, content: "나", likeCount: 0, isLiked: false, gender: 1, age: "30", nickname: "득연2", isReported: false)]
  
  override func setUpWithError() throws {
    self.fetchPerfumeDetailUseCase = DefaultFetchPerfumeDetailUseCase(perfumeRepository: PerfumeRepositoryMock())
    self.fetchReviewsInPerfumeDetailUseCase = DefaultFetchReviewsInPerfumeDetailUseCase(perfumeRepository: PerfumeRepositoryMock())
//    self.viewModel = PerfumeDetailViewModel(coordinator: nil,
//                                            fetchPerfumeDetailUseCase: self.fetchPerfumeDetailUseCase,
//                                            fetchReviewsInPerfumeDetailUseCase: self.fetchReviewsInPerfumeDetailUseCase,
//                                            perfumeIdx: 0)
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.viewModel = nil
    self.disposeBag = nil
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
//  func test_fetchDatas() {
//    let viewDidLoadTestableObservable = self.scheduler.createHotObservable([.next(10, ())])
//
//    let reviewObserver = self.scheduler.createObserver([ReviewInPerfumeDetail].self)
//
//    self.input = PerfumeDetailViewModel.Input(viewWillAppearEvent: viewDidLoadTestableObservable.asObservable(),
//                                              reviewButtonDidTapEvent: Observable.just(()))
//
//
//    self.viewModel.transform(input: self.input, disposeBag: self.disposeBag)
//    self.viewModel.output.reviews.subscribe(reviewObserver).disposed(by: self.disposeBag)
//
//    self.scheduler.start()
//
//    XCTAssertEqual(reviewObserver.events, [
//      .next(0, []),
//      .next(10, self.dummyReviews)
//    ])
//  }
}
