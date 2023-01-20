//
//  MyPageMenuViewModelTest.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/20.
//

import XCTest
import RxSwift
import RxTest
@testable import ScentsNote

final class MyPageMenuViewModelTest: XCTestCase {
  private var coordinator: MyPageCoordinator!
  private var fetchUserDefaultUseCase: FetchUserDefaultUseCase!
  private var logoutUseCase: LogoutUseCase!
  private var viewModel: MyPageMenuViewModel!
  private var input: MyPageMenuViewModel.Input!
  private var output: MyPageMenuViewModel.Output!
  private var disposeBag: DisposeBag!
  private var scheduler: TestScheduler!
  
  override func setUpWithError() throws {
    self.coordinator = MockMyPageCoordinator()
    self.fetchUserDefaultUseCase = MockFetchUserDefaultUseCase()
    self.logoutUseCase = MockLogoutUseCase()
    
    self.viewModel = MyPageMenuViewModel(coordinator: self.coordinator,
                                         fetchUserDefaultUseCase: self.fetchUserDefaultUseCase,
                                         logoutUseCase: self.logoutUseCase)
    self.input = self.viewModel.input
    self.output = self.viewModel.output
    self.disposeBag = DisposeBag()
    self.scheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDownWithError() throws {
    self.coordinator = nil
    self.fetchUserDefaultUseCase = nil
    self.logoutUseCase = nil
    self.viewModel = nil
    self.input = nil
    self.output = nil
    self.disposeBag = nil
    self.scheduler = nil
  }
  
  func testTransform_clickEditInfoMenu_runEditInfo() throws {
    
    // Given
    let loadMenuObservable = self.scheduler.createHotObservable([.next(10, ())])
    let menuCellTapObservable = self.scheduler.createHotObservable([.next(20, 0)])
    
    let expected = 1
    
    // When
    loadMenuObservable
      .bind(to: self.input.loadMenuEvent)
      .disposed(by: self.disposeBag)
    
    menuCellTapObservable
      .bind(to: self.input.menuCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runEditInfoFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickChangePWMenu_runChangePW() throws {
    
    // Given
    let loadMenuObservable = self.scheduler.createHotObservable([.next(10, ())])
    let menuCellTapObservable = self.scheduler.createHotObservable([.next(20, 1)])
    
    let expected = 1
    
    // When
    loadMenuObservable
      .bind(to: self.input.loadMenuEvent)
      .disposed(by: self.disposeBag)
    
    menuCellTapObservable
      .bind(to: self.input.menuCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runChangePasswordFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickReportMenu_runWeb() throws {
    
    // Given
    let loadMenuObservable = self.scheduler.createHotObservable([.next(10, ())])
    let menuCellTapObservable = self.scheduler.createHotObservable([.next(20, 2)])
    
    let expected = 1
    
    // When
    loadMenuObservable
      .bind(to: self.input.loadMenuEvent)
      .disposed(by: self.disposeBag)
    
    menuCellTapObservable
      .bind(to: self.input.menuCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runWebFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickInquireMenu_runWeb() throws {
    
    // Given
    let loadMenuObservable = self.scheduler.createHotObservable([.next(10, ())])
    let menuCellTapObservable = self.scheduler.createHotObservable([.next(20, 3)])
    
    let expected = 1
    
    // When
    loadMenuObservable
      .bind(to: self.input.loadMenuEvent)
      .disposed(by: self.disposeBag)
    
    menuCellTapObservable
      .bind(to: self.input.menuCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runWebFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  // Login -> Logout Menu 리스트 업데이트
  func testTransform_clickLogoutMenu_updateMenus() throws {
    
    // Given
    let loadMenuObservable = self.scheduler.createHotObservable([.next(10, ())])
    let menuCellTapObservable = self.scheduler.createHotObservable([.next(20, 4)])
    let menuObserver = self.scheduler.createObserver([String].self)
    
    // 20보다 조금 먼저 일어나야 하므로
    self.scheduler.scheduleAt(19) {
      (self.fetchUserDefaultUseCase as! MockFetchUserDefaultUseCase).updateMock(false)
    }
    
    let expectedWhenLogin = Menu.loggedIn
    let expectedwhenLogout = Menu.loggedOut
    
    // When
    loadMenuObservable
      .bind(to: self.input.loadMenuEvent)
      .disposed(by: self.disposeBag)
    
    menuCellTapObservable
      .bind(to: self.input.menuCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.output.menus
      .subscribe(menuObserver)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    XCTAssertEqual(self.viewModel.menus, expectedwhenLogout)
    XCTAssertEqual(menuObserver.events, [.next(0, []),
                                         .next(10, expectedWhenLogin.map { $0.description } ),
                                         .next(20, expectedwhenLogout.map { $0.description } )])
  }
  
  func testTransform_clickLoginMenu_runWeb() throws {
    
    // Given
    let loadMenuObservable = self.scheduler.createHotObservable([.next(10, ())])
    let menuCellTapObservable = self.scheduler.createHotObservable([.next(20, 0)])
    
    let expected = 1
    
    (self.fetchUserDefaultUseCase as! MockFetchUserDefaultUseCase).updateMock(false)
    // When
    loadMenuObservable
      .bind(to: self.input.loadMenuEvent)
      .disposed(by: self.disposeBag)
    
    menuCellTapObservable
      .bind(to: self.input.menuCellDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).runOnboardingFlowCalledCount
    XCTAssertEqual(actual, expected)
  }
  
  func testTransform_clickCloseButton_hideMenu() throws {
    
    // Given
    let closeButtonObservable = self.scheduler.createHotObservable([.next(20, ())])
    let expected = 1
    // When
    closeButtonObservable
      .bind(to: self.input.closeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.scheduler.start()
    
    // Then
    let actual = (self.coordinator as! MockMyPageCoordinator).hideMyPageMenuViewControllerCalledCount
    XCTAssertEqual(actual, expected)
  }
  
}
