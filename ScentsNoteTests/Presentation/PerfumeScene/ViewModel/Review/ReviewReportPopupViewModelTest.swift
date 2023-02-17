//
//  ReviewReportPopupViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/31.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class ReviewReportPopupViewModelTest: XCTestCase {
  private var coordinator: PerfumeDetailCoordinator!
  private var reportReviewUseCase: ReportReviewUseCase!
  private var viewModel: ReviewReportPopupViewModel!
  private var input: ReviewReportPopupViewModel.Input!
  private var output: ReviewReportPopupViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockPerfumeDetailCoordinator()
    self.reportReviewUseCase = MockReportReviewUseCase()
    self.viewModel = ReviewReportPopupViewModel(coordinator: self.coordinator,
                                                reportReviewUseCase: self.reportReviewUseCase,
                                                reviewIdx: 10)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.reportReviewUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
    self.scheduler = nil
    self.disposeBag = nil
  }
  
  // report Cell 버튼 클릭시 Reports와 isSelected 업데이트
  func testTransform_clickReport_updateReports() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, 2),
                                                         .next(20, 4)])
    
    let reportsObserver = self.scheduler.createObserver([ReportType.Report].self)
    let isSelectedObserver = self.scheduler.createObserver(Void.self)
    
    let expectedReportsAt0 = [ReportType.Report(type: .advertising, isSelected: false),
                              ReportType.Report(type: .abuse, isSelected: false),
                              ReportType.Report(type: .typo, isSelected: false),
                              ReportType.Report(type: .privacy, isSelected: false),
                              ReportType.Report(type: .irrelevant, isSelected: false),
                              ReportType.Report(type: .defamation, isSelected: false),
                              ReportType.Report(type: .etc, isSelected: false)]
    
    let expectedReportsAt10 = [ReportType.Report(type: .advertising, isSelected: false),
                               ReportType.Report(type: .abuse, isSelected: false),
                               ReportType.Report(type: .typo, isSelected: true),
                               ReportType.Report(type: .privacy, isSelected: false),
                               ReportType.Report(type: .irrelevant, isSelected: false),
                               ReportType.Report(type: .defamation, isSelected: false),
                               ReportType.Report(type: .etc, isSelected: false)]
    
    let expectedReportsAt20 = [ReportType.Report(type: .advertising, isSelected: false),
                               ReportType.Report(type: .abuse, isSelected: false),
                               ReportType.Report(type: .typo, isSelected: false),
                               ReportType.Report(type: .privacy, isSelected: false),
                               ReportType.Report(type: .irrelevant, isSelected: true),
                               ReportType.Report(type: .defamation, isSelected: false),
                               ReportType.Report(type: .etc, isSelected: false)]
    
    
    // When
    observable
      .bind(to: self.input.reportCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.reports
      .subscribe(reportsObserver)
      .disposed(by: self.disposeBag)
    
    self.output.isSelected
      .subscribe(isSelectedObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(reportsObserver.events, [.next(0, expectedReportsAt0),
                                            .next(10, expectedReportsAt10),
                                            .next(20, expectedReportsAt20)])
    
    XCTAssertEqual(isSelectedObserver.events.map(VoidRecord.init), [.next(10, ()),
                                                                    .next(20, ())].map(VoidRecord.init))
    
    
    
  }
  
  // cancel 버튼 클릭시 Report
  func testTransform_clickCancelButton_hidePopup() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    let expcetedHidePopupCalledCount = 1
    
    // When
    observable
      .bind(to: self.input.cancelButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualhidePopupCalledCount = (self.coordinator as! MockPerfumeDetailCoordinator).hideReviewReportPopupViewControllerCalledCount
    XCTAssertEqual(actualhidePopupCalledCount, expcetedHidePopupCalledCount)
  }
  
  // report 버튼 클릭시 Report
  func testTransform_clickReportButton_reportAndHidePopup() throws {
    
    // Given
    let observable = self.scheduler.createHotObservable([.next(10, ())])
    
    self.viewModel.reason = "비속어 사용"
    
    let expectedReviewIdx = 10
    let expectedReason = "비속어 사용"
    let expcetedHidePopupCalledCount = 1
    
    // When
    observable
      .bind(to: self.input.reportButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actualReviewIdx = (self.reportReviewUseCase as! MockReportReviewUseCase).reviewIdx
    XCTAssertEqual(actualReviewIdx, expectedReviewIdx)
    
    let actualReason = (self.reportReviewUseCase as! MockReportReviewUseCase).reason
    XCTAssertEqual(actualReason, expectedReason)
    
    let actualhidePopupCalledCount = (self.coordinator as! MockPerfumeDetailCoordinator).hideReviewReportPopupViewControllerCalledCount
    XCTAssertEqual(actualhidePopupCalledCount, expcetedHidePopupCalledCount)
  }
}
