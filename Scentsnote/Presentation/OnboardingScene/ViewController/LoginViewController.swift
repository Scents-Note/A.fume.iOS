//
//  LoginViewController.swift
//  Scentsnote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

import RxSwift
import SnapKit

final class LoginViewController: ViewController {
  
  private var disposeBag = DisposeBag()
  var viewModel: LoginViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    self.navigationItem.titleView = self.navigationController?.setNavigationTitle(title: "로그인")

    
  }
}

