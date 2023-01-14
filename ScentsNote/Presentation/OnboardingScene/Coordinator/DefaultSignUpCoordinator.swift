//
//  DefaultSignUpCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit

final class DefaultSignUpCoordinator: BaseCoordinator, SignUpCoordinator {
  
  var finishFlow: (() -> Void)?
  
  override init(_ navigationController: UINavigationController) {
    super.init(navigationController)
  }
  
  override func start() {
    self.showSignUpInformationViewController()
  }
  
  func showSignUpInformationViewController() {
    let vc = SignUpInformationViewController()
    vc.viewModel = SignUpInformationViewModel(
      coordinator: self,
      checkDuplcateEmailUseCase: DefaultCheckDuplcateEmailUseCase(userRepository: DefaultUserRepository.shared),
      checkDuplicateNicknameUseCase: DefaultCheckDuplicateNicknameUseCase(userRepository: DefaultUserRepository.shared)
    )
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showSignUpPasswordViewController(with signUpInfo: SignUpInfo) {
    let vc = SignUpPasswordViewController()
    vc.viewModel = SignUpPasswordViewModel(
      coordinator: self,
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showSignUpGenderViewController(with signUpInfo: SignUpInfo) {
    let vc = SignUpGenderViewController()
    vc.viewModel = SignUpGenderViewModel(
      coordinator: self,
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showSignUpBirthViewController(with signUpInfo: SignUpInfo) {
    let vc = SignUpBirthViewController()
    vc.viewModel = SignUpBirthViewModel(
      coordinator: self,
      signUpUseCase: DefaultSignUpUseCase(userRepository: DefaultUserRepository.shared),
      saveLoginInfoUseCase: DefaultSaveLoginInfoUseCase(userRepository: DefaultUserRepository.shared),
      signUpInfo: signUpInfo
    )
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showBirthPopupViewController(with birth: Int) {
    guard let pvc = self.navigationController.viewControllers.last as? SignUpBirthViewController else {
      return
    }
    
    let vc = BirthPopupViewController()
    vc.delegate = pvc
    vc.viewModel = BirthPopupViewModel(signCoordinator: self,
                                       birth: birth,
                                       from: .signUp)
    
    vc.modalPresentationStyle = .overFullScreen
    self.navigationController.present(vc, animated: false, completion: nil)
  }
  
  func hideBirthPopupViewController() {
    self.navigationController.dismiss(animated: false)
  }
  
}
