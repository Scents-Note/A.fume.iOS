//
//  ReviewReportPopupViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import RxSwift
import RxRelay

final class ReviewReportPopupViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let reportCellDidTapEvent = PublishRelay<Int>()
    let cancelButtonDidTapEvent = PublishRelay<Void>()
    let reportButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let reports = BehaviorRelay<[ReportType.Report]>(value: [])
    let isSelected = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: PerfumeDetailCoordinator?
  private let reportReviewUseCase: ReportReviewUseCase
  private let disposeBag = DisposeBag()
  
  let input = Input()
  let output = Output()
  let reviewIdx: Int
  var reason: String?
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeDetailCoordinator,
       reportReviewUseCase: ReportReviewUseCase,
       reviewIdx: Int) {
    self.coordinator = coordinator
    self.reportReviewUseCase = reportReviewUseCase
    self.reviewIdx = reviewIdx
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let reports = BehaviorRelay<[ReportType.Report]>(value: ReportType.Report.default)
    
    self.bindInput(input: input,
                   reports: reports)
    self.bindOutput(output: output,
                    reports: reports)
  }
  
  private func bindInput(input: Input,
                         reports: BehaviorRelay<[ReportType.Report]>) {
    
    input.reportCellDidTapEvent.withLatestFrom(reports) { updated, originals in
      originals.enumerated().map { [weak self] idx, report in
        if idx == updated {
          self?.reason = report.type.description
          return ReportType.Report(type: report.type, isSelected: true)
        } else {
          return ReportType.Report(type: report.type, isSelected: false)
        }
      }
    }
    .bind(to: reports)
    .disposed(by: self.disposeBag)
    
    input.cancelButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideReviewReportPopupViewController()
      })
      .disposed(by: self.disposeBag)
    
    input.reportButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let reviewIdx = self?.reviewIdx, let reason = self?.reason else { return }
        self?.reportReviewUseCase.execute(reviewIdx: reviewIdx, reason: reason)
          .subscribe(onNext: { _ in
            self?.coordinator?.hideReviewReportPopupViewController(hasToast: true)
          }, onError: { error in
            Log(error)
          })
          .disposed(by: self?.disposeBag ?? DisposeBag())
      })
      .disposed(by: self.disposeBag)

  }
  
  private func bindOutput(output: Output,
                          reports: BehaviorRelay<[ReportType.Report]>) {
    reports
      .subscribe(onNext: { reports in
        output.reports.accept(reports)
        output.isSelected.accept(())
      })
      .disposed(by: self.disposeBag)

  }
  
}
