//
//  FetchPerfumesLikedUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import RxSwift

final class FetchPerfumesLikedUseCase {
  private let userRepository: UserRepository
  private let disposeBag = DisposeBag()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() -> Observable<[PerfumeLiked]> {
    let userIdx = self.userRepository.fetchUserDefaults(key: UserDefaultKey.userIdx) ?? 0
    return self.userRepository.fetchPerfumesLiked(userIdx: userIdx)
  }
}
