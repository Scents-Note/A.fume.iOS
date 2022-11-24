//
//  SearchResultViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SearchResultViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: SearchResultViewModel?
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
    popup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
  }
  
  private func configureNavigation() {
    self.view.backgroundColor = .white
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = SearchResultViewModel.Input()
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
  }
  
  private func popup() {
  }
}
