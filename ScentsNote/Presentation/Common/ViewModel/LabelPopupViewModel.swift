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
    let dimmedViewDidTapEvent = PublishRelay<Void>()
    let cancelButtonDidTapEvent = PublishRelay<Void>()
    let confirmButtonDidTapEvent = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: PopUpCoordinator?
  private weak var delegate: LabelPopupDelegate?
  private let disposeBag = DisposeBag()
  let input = Input()
  
  // MARK: - Life Cycle
  init(coordinator: PopUpCoordinator, delegate: LabelPopupDelegate) {
    self.coordinator = coordinator
    self.delegate = delegate
    
    self.transform(input: self.input)
  }
  
  // MARK: - Binding
  func transform(input: Input) {
    self.bindInput(input: input)
  }
  
  private func bindInput(input: Input) {
    input.dimmedViewDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hidePopup()
      })
      .disposed(by: disposeBag)
    
    input.cancelButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hidePopup()
      })
      .disposed(by: disposeBag)
    
    input.confirmButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.delegate?.confirm()
        self?.coordinator?.hidePopup()
      })
      .disposed(by: disposeBag)
  }
}

protocol LabelPopupDelegate: AnyObject {
  func confirm()
}
