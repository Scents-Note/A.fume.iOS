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
  
  // MARK: - UI
  private let myPerfumeButton = UIButton().then {
    $0.setTitle("마이 퍼퓸", for: .normal)
  }
  
  private let wishListButton = UIButton().then {
    $0.setTitle("위시 리스트", for: .normal)
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
  
  private lazy var menuButton = UIBarButtonItem(image: .checkmark, style: .plain, target: self, action: nil)
  private lazy var tabView = Tabview(buttons: [self.myPerfumeButton, self.wishListButton], highlight: self.highlightView)
  private lazy var scrollView = MyPageScrollView(viewModel: self.viewModel)
  
  // MARK: - Vars & Lets
  var viewModel: MyPageViewModel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureNavigation()
    self.configureUI()
    self.configureDelegate()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    
  }
  
  func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "마이")
    self.navigationItem.rightBarButtonItem = self.menuButton
  }
  
  func configureUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(self.tabView)
    self.tabView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.view.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints {
      $0.top.equalTo(self.tabView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
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
  
  
  private func bindViewModel() {
    self.viewModel.transform(disposeBag: self.disposeBag)
    let input = self.viewModel.input
    let output = self.viewModel.output
    
    self.bindUI(input: input)
    self.bindTab(output: output)
  }
  
  private func bindUI(input: MyPageViewModel.Input) {
    self.loginButton.rx.tap.asObservable()
      .subscribe(onNext: {
        input.loginButtonDidTapEvent.accept(())
      })
      .disposed(by: self.disposeBag)
    
    self.menuButton.rx.tap.asObservable()
      .subscribe(onNext: {
        input.menuButtonDidTapEvent.accept(())
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindTab(output: MyPageViewModel.Output) {
    output.selectedTab
      .subscribe(onNext: { [weak self] idx in
        self?.updateTab(idx)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func configureDelegate() {
    self.scrollView.delegate = self
  }
}

extension MyPageViewController: UIScrollViewDelegate {
  
  func isScrollViewHorizontalDragging() -> Bool {
    return self.scrollView.contentOffset.x.remainder(dividingBy: self.scrollView.frame.width) == 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let scrollView = (scrollView as? MyPageScrollView) else { return }
    
    UIView.animate(withDuration: 0.1) { [weak self] in
      self?.highlightView.transform = CGAffineTransform(translationX: scrollView.contentOffset.x / 2, y: 0)
      self?.highlightView.layoutIfNeeded()
    }
    
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let _ = (scrollView as? MyPageScrollView) else { return }
    
    let index = Int(targetContentOffset.pointee.x / self.view.frame.width)
//    self.viewModel.selectedTab.accept(index)
  }
}
