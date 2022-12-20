//
//  FetchReviewsInMyPageUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/06.
//

import RxSwift

final class FetchReviewsInMyPageUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute() -> Observable<[[ReviewInMyPage]]> {
    return self.userRepository.fetchReviewsInMyPage()
      .map { $0.division(by: 3) }
  }
}
