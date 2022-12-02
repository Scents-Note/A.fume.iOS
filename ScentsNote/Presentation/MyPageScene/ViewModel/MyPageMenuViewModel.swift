//
//  MyPageMenuViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import RxSwift
import RxRelay

final class MyPageMenuViewModel {
  // MARK: - Input & Output
  struct Input {
    let closeButtonDidTapEvent: Observable<Void>
    let menuCellDidTapEvent: Observable<Int>
  }
  
  struct Output {
    let menus = BehaviorRelay<[String]>(value: [])
  }
  
  // MARK: - Vars & Lets
  weak var coordinator: MyPageCoordinator?
  var userRepository: UserRepository
  var menus: [Menu] = []
  
  
  // MARK: - Life Cycle
  init(coordinator: MyPageCoordinator, userRepository: UserRepository) {
    self.coordinator = coordinator
    self.userRepository = userRepository
  }
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let menus = PublishRelay<[String]>()
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(menus: menus, output: output, disposeBag: disposeBag)
    self.fetchDatas(menus: menus, disposeBag: disposeBag)
    return output
  }
  
  private func bindInput(input: Input, disposeBag: DisposeBag) {
    input.menuCellDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.performAction(idx: idx)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(menus: PublishRelay<[String]>, output: Output, disposeBag: DisposeBag) {
    menus
      .bind(to: output.menus)
      .disposed(by: disposeBag)
  }
  
  private func fetchDatas(menus: PublishRelay<[String]>, disposeBag: DisposeBag) {
    let isLoggedIn = self.userRepository.fetchUserDefaults(key: UserDefaultKey.isLoggedIn) ?? false
    self.menus = isLoggedIn ? Menu.loggedIn : Menu.loggedOut
    menus.accept(self.menus.map { $0.description} )
  }
  
  private func performAction(idx: Int) {
    self.coordinator?.hideMyPageMenuViewController()
    switch self.menus[idx] {
    case .editInfo:
      self.coordinator?.runEditInfoFlow()
    case .changePW:
      self.coordinator?.runChangePasswordFlow()
    case .report:
      self.coordinator?.runWebFlow(with: WebURL.reportPerfumeOrBrand)
    case .inquire:
      self.coordinator?.runWebFlow(with: WebURL.inquire)
    case .logout:
      break
    case .login:
      self.coordinator?.onOnboardingFlow?()
    }
    
  }
}
