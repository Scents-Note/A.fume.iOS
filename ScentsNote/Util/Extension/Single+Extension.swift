//
//  Single+Extension.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/23.
//

import RxSwift

extension Single {
  var asObservableResult: Observable<Result<Element, Error>> {
    return asObservable()
      .map { .success($0) }
      .catch { .just(.failure($0)) }
    
  }
}
