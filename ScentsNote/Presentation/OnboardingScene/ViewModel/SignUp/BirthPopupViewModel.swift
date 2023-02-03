//
//  BirthPopupViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import RxSwift
import RxRelay

final class BirthPopupViewModel {
  
  // MARK: - Input & Output
  struct Input {
    let pickerSelectedRow: Observable<Int>
    let doneButtonDidTapEvent: Observable<Void>
  }
  
  struct Output {
    var birthRange = BehaviorRelay<[String]>(value: Birth.range.map {"\($0)"})
    var birth = BehaviorRelay<Int?>(value: nil)
  }
  
  // MARK: - Vars & Lets
  private weak var birthPopUpCoordinator: BirthPopUpCoordinator?
  weak var delegate: BirthPopupDismissDelegate?
  var birth : String
  
  // MARK: - Life Cycle
  init(birthPopUpCoordinator: BirthPopUpCoordinator?, birth: Int) {
    self.birthPopUpCoordinator = birthPopUpCoordinator
    self.birth = String(birth)
  }
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    
    input.pickerSelectedRow
      .map { Birth.range[$0] }
      .bind(to: output.birth)
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.delegate?.confirm(with: output.birth.value ?? 1990)
        self?.birthPopUpCoordinator?.hideBirthPopupViewController()
      })
      .disposed(by: disposeBag)
    
    output.birth.accept(Int(self.birth))
    
    return output
  }
  
  
}
