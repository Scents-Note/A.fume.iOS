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
    var doneButtonDidTap = PublishRelay<Bool>()
    var birthRange = BehaviorRelay<[String]>(value: Birth.range.map {"\($0)"})
    var birth = BehaviorRelay<Int?>(value: nil)
  }
  
  // MARK: - Vars & Lets
  private weak var signCoordinator: SignUpCoordinator?
  private weak var editInfoCoordinator: EditInfoCoordinator?
  var dismissDelegate: BirthPopupDismissDelegate?
  var birth : String
  var from: CoordinatorType
  
  // MARK: - Life Cycle
  init(signCoordinator: SignUpCoordinator?, birth: Int, from: CoordinatorType) {
    self.signCoordinator = signCoordinator
    self.birth = String(birth)
    self.from = from
  }
  
  init(editInfoCoordinator: EditInfoCoordinator?, birth: Int, from: CoordinatorType) {
    self.editInfoCoordinator = editInfoCoordinator
    self.birth = String(birth)
    self.from = from
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
        switch self?.from {
        case .signUp:
          self?.signCoordinator?.hideBirthPopupViewController()
        case .myPage:
          self?.editInfoCoordinator?.hideBirthPopupViewController()
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    output.birth.accept(Int(self.birth))
    
    return output
  }
  
  
}
