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
    let reportCellDidTapEvent: Observable<Int>
    let cancelButtonDidTapEvent: Observable<Void>
    let reportButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    let reports = BehaviorRelay<[ReportType.Report]>(value: [])
    let isSelected = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: PerfumeDetailCoordinator?
  private let reportReviewUseCase: ReportReviewUseCase
  private let reviewIdx: Int
  
  private var reason: String?
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeDetailCoordinator,
       reportReviewUseCase: ReportReviewUseCase,
       reviewIdx: Int) {
    self.coordinator = coordinator
    self.reportReviewUseCase = reportReviewUseCase
    self.reviewIdx = reviewIdx
  }
  
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let reports = PublishRelay<[ReportType.Report]>()
    
    self.bindInput(input: input,
                   reports: reports,
                   disposeBag: disposeBag)
    self.bindOutput(output: output,
                    reports: reports,
                    disposeBag: disposeBag)
    
    reports.accept(ReportType.Report.default)

    return output
  }
  
  private func bindInput(input: Input,
                         reports: PublishRelay<[ReportType.Report]>,
                         disposeBag: DisposeBag) {
    
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
    .disposed(by: disposeBag)
    
    input.cancelButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideReviewReportPopupViewController()
      })
      .disposed(by: disposeBag)
    
    input.reportButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        guard let reviewIdx = self?.reviewIdx, let reason = self?.reason else { return }
        self?.reportReviewUseCase.execute(reviewIdx: reviewIdx, reason: reason)
          .subscribe(onNext: { _ in
            self?.coordinator?.hideReviewReportPopupViewController(hasToast: true)
          }, onError: { error in
            Log(error)
          })
          .disposed(by: disposeBag)
      })
      .disposed(by: disposeBag)

  }
  
  private func bindOutput(output: Output,
                          reports: PublishRelay<[ReportType.Report]>,
                          disposeBag: DisposeBag) {
    reports
      .subscribe(onNext: { reports in
        output.reports.accept(reports)
        output.isSelected.accept(())
      })
      .disposed(by: disposeBag)

  }
  
}
