//
//  SignViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/16.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then



final class OnboardingViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: OnboardingViewModel!
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let backgroundView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = .imgBg
  }
  
  private let titleView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = .signLogo
  }
  
  private let loginButton = UIButton().then {
    $0.setTitle("로그인 하기", for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.backgroundColor = UIColor.blackText.cgColor
  }
  
  private let signInButton = UIButton().then {
    $0.setTitle("회원가입하기", for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.setTitleColor(.blackText, for: .normal)
    $0.layer.backgroundColor = UIColor.white.cgColor
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.setBackButton()
    self.view.backgroundColor = .black
    self.view.addSubview(self.backgroundView)
    self.backgroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.view.addSubview(self.titleView)
    self.titleView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.view.addSubview(self.signInButton)
    self.signInButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-31)
      $0.height.equalTo(52)
    }
    
    self.view.addSubview(self.loginButton)
    self.loginButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
      $0.bottom.equalTo(self.signInButton.snp.top).offset(-12)
      $0.height.equalTo(52)
    }
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.loginButton.rx.tap.asObservable()
      .bind(to: input.loginButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.signInButton.rx.tap.asObservable()
      .bind(to: input.signUpButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
}
