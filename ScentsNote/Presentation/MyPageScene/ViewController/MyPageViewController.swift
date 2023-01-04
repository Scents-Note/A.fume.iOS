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
  
  private lazy var menuButton = UIBarButtonItem(image: .btnSidebar, style: .plain, target: self, action: nil).then {
    $0.tintColor = .blackText
  }
  private lazy var tabView = Tabview(buttons: [self.myPerfumeButton, self.wishListButton], highlight: self.highlightView)
  private lazy var scrollView = MyPageScrollView(viewModel: self.viewModel)
  
  // MARK: - Vars & Lets
  var viewModel: MyPageViewModel!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureDelegate()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  func configureUI() {
    self.configureNavigation()
    
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
  
  func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "마이")
    self.navigationItem.rightBarButtonItem = self.menuButton
  }
  
  private func configureDelegate() {
    self.scrollView.delegate = self
  }
  
  private func bindViewModel() {
    let input = MyPageViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
                                      myPerfumeButtonDidTapEvent: self.myPerfumeButton.rx.tap.asObservable(),
                                      wishListButtonDidTapEvent: self.wishListButton.rx.tap.asObservable(),
                                      loginButtonDidTapEvent: self.loginButton.rx.tap.asObservable(),
                                      menuButtonDidTapEvent: self.menuButton.rx.tap.asObservable())
    
    self.viewModel.transform(input: input, disposeBag: self.disposeBag)
    let output = self.viewModel.output
    
    self.bindTab(output: output)
  }
  
  private func bindTab(output: MyPageViewModel.Output) {
    output.selectedTab
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] idx in
        self?.updateTab(idx)
        self?.updateHighLight(idx)
        self?.updatePage(idx)
      })
      .disposed(by: self.disposeBag)
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
  
  
  
  private func updateHighLight(_ idx: Int) {
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.highlightView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * CGFloat(idx) / 2, y: 0)
      self?.highlightView.layoutIfNeeded()
    }
  }
  
  private func updatePage(_ idx: Int) {
    self.scrollView.updatePage(idx)
  }
}

extension MyPageViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let scrollView = (scrollView as? MyPageScrollView) else { return }
    self.highlightView.transform = CGAffineTransform(translationX: scrollView.contentOffset.x / 2, y: 0)
    self.highlightView.layoutIfNeeded()
    self.updateTab(scrollView.contentOffset.x > UIScreen.main.bounds.width / 2 ? 1 : 0)
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let _ = (scrollView as? MyPageScrollView) else { return }
  }
}
