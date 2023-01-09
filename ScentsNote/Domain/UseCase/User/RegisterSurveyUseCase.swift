//
//  RegisterSurveyUseCase.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/20.
//

import RxSwift

final class RegisterSurveyUseCase {
  private let userRepository: UserRepository
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func execute(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<String> {
    self.userRepository.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList)
  }
}
