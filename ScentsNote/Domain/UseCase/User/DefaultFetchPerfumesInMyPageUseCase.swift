//
//  DefaultFetchPerfumesInMyPageUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import RxSwift

protocol FetchPerfumesInMyPageUseCase {
  func execute() -> Observable<[PerfumeInMyPage]>
}

final class DefaultFetchPerfumesInMyPageUseCase: FetchPerfumesInMyPageUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() -> Observable<[PerfumeInMyPage]> {
    let userIdx = self.userRepository.fetchUserDefaults(key: UserDefaultKey.userIdx) ?? 0
    return self.userRepository.fetchPerfumesInMyPage(userIdx: userIdx)
  }
}
