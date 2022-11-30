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
    let userIdx = self.userRepository.fetchUserIdx() ?? 0
    let token = self.userRepository.fetchUserToken() ?? ""
    Log(userIdx)
    Log(token)
    return self.userRepository.fetchPerfumesLiked(userIdx: userIdx)
  }
}
