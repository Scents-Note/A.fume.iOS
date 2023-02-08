//
//  SystemService.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/02/08.
//

import RxSwift

protocol SystemService {
  func checkIsSupportableVersion(apkVersion: String) -> Observable<Bool>
}
