//
//  SearchFilterViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SearchFilterViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: SearchFilterViewModel!
  let disposeBag = DisposeBag()

  // MARK: - UI
  private lazy var tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.tabCompositionalLayout()).then {
    $0.backgroundColor = .white
    $0.register(TabCell.self)
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .grayCd }
  private let highlightView = UIView().then { $0.backgroundColor = .black }
  private lazy var filterScrollView = FilterScrollView(viewModel: self.viewModel)

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
    self.view.backgroundColor = .white
    self.configureNavigation()
    
    self.view.addSubview(self.tabCollectionView)
    self.tabCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    self.view.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.bottom.equalTo(self.tabCollectionView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.view.addSubview(self.highlightView)
    self.highlightView.snp.makeConstraints {
      $0.bottom.equalTo(self.tabCollectionView.snp.bottom)
      $0.left.equalToSuperview()
      $0.height.equalTo(4)
      $0.width.equalTo(UIScreen.main.bounds.width / 3)
    }
    
    self.view.addSubview(self.filterScrollView)
    self.filterScrollView.snp.makeConstraints {
      $0.top.equalTo(self.tabCollectionView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setHomeNavigationTitle(title: "필터")
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = SearchFilterViewModel.Input()
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
    self.bindTab(output: output)
//    self.bindSeries(output: output)
  }
  
  private func bindTab(output: SearchFilterViewModel.Output?) {
    output?.tabs
      .bind(to: self.tabCollectionView.rx.items(
        cellIdentifier: TabCell.identifier, cellType: TabCell.self
      )) { _, searchTab, cell in
        cell.updateUI(searchTab: searchTab)
      }
      .disposed(by: self.disposeBag)
    
    self.viewModel?.selectedTab
      .subscribe(onNext: { [weak self] idx in
        self?.updatePage(idx)
//        self?.updatePage(idx)
//        self?.updateButton(idx)
      })
      .disposed(by: disposeBag)
  }
  
  private func updatePage(_ idx: Int) {
    self.filterScrollView.updatePage(idx)
  }
  
}
