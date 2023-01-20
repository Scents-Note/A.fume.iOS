//
//  DefaultAuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import RxSwift
import Moya
import Then

final class DefaultUserRepository: UserRepository {
  
  static let shared = DefaultUserRepository(userService: DefaultUserService.shared, userDefaultsPersitenceService: DefaultUserDefaultsPersitenceService.shared)
  
  private let userService: UserService
  private let userDefaultsPersitenceService: UserDefaultsPersitenceService
  
  private init(userService: UserService, userDefaultsPersitenceService: UserDefaultsPersitenceService){
    self.userService = userService
    self.userDefaultsPersitenceService = userDefaultsPersitenceService
  }
  
  func login(email: String, password: String) -> Observable<LoginInfo> {
    return self.userService.login(email: email, password: password)
      .map { $0.toDomain() }
  }
  
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo> {
    return self.userService.signUp(signUpInfo: signUpInfo)
      .map { $0.toDomain() }
  }
  
  func checkDuplicateEmail(email: String) -> Observable<Bool> {
    return self.userService.checkDuplicateEmail(email: email)
  }
  
  func checkDuplicateNickname(nickname: String) -> Observable<Bool> {
    return self.userService.checkDuplicateNickname(nickname: nickname)
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<String> {
    return self.userService.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList)
  }
  
  func fetchPerfumesInMyPage(userIdx: Int) -> Observable<[PerfumeInMyPage]> {
    return self.userService.fetchPerfumesInMyPage(userIdx: userIdx)
      .map { $0.rows.map { $0.toDomain() } }
  }
  
  func updateUserInfo(userIdx: Int, userInfo: EditUserInfo) -> Observable<EditUserInfo> {
    let requestDTO = userInfo.toEntity()
    return self.userService.updateUserInfo(userIdx: userIdx, userInfo: requestDTO)
      .map { $0.toDomain() }
  }
  
  func changePassword(password: Password) -> Observable<String> {
    let requestDTO = password.toEntity()
    return self.userService.changePassword(password: requestDTO)
  }
  
  func fetchReviewsInMyPage() -> Observable<[ReviewInMyPage]> {
    self.userService.fetchReviewsInMyPage()
      .map { $0.map {$0.toDomain() }}
  }
  
  func fetchUserDefaults<T>(key: String) -> T? {
    let value: T? = self.userDefaultsPersitenceService.get(key: key)
    return value
  }
  
  func setUserDefault(key: String, value: Any?) {
    self.userDefaultsPersitenceService.set(key: key, value: value)
  }
  
  func removeUserDefault(key: String) {
    self.userDefaultsPersitenceService.remove(key: key)
  }
}

