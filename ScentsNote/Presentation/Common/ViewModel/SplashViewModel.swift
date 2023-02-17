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
  private let checkIsSupportableVersionUseCase: CheckIsSupportableVersionUseCase
  private let loginUseCase: LoginUseCase
  private let logoutUseCase: LogoutUseCase
  private let saveLoginInfoUseCase: SaveLoginInfoUseCase
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  init(coordinator: SplashCoordinator,
       checkIsSupportableVersionUseCase: CheckIsSupportableVersionUseCase,
       loginUseCase: LoginUseCase,
       logoutUseCase: LogoutUseCase,
       saveLoginInfoUseCase: SaveLoginInfoUseCase) {
    self.coordinator = coordinator
    self.checkIsSupportableVersionUseCase = checkIsSupportableVersionUseCase
    self.loginUseCase = loginUseCase
    self.logoutUseCase = logoutUseCase
    self.saveLoginInfoUseCase = saveLoginInfoUseCase
  }
  
  // TODO: - 로그인 로직 뺄 것(차후 업데이트)
  func checkVersion() {
    self.checkIsSupportableVersionUseCase.excute()
      .subscribe(onNext: { [weak self] isSupportableFetched in
        Log(isSupportableFetched)
        if isSupportableFetched { self?.login() }
        else { self?.showUpdatePopup() }
      }, onError: { error in
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
  
  func login() {
    self.loginUseCase.execute()
      .subscribe(onNext: { [weak self] loginInfo in
        if loginInfo.userIdx != -1 {
          self?.saveLoginInfoUseCase.execute(loginInfo: loginInfo, email: nil, password: nil)
        }
        self?.coordinator?.finishFlow?()
      }, onError: { [weak self] error in
        self?.coordinator?.finishFlow?()
        Log(error)
      })
      .disposed(by: self.disposeBag)
  }
  
  func showUpdatePopup() {
    self.coordinator?.showPopup()
  }
  
  func showAppStore() {
    let url = "itms-apps://itunes.apple.com/app/1662803361"
    if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}

extension SplashViewModel: LabelPopupDelegate {
  func confirm() {
    self.showAppStore()
  }
}
