//
//  ChangePasswordViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ChangePasswordViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: ChangePasswordViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let passwordCurrentSection = CommonInputSection(title: "현재 비밀번호를 입력해주세요.", placeholder: "4자리 이상 입력해주세요.").then {
    $0.setSecurityType()
    $0.configureButton(title: "본인확인")
    $0.configureWarningLabel()
  }
  private let passwordSection = CommonInputSection(title: "변경할 비밀번호를 입력해주세요.", placeholder: "4자리 이상 입력해주세요.").then {
    $0.setSecurityType()
    $0.configureWarningLabel()
  }
  private let passwordCheckSection = CommonInputSection(title: "위의 비밀번호를 다시 한 번 입력해주세요.", placeholder: "틀리지 않도록 주의해주세요.").then {
    $0.setSecurityType()
    $0.configureWarningLabel()
  }
  
  private let doneButton = DoneButton(title: "수정 완료")
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.passwordCurrentSection)
    self.passwordCurrentSection.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(31)
      $0.left.right.equalToSuperview().inset(32)
    }
    
    self.view.addSubview(self.passwordSection)
    self.passwordSection.snp.makeConstraints {
      $0.top.equalTo(self.passwordCurrentSection.snp.bottom).offset(24)
      $0.left.right.equalToSuperview().inset(32)
    }
    
    self.view.addSubview(self.passwordCheckSection)
    self.passwordCheckSection.snp.makeConstraints {
      $0.top.equalTo(self.passwordSection.snp.bottom).offset(24)
      $0.left.right.equalToSuperview().inset(32)
    }
    self.passwordSection.isHidden = true
    self.passwordCheckSection.isHidden = true
    
    self.view.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(86)
    }
  }
  
  private func configureNavigation() {
    self.setNavigationTitle(title: "비밀번호 변경")
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.passwordCurrentSection.editText()
      .bind(to: input.passwordCurrentDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.passwordCurrentSection.clickCheckButton()
      .bind(to: input.passwordCurrentCheckButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.passwordSection.editText()
      .bind(to: input.passwordDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.passwordCheckSection.editText()
      .bind(to: input.passwordCheckDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.doneButton.rx.tap
      .bind(to: input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    self.bindPasswordCurrent(output: output)
    self.bindPassword(output: output)
    self.bindPasswordCheck(output: output)
    self.bindDoneButton(output: output)
  }
  
  private func bindPasswordCurrent(output: ChangePasswordViewModel.Output?) {
    output?.passwordCurrentState
      .subscribe(onNext: { [weak self] state in
        self?.passwordCurrentSection.updateUI(type: .passwordCurrent, state: state)
        self?.updateNewPasswordSection(state: state)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindPassword(output: ChangePasswordViewModel.Output?) {
    output?.passwordState
      .subscribe(onNext: { [weak self] state in
        self?.passwordSection.updateUI(type: .password, state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindPasswordCheck(output: ChangePasswordViewModel.Output?) {
    output?.passwordCheckState
      .subscribe(onNext: { [weak self] state in
        self?.passwordCheckSection.updateUI(type: .passwordCheck, state: state)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindDoneButton(output: ChangePasswordViewModel.Output?) {
    output?.canDone
      .subscribe(onNext: { [weak self] canDone in
        self?.doneButton.isHidden = !canDone
      })
      .disposed(by: self.disposeBag)
  }
  
  private func updateNewPasswordSection(state: InputState) {
    guard self.viewModel.isNewPasswordSectionShown == false else { return }
    
    if state == .success {
      self.viewModel.toggleNewPasswordShown()
      self.passwordSection.isHidden = false
      self.passwordCheckSection.isHidden = false
    }
  }
}
