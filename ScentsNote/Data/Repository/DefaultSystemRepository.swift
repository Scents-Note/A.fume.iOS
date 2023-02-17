//
//  DefaultSystemRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/02/08.
//

import RxSwift

final class DefaultSystemRepository: SystemRepository {
  
  static let shared = DefaultSystemRepository(systemService: DefaultSystemService.shared)
  private let systemService: SystemService
  private init(systemService: SystemService) {
    self.systemService = systemService
  }
  
  func checkIsSupportableVersion(apkVersion: String) -> Observable<Bool> {
    self.systemService.checkIsSupportableVersion(apkVersion: apkVersion)
  }
}
