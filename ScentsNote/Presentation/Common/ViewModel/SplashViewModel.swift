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
  weak var coordinator: SplashCoordinator?
  private let loginUseCase: LoginUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  
  // MARK: - Life Cycle
  init(coordinator: SplashCoordinator, loginUseCase: LoginUseCase, saveLoginInfoUseCase: SaveLoginInfoUseCase) {
    self.coordinator = coordinator
    self.loginUseCase = loginUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
  }
  
  
  // MARK: - Binding
  // TODO: - 로그인 로직 뺄 것(차후 업데이트)
  func transform(disposeBag: DisposeBag) {
    self.loginUseCase.execute()
      .subscribe(onNext: { [weak self] loginInfo in
        if loginInfo.userIdx != -1 {
          Log(loginInfo.token)
          self?.saveLoginInfoUseCase.execute(loginInfo: loginInfo)
        }
        self?.coordinator?.finishFlow?()
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
  }
}
