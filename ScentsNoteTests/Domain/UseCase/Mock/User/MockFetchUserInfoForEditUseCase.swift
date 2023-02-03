//
//  MockFetchUserInfoForEditUseCase.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import RxSwift
@testable import ScentsNote

final class MockFetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase {
  
  let editUserInfo = EditUserInfo(nickname: "득연", gender: "MAN", birth: 1995)
  
  func execute() -> Observable<EditUserInfo> {
    Observable.create { [unowned self] observer in
      observer.onNext(self.editUserInfo)
      return Disposables.create()
    }
  }
  
}
