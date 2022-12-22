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
  private weak var coordinator: MyPageCoordinator?
  weak var delegate: MyPageMenuDismissDelegate?
  private let fetchUserDefaultUseCase: FetchUserDefaultUseCase
  private let logoutUseCase: LogoutUseCase

  var menus: [Menu] = []
  let loadData = BehaviorRelay<Void>(value: ())
  
  // MARK: - Life Cycle
  init(coordinator: MyPageCoordinator,
       fetchUserDefaultUseCase: FetchUserDefaultUseCase,
       logoutUseCase: LogoutUseCase) {
    self.coordinator = coordinator
    self.fetchUserDefaultUseCase = fetchUserDefaultUseCase
    self.logoutUseCase = logoutUseCase

  }
  
  // MARK: - Binding
  func transform(from input: Input, disposeBag: DisposeBag) -> Output {
    let output = Output()
    let menus = PublishRelay<[String]>()
    
    self.bindInput(input: input, disposeBag: disposeBag)
    self.bindOutput(menus: menus, output: output, disposeBag: disposeBag)
    self.fetchDatas(loadData: self.loadData, menus: menus, disposeBag: disposeBag)
    
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
  
  private func fetchDatas(loadData: BehaviorRelay<Void>,
                          menus: PublishRelay<[String]>,
                          disposeBag: DisposeBag) {
    
    loadData
      .subscribe(onNext: { [weak self] in
        let isLoggedIn = self?.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn) ?? false
        self?.menus = isLoggedIn ? Menu.loggedIn : Menu.loggedOut
        menus.accept(self?.menus.map { $0.description} ?? [])
      })
      .disposed(by: disposeBag)
    
  }
  
  private func performAction(idx: Int) {
    
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
      self.logoutUseCase.execute()
      self.loadData.accept(())
      self.delegate?.reloadData()
    case .login:
      self.coordinator?.onOnboardingFlow?()
    }
    self.coordinator?.hideMyPageMenuViewController()
  }
}

protocol MyPageMenuDismissDelegate: AnyObject {
  func reloadData()
}
