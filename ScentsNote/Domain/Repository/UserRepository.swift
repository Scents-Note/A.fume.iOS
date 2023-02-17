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
  
  // MARK: - SignUp
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfo>
  func checkDuplicateEmail(email: String) -> Observable<Bool>
  func checkDuplicateNickname(nickname: String) -> Observable<Bool>
  
  // MARK: - Survey
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<String>

  // MARK: - My Page
  func fetchPerfumesInMyPage(userIdx: Int) -> Observable<[PerfumeInMyPage]>
  func updateUserInfo(userIdx: Int, userInfo: EditUserInfo) -> Observable<EditUserInfo>
  func changePassword(password: Password) -> Observable<String>

  // MARK: - Review
  func fetchReviewsInMyPage() -> Observable<[ReviewInMyPage]>
  
  // MARK: - User Default
  func fetchUserDefaults<T>(key: String) -> T?
  func setUserDefault(key: String, value: Any?)
  func removeUserDefault(key: String)

}

