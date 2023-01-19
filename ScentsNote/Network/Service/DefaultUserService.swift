//
//  DefaultUserService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/22.
//

import Foundation
import RxSwift
import Moya

final class DefaultUserService: ScentsNoteService, UserService {
  
  static let shared: DefaultUserService = DefaultUserService()
  
  func login(email: String, password: String) -> Observable<LoginInfoResponseDTO> {
    return requestObject(.login(email: email, password: password))
  }
  
  func signUp(signUpInfo: SignUpInfo) -> Observable<LoginInfoResponseDTO> {
    requestObject(.signUp(signUpInfo: signUpInfo))
  }
  
  func checkDuplicateEmail(email: String) -> Observable<Bool> {
    requestObject(.checkDuplicateEmail(email: email))
  }
  
  func checkDuplicateNickname(nickname: String) -> Observable<Bool> {
    requestObject(.checkDuplicateNickname(nickname: nickname))
  }
  
  func registerSurvey(perfumeList: [Int], keywordList: [Int], seriesList: [Int]) -> Observable<String> {
    requestPlainObject(.registerSurvey(perfumeList: perfumeList, keywordList: keywordList, seriesList: seriesList))
  }
  
  func fetchPerfumesInMyPage(userIdx: Int) -> Observable<ListInfo<PerfumeInMyPageResponseDTO>> {
    requestObject(.fetchPerfumesInMyPage(userIdx: userIdx))
  }
  
  func updateUserInfo(userIdx: Int, userInfo: EditUserInfoRequestDTO) -> Observable<EditUserInfoResponseDTO> {
    requestObject(.updateUserInfo(userIdx: userIdx, userInfo: userInfo))
  }
  
  func changePassword(password: PasswordRequestDTO) -> Observable<String> {
    requestPlainObject(.changePassword(password: password))
  }
  
  func fetchReviewsInMyPage() -> Observable<[ReviewInMyPageResponseDTO]> {
    requestObject(.fetchReviewsInMyPage)
  }

}

