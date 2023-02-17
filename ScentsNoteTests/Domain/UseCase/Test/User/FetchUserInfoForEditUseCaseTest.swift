//
//  FetchUserInfoForEditUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class FetchUserInfoForEditUseCaseTest: XCTestCase {
  
  private var fetchUserInfoForEditUseCase: FetchUserInfoForEditUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.fetchUserInfoForEditUseCase = DefaultFetchUserInfoForEditUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.fetchUserInfoForEditUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_fetchUserInfoForEdit() throws {
    
    // Given
    let editUserInfo = EditUserInfo(nickname: "득연", gender: "MAN", birth: 1995)
    
    // When
    let perfumesObserver = self.scheduler.createObserver(EditUserInfo.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.fetchUserInfoForEditUseCase.execute()
        .subscribe(perfumesObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(perfumesObserver.events, [.next(10, editUserInfo), .completed(10)])
    
  }
}
