//
//  AuthRepository.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import Foundation
import RxSwift
import Moya

protocol UserRepository {
  
  // MARK: - Login
  func login(email: String, password: String) -> Observable<LoginInfo>
  func saveLoginInfo(loginInfo: LoginInfo)
  
  // MARK: - SignUp
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo>
  func checkDuplicateEmail(email: String) -> Observable<Bool>
  func checkDuplicateNickname(nickname: String) -> Observable<Bool>
  
  // MARK: - Survey
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<Bool>

  // MARK: - My Page
  func fetchPerfumesInMyPage(userIdx: Int) -> Observable<[PerfumeInMyPage]>
  func updateUserInfo(userIdx: Int, userInfo: UserInfo) -> Observable<UserInfo>
  func changePassword(password: Password) -> Observable<String>

  func fetchUserDefaults<T>(key: String) -> T?
  func saveUserInfo(userInfo: UserInfo)
  func savePassword(password: String)
  
//  func clearUserInfo()
  
  // MAKR: - Review
  func fetchReviewsInMyPage() -> Observable<[ReviewInMyPage]>
}

