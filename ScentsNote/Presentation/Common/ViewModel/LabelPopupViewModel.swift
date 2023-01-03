//
//  LabelPopupViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/03.
//

import RxSwift
import RxRelay

final class LabelPopupViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let cancelButtonDidTapEvent: Observable<Void>
    let confirmButtonDidTapEvent: Observable<Void>
    let dimmedViewDidTapEvent: Observable<Void>
  }
  
  struct Output {
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: PerfumeReviewCoordinator?
  private weak var delegate: LabelPopupDelegate?
  
  // MARK: - Life Cycle
  init(coordinator: PerfumeReviewCoordinator, delegate: LabelPopupDelegate) {
    self.coordinator = coordinator
    self.delegate = delegate
  }
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(output: output, disposeBag: disposeBag)
    self.fetchDatas(disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input, disposeBag: DisposeBag) {
    
    input.dimmedViewDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideDeletePopup()
      })
      .disposed(by: disposeBag)
    
    input.cancelButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideDeletePopup()
      })
      .disposed(by: disposeBag)
    
    input.confirmButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideDeletePopup()
        self?.delegate?.confirm()
      })
      .disposed(by: disposeBag)

  }
  
  private func bindOutput(output: Output, disposeBag: DisposeBag) {
    
  }
  
  private func fetchDatas(disposeBag: DisposeBag) {
    
  }
}

protocol LabelPopupDelegate: AnyObject {
  func confirm()
}
