//
//  DefaultCheckIsSupportableVersionUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/02/08.
//

import RxSwift

protocol CheckIsSupportableVersionUseCase {
  func excute() -> Observable<Bool>
}

final class DefaultCheckIsSupportableVersionUseCase: CheckIsSupportableVersionUseCase {
  
  private let systemRepository: SystemRepository
  
  init(systemRepository: SystemRepository) {
    self.systemRepository = systemRepository
  }
  
  func excute() -> Observable<Bool> {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    return self.systemRepository.checkIsSupportableVersion(apkVersion: appVersion)
  }
}
