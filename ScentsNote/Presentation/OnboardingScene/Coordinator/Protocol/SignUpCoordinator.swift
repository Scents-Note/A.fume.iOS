//
//  SignUpCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/18.
//

import Foundation

protocol SignUpCoordinator: Coordinator {
  func showSignUpInformationViewController()
  func showSignUpPasswordViewController(with signUpInfo: SignUpInfo)
  func showSignUpGenderViewController(with signUpInfo: SignUpInfo)
  func showSignUpBirthViewController(with signUpInfo: SignUpInfo)
}
