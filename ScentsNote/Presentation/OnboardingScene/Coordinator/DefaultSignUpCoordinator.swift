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
  
  override init(_ navigationController: UINavigationController) {
    self.userRepository = DefaultUserRepository(userService: DefaultUserService())
    super.init(navigationController)
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
  
  func showBirthPopupViewController(with birth: Int) {
    guard let viewController = self.navigationController.viewControllers.last as? SignUpBirthViewController else {
        return
    }

    let birthPopupViewController = BirthPopupViewController()
    birthPopupViewController.delegate = viewController
    birthPopupViewController.viewModel = BirthPopupViewModel(signCoordinator: self,
                                                             birth: birth,
                                                             from: .signUp)
    
    birthPopupViewController.modalPresentationStyle = .overFullScreen
    self.navigationController.present(birthPopupViewController, animated: false, completion: nil)
  }

  func hideBirthPopupViewController() {
    self.navigationController.dismiss(animated: false)
  }

}
