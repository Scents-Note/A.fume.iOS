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
  private let saveLoginInfo: SaveLoginInfo
  
  // MARK: - Life Cycle
  init(coordinator: SplashCoordinator, loginUseCase: LoginUseCase, saveLoginInfo: SaveLoginInfo) {
    self.coordinator = coordinator
    self.loginUseCase = loginUseCase
    self.saveLoginInfo = saveLoginInfo
  }
  
  
  // MARK: - Binding
  func transform(disposeBag: DisposeBag) {
    self.loginUseCase.execute()
      .subscribe(onNext: { [weak self] loginInfo in
        if loginInfo.userIdx != -1 {
          self?.saveLoginInfo.execute(loginInfo: loginInfo)
        }
        self?.coordinator?.finishFlow?()
      }, onError: { error in
        Log(error)
      })
      .disposed(by: disposeBag)
  }
}
