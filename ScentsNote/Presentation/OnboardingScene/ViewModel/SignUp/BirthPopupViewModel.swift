//
//  BirthPopupViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class BirthPopupViewModel {
  private weak var coordinator: SignUpCoordinator?
  var dismissDelegate: BirthPopupDismissDelegate?
  var birth : String
  
  struct Input {
    let pickerSelectedRow: Observable<Int>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var doneButtonDidTap = PublishRelay<Bool>()
    var birthRange = BehaviorRelay<[String]>(value: Birth.range.map {"\($0)"})
    var birth = BehaviorRelay<Int?>(value: nil)
  }
  
  init(coordinator: SignUpCoordinator?, birth: String) {
    self.coordinator = coordinator
    self.birth = birth
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    input.pickerSelectedRow
      .map { Birth.range[$0] }
      .bind(to: output.birth)
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        output.doneButtonDidTap.accept(true)
        self?.coordinator?.hideBirthPopupViewController(with: "")
        //        self?.dismissDelegate?.birthPopupDismiss(with: "")
      })
      .disposed(by: disposeBag)
    
    output.birth.accept(Int(self.birth))
    
    return output
  }
  
  
}
