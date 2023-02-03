//
//  SplashViewModel.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/05.
//

import Foundation

import RxSwift
import RxRelay

final class SplashViewModel {
  
  // MARK: - Vars & Lets
  private weak var coordinator: SplashCoordinator?
  private let loginUseCase: LoginUseCase
  private let logoutUseCase: LogoutUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  init(coordinator: SplashCoordinator,
       loginUseCase: LoginUseCase,
       logoutUseCase: LogoutUseCase,
       saveLoginInfoUseCase: SaveLoginInfoUseCase) {
    self.coordinator = coordinator
    self.loginUseCase = loginUseCase
    self.logoutUseCase = logoutUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
    
    self.login()
  }
  
  // TODO: - 로그인 로직 뺄 것(차후 업데이트)
  func login() {
    self.loginUseCase.execute()
      .subscribe(onNext: { [weak self] loginInfo in
        if loginInfo.userIdx != -1 {
          self?.saveLoginInfoUseCase.execute(loginInfo: loginInfo, email: nil, password: nil)
        }
        self?.coordinator?.finishFlow?()
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
}
