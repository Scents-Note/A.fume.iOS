//
//  MockUpdatePerfumeLikeUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/21.
//

import RxSwift
@testable import ScentsNote

final class MockUpdatePerfumeLikeUseCase: TestUseCase, UpdatePerfumeLikeUseCase {
  
  func execute(perfumeIdx: Int) -> Observable<Bool> {
    Observable.create { [unowned self] observer in
      if self.state == .success {
        observer.onNext(true)
      } else {
        observer.onError(self.error)
      }
      return Disposables.create()
    }
  }

}
