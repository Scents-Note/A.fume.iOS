//
//  LoginViewController.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

import RxSwift

final class LoginViewController: ViewController {
  
  private var disposeBag = DisposeBag()
  var viewModel: LoginViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    self.configureNavigation()
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.navigationController?.setNavigationBarHidden(false, animated: animated)
//  }
}

extension LoginViewController {
  private func configureNavigation() {
    let backBarButtonItem = UIBarButtonItem(title: "로그인", style: .plain, target: nil, action: nil)
    let backImage = UIImage(named: "btnBack")
    backBarButtonItem.image = backImage
    backBarButtonItem.tintColor = .blackText
    self.navigationItem.backBarButtonItem = backBarButtonItem
  }
}
