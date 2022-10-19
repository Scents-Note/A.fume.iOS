//
//  SignUpViewController.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/18.
//

import UIKit
import RxSwift

final class SignUpViewController: ViewController {
  
  private var disposeBag = DisposeBag()
  var viewModel: SignUpViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
}

extension SignUpViewController {
  func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.setBackButton()
    self.setNavigationTitle(title: "회원가입")
  }
}
