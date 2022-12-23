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
//    let 
  }
  
  struct Output {
    let reports = BehaviorRelay<[ReportType.Report]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: PerfumeDetailCoordinator?
  private let reviewIdx: Int
  private var report: String?
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeDetailCoordinator, reviewIdx: Int) {
    self.coordinator = coordinator
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
          self?.report = report.type.description
          return ReportType.Report(type: report.type, isSelected: true)
        } else {
          return ReportType.Report(type: report.type, isSelected: false)
        }
      }
    }
    .bind(to: reports)
    .disposed(by: disposeBag)
   
  }
  
  private func bindOutput(output: Output,
                          reports: PublishRelay<[ReportType.Report]>,
                          disposeBag: DisposeBag) {
    reports
      .bind(to: output.reports)
      .disposed(by: disposeBag)

  }
  
}
