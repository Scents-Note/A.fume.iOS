//
//  MypageViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import RxSwift
import RxCocoa

import UIKit
import SnapKit
import Then

final class MyPageViewController: UIViewController {
  var viewModel: MyPageViewModel?
  let disposeBag = DisposeBag()
  
  private let myPerfumeButton = UIButton().then {
    $0.setTitle("마이 퍼퓸", for: .normal)
  }
  
  private let wishListButton = UIButton().then {
    $0.setTitle("위시 리스트", for: .normal)
  }
  
  private lazy var tabStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    
    $0.addArrangedSubview(self.myPerfumeButton)
    $0.addArrangedSubview(self.wishListButton)
  }
  
  
  private let dividerView = UIView().then {
    $0.backgroundColor = .grayCd
  }
  
  private let highlightView = UIView().then {
    $0.backgroundColor = .black
  }
  
  private let loginButton = UIButton().then {
    $0.setTitle("로그인 하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.backgroundColor = .blackText
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    self.view.backgroundColor = .white
    self.setBackButton()
    self.setNavigationTitle(title: "마이")
  }
  
}

extension MyPageViewController {
  
  func configureUI() {
    self.view.addSubview(self.tabStackView)
    self.tabStackView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.view.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.top.equalTo(self.tabStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.view.addSubview(self.highlightView)
    self.highlightView.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width / 2)
      $0.bottom.equalTo(self.dividerView)
      $0.height.equalTo(4)
    }
    
    self.view.addSubview(self.loginButton)
    self.loginButton.snp.makeConstraints {
      $0.top.equalTo(self.dividerView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func updateTab(_ idx: Int) {
    self.myPerfumeButton.do {
      $0.titleLabel?.font = .notoSans(type: idx == 0 ? .bold : .regular, size: 14)
      $0.setTitleColor(idx == 0 ? .blackText : .darkGray7d, for: .normal)
    }
    
    self.wishListButton.do {
      $0.titleLabel?.font = .notoSans(type: idx == 1 ? .bold : .regular, size: 14)
      $0.setTitleColor(idx == 1 ? .blackText : .darkGray7d, for: .normal)
    }
  }
  
//  func updatePage(_ idx: Int) {
//    self.surveyScrollView.updatePage(idx)
//  }
}

extension MyPageViewController {
  private func bindViewModel() {
    let input = MyPageViewModel.Input(
      loginButtonDidTapEvent: self.loginButton.rx.tap.asObservable()
    )
    let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
    
    self.bindTab(output: output)
  }
  
  private func bindTab(output: MyPageViewModel.Output?) {
    output?.selectedTab
      .subscribe(onNext: { [weak self] idx in
        self?.updateTab(idx)
      })
      .disposed(by: self.disposeBag)
  }
}
