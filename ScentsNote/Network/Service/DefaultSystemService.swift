//
//  DefaultSystemService.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/02/08.
//

import RxSwift

final class DefaultSystemService: ScentsNoteService, SystemService {
  
  static let shared: DefaultSystemService = DefaultSystemService()
  private override init() {}

  func checkIsSupportableVersion(apkVersion: String) -> Observable<Bool> {
    requestObject(.checkIsSupportableVersion(apkVersion: apkVersion))
  }
}
