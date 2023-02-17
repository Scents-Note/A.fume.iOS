//
//  UpdateUserInformationUseCaseTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/15.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote_Dev

final class UpdateUserInformationUseCaseTest: XCTestCase {
  
  private var updateUserInformationUseCase: UpdateUserInformationUseCase!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.scheduler = TestScheduler(initialClock: 0)
    self.updateUserInformationUseCase = DefaultUpdateUserInformationUseCase(userRepository: MockUserRepository())
    self.disposeBag = DisposeBag()
    
  }
  
  override func tearDownWithError() throws {
    self.scheduler = nil
    self.updateUserInformationUseCase = nil
    self.disposeBag = nil
  }
  
  func testExecute_UpdateUserInformation() throws {
    
    // Given
    let editUserInfo = EditUserInfo(nickname: "득연", gender: "남", birth: 1995)

    // When
    let userInfoObserver = self.scheduler.createObserver(EditUserInfo.self)
    self.scheduler.createColdObservable([
      .next(10, ())
    ])
    .subscribe(onNext: { [weak self] in
      self?.updateUserInformationUseCase.execute(userInfo: editUserInfo)
        .subscribe(userInfoObserver)
        .disposed(by: self?.disposeBag ?? DisposeBag())
    })
    .disposed(by: self.disposeBag)

    // Then
    self.scheduler.start()
    XCTAssertEqual(userInfoObserver.events, [.next(10, editUserInfo)])
    
  }
  
}

