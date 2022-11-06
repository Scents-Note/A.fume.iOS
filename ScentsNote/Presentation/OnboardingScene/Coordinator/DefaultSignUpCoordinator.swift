//
//  DefaultSignUpCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit

final class DefaultSignUpCoordinator: BaseCoordinator, SignUpCoordinator {
  
  var finishFlow: (() -> Void)?
  var userRepository: UserRepository
  var navigationController: UINavigationController
  
  init(_ navigationContoller: UINavigationController) {
    self.navigationController = navigationContoller
    self.userRepository = DefaultUserRepository(userService: DefaultUserService())
  }
  
  override func start() {
    self.showSignUpInformationViewController()
  }
  
  func showSignUpInformationViewController() {
    let signUpInformationViewController = SignUpInformationViewController()
    signUpInformationViewController.viewModel = SignUpInformationViewModel(
      coordinator: self,
      userRepository: userRepository
    )
    self.navigationController.pushViewController(signUpInformationViewController, animated: true)
  }
  
  func showSignUpPasswordViewController(with signUpInfo: SignUpInfo) {
    let signUpPasswordViewController = SignUpPasswordViewController()
    signUpPasswordViewController.viewModel = SignUpPasswordViewModel(
      coordinator: self,
      userRepository: userRepository,
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(signUpPasswordViewController, animated: true)
  }
  
  func showSignUpGenderViewController(with signUpInfo: SignUpInfo) {
    let signUpGenderViewController = SignUpGenderViewController()
    signUpGenderViewController.viewModel = SignUpGenderViewModel(
      coordinator: self,
      userRepository: userRepository,
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(signUpGenderViewController, animated: true)
  }
  
  func showSignUpBirthViewController(with signUpInfo: SignUpInfo) {
    let signUpBirthViewController = SignUpBirthViewController()
    signUpBirthViewController.viewModel = SignUpBirthViewModel(
      coordinator: self,
      userRepository: userRepository,
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(signUpBirthViewController, animated: true)
  }
  
  func showBirthPopupViewController(with birth: String) {
    guard let viewController = self.navigationController.viewControllers.last as? SignUpBirthViewController else {
        return
    }

    let birthPopupViewController = BirthPopupViewController()
    birthPopupViewController.delegate = viewController
    birthPopupViewController.viewModel = BirthPopupViewModel(
      coordinator: self,
      birth: birth
    )
    birthPopupViewController.modalPresentationStyle = .overFullScreen
    self.navigationController.present(birthPopupViewController, animated: false, completion: nil)
  }

  func hideBirthPopupViewController(with birth: String) {
    self.navigationController.dismiss(animated: false)
  }

}
