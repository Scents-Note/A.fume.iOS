//
//  SignUpBirthViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class SignUpBirthViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: SignUpBirthViewModel!
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let container = UIView()
  private let titleLabel = UILabel().then {
    $0.text = "출생연도를 선택해주세요."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 14)
  }
  
  private let birthButton = UIButton().then {
    $0.setTitle("1990", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .nanumMyeongjo(type: .extraBold, size: 22)
    $0.layer.cornerRadius = 2
    $0.backgroundColor = .pointBeige
  }
  
  private let doneButton = DoneButton(title: "가입 완료")
  
  //MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    self.setNavigationTitle(title: "회원가입")
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.backgroundColor = .white
    self.setBackButton()
    
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(20)
    }
    
    self.container.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32)
      $0.left.equalToSuperview()
    }
    
    self.container.addSubview(self.birthButton)
    self.birthButton.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(13)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.view.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.height.equalTo(86)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.birthButton.rx.tap
      .bind(to: input.birthButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.doneButton.rx.tap
      .bind(to: input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    output.birth
      .asDriver()
      .drive(onNext: { [weak self] birth in
        self?.birthButton.setTitle(String(birth), for: .normal)
      })
      .disposed(by: self.disposeBag)
  }
}


