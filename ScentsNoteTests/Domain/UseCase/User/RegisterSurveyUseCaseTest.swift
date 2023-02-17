//
//  RegisterSurveyUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class RegisterSurveyUseCaseTest: XCTestCase {
  
  private var registerSurveyUseCase: RegisterSurveyUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.registerSurveyUseCase = DefaultRegisterSurveyUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.registerSurveyUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let perfumes: [Int] = []
    let keywords: [Int] = []
    let series: [Int] = []
    let expected = "등록에 성공하였습니다."
    
    // When
    let stringObserver = self.scheduler.createObserver(String.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.registerSurveyUseCase.execute(perfumeList: perfumes, keywordList: keywords, seriesList: series)
        .subscribe(stringObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(stringObserver.events, [.next(10, expected)])
  }
}
