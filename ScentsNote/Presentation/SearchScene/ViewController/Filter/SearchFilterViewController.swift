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
  private let navigationView = UIView().then { $0.backgroundColor = .white }
  private let titleLabel = UILabel().then {
    $0.text = "필터"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .extraBold, size: 22)
  }
  
  private let closeButton = UIButton().then { $0.setImage(.btnClose, for: .normal) }
  
  private lazy var tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.tabCompositionalLayout()).then {
    $0.isScrollEnabled = false
    $0.backgroundColor = .white
    $0.register(TabCell.self)
  }
  
  private let dividerView = UIView().then { $0.backgroundColor = .grayCd }
  private let highlightView = UIView().then { $0.backgroundColor = .black }
  private lazy var filterScrollView = FilterScrollView(viewModel: self.viewModel)
  private let doneButton = DoneButton(title: "적용")

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
    self.configureDelegate()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.navigationView)
    self.navigationView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(56)
    }
    
    self.navigationView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.equalToSuperview().offset(16)
    }
    
    self.navigationView.addSubview(self.closeButton)
    self.closeButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-16)
    }
    
    self.view.addSubview(self.tabCollectionView)
    self.tabCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.navigationView.snp.bottom).offset(12)
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
    
    self.view.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(86)
    }
    
    self.view.addSubview(self.filterScrollView)
    self.filterScrollView.snp.makeConstraints {
      $0.top.equalTo(self.tabCollectionView.snp.bottom)
      $0.bottom.equalTo(self.doneButton.snp.top)
      $0.left.right.equalToSuperview()
    }
    
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = SearchFilterViewModel.Input(
      tabDidTapEvent: self.tabCollectionView.rx.itemSelected.map { $0.item },
      doneButtonDidTapEvent: self.doneButton.rx.tap.asObservable(),
      closeButtonDidTapEvent: self.closeButton.rx.tap.asObservable()
    )
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
    self.bindTab(output: output)
    self.bindDoneButton(output: output)
  }
  
  private func bindTab(output: SearchFilterViewModel.Output?) {
    output?.tabs
      .bind(to: self.tabCollectionView.rx.items(
        cellIdentifier: TabCell.identifier, cellType: TabCell.self
      )) { _, searchTab, cell in
        cell.updateUI(searchTab: searchTab)
      }
      .disposed(by: self.disposeBag)
    
    output?.selectedTab
      .subscribe(onNext: { [weak self] idx in
        self?.updatePage(idx)
      })
      .disposed(by: disposeBag)

    output?.hightlightViewTransform
      .subscribe(onNext: {  [weak self] idx in
        UIView.animate(withDuration: 0.3) {
          self?.highlightView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * CGFloat(idx) / 3, y: 0)
          self?.highlightView.layoutIfNeeded()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func bindDoneButton(output: SearchFilterViewModel.Output?) {
    output?.selectedCount
      .asDriver()
      .drive(onNext: { [weak self] count in
        self?.updateDoneButton(count: count)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func updatePage(_ idx: Int) {
    self.filterScrollView.updatePage(idx)
  }
  
  private func updateDoneButton(count: Int) {
    var title = ""
    if count == 0 {
      title = "적용"
    } else {
      title = "적용(\(count))"
    }
    self.doneButton.updateTitle(title: title)
  }
  
  private func configureDelegate() {
    self.filterScrollView.delegate = self
  }
}

extension SearchFilterViewController: UIScrollViewDelegate {
  
  func isScrollViewHorizontalDragging() -> Bool {
    return self.filterScrollView.contentOffset.x.remainder(dividingBy: self.filterScrollView.frame.width) == 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let scrollView = (scrollView as? FilterScrollView) else { return }
    
    UIView.animate(withDuration: 0.1) { [weak self] in
      self?.highlightView.transform = CGAffineTransform(translationX: scrollView.contentOffset.x / 3, y: 0)
      self?.highlightView.layoutIfNeeded()
    }
    
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let _ = (scrollView as? FilterScrollView) else { return }
    
    let index = Int(targetContentOffset.pointee.x / self.tabCollectionView.frame.width)
    self.viewModel?.selectedTab.accept(index)
  }
}
