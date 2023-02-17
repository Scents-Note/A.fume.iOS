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
    let loadMenuEvent = PublishRelay<Void>()
    let closeButtonDidTapEvent = PublishRelay<Void>()
    let menuCellDidTapEvent = PublishRelay<Int>()
  }
  
  struct Output {
    let menus = BehaviorRelay<[String]>(value: [])
    let loadData = BehaviorRelay<Void>(value: ())
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MyPageCoordinator?
  private let fetchUserDefaultUseCase: FetchUserDefaultUseCase
  private let logoutUseCase: LogoutUseCase
  private let disposeBag = DisposeBag()
  weak var delegate: MyPageMenuDismissDelegate?
  let input = Input()
  let output = Output()
  var menus: [Menu] = []
  
  // MARK: - Life Cycle
  init(coordinator: MyPageCoordinator,
       fetchUserDefaultUseCase: FetchUserDefaultUseCase,
       logoutUseCase: LogoutUseCase) {
    self.coordinator = coordinator
    self.fetchUserDefaultUseCase = fetchUserDefaultUseCase
    self.logoutUseCase = logoutUseCase
    
    self.transform(input: self.input, output: self.output)
  }
  
  // MARK: - Binding
  func transform(input: Input, output: Output) {
    let loadData = PublishRelay<Void>()
    let menus = PublishRelay<[String]>()
    
    self.bindInput(input: input, loadData: loadData)
    self.bindOutput(menus: menus, output: output, disposeBag: disposeBag)
    self.fetchDatas(loadData: loadData, menus: menus, disposeBag: disposeBag)
    
  }
  
  private func bindInput(input: Input, loadData: PublishRelay<Void>) {
    input.loadMenuEvent
      .bind(to: loadData)
      .disposed(by: self.disposeBag)
    
    input.closeButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideMyPageMenuViewController()
      })
      .disposed(by: self.disposeBag)

    input.menuCellDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.performAction(idx: idx)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(menus: PublishRelay<[String]>, output: Output, disposeBag: DisposeBag) {
    menus
      .bind(to: output.menus)
      .disposed(by: disposeBag)
  }
  
  private func fetchDatas(loadData: PublishRelay<Void>,
                          menus: PublishRelay<[String]>,
                          disposeBag: DisposeBag) {
    
    loadData
      .subscribe(onNext: { [weak self] in
        self?.setMenus(menus: menus)
      })
      .disposed(by: disposeBag)
  }
  
  private func setMenus(menus: PublishRelay<[String]>) {
    let isLoggedIn = self.fetchUserDefaultUseCase.execute(key: UserDefaultKey.isLoggedIn) ?? false
    self.menus = isLoggedIn ? Menu.loggedIn : Menu.loggedOut
    menus.accept(self.menus.map { $0.description} )
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
      self.input.loadMenuEvent.accept(())
      self.delegate?.reloadData()
    case .login:
      self.coordinator?.runOnboardingFlow?()
    }
    self.coordinator?.hideMyPageMenuViewController()
  }
}

protocol MyPageMenuDismissDelegate: AnyObject {
  func reloadData()
}
