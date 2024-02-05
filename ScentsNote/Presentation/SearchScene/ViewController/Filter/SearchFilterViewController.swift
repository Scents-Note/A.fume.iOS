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
import RxGesture

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
  private let bottomView = UIView().then { $0.backgroundColor = .lightGray }
    private let dividerViewOfBottomView = UIView().then { $0.backgroundColor = .lightGray }
    private let resetView = UIView().then {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 2
      $0.layer.borderColor = UIColor.grayCd.cgColor
      $0.layer.borderWidth = 0.5
    }
    private let resetImageView = UIImageView().then {
        $0.image = .resetFilter
    }
    private let resetLabel = UILabel().then {
      $0.text = "재설정"
      $0.textColor = .blackText
      $0.font = .appleSDGothic(type: .regular, size: 12.0)
    }
  private let doneButton = DoneButton(title: "적용", isFilterButton: true)

  // MARK: - Life Cycle
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
      
      self.view.addSubview(bottomView)
      self.bottomView.snp.makeConstraints {
        $0.left.right.bottom.equalToSuperview()
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(72)
      }
      
      self.bottomView.addSubview(self.resetView)
      self.resetView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(10)
        $0.left.equalToSuperview().offset(18)
        $0.width.equalTo(90)
        $0.height.equalTo(52)
      }
      
      self.bottomView.addSubview(self.dividerViewOfBottomView)
      self.dividerViewOfBottomView.snp.makeConstraints {
        $0.top.left.right.equalToSuperview()
        $0.height.equalTo(1)
      }
      
      self.resetView.addSubview(self.resetImageView)
      self.resetImageView.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(4)
        $0.size.equalTo(24)
      }
      
      self.resetView.addSubview(self.resetLabel)
      self.resetLabel.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalToSuperview().offset(-4)
          
      }
      
      self.bottomView.addSubview(self.doneButton)
      self.doneButton.snp.makeConstraints {
        $0.top.equalToSuperview().offset(10)
        $0.left.equalTo(self.resetView.snp.right).offset(17)
        $0.right.equalToSuperview().offset(-18)
          $0.height.equalTo(52)
      }
      
    self.view.addSubview(self.filterScrollView)
    self.filterScrollView.snp.makeConstraints {
      $0.top.equalTo(self.tabCollectionView.snp.bottom)
      $0.bottom.equalTo(self.bottomView.snp.top)
      $0.left.right.equalToSuperview()
    }
    
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input

    self.tabCollectionView.rx.itemSelected.map { $0.item }
      .bind(to: input.tabDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.doneButton.rx.tap
      .bind(to: input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.closeButton.rx.tap
      .bind(to: input.closeButtonDidTapEvent)
      .disposed(by: self.disposeBag)
      
      self.resetView.rx.tapGesture()
          .when(.recognized).map{ _ in }
          .subscribe(onNext: { [weak self] _ in
//              self?.filterScrollView.updatePage(<#T##idx: Int##Int#>)
              self?.filterScrollView.removeFromSuperview()
              self?.view.addSubview(self?.filterScrollView ?? UIView())
              self?.filterScrollView.snp.makeConstraints {
                  $0.top.equalTo((self?.tabCollectionView.snp.bottom)!)
                  $0.bottom.equalTo((self?.bottomView.snp.top)!)
                $0.left.right.equalToSuperview()
              }
              input.resetFilterButtonDidTapEvent.accept(())
          })
          .disposed(by: disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    self.bindTab(output: output)
    self.bindDoneButton(output: output)
    
  }
  
  private func bindTab(output: SearchFilterViewModel.Output) {
    output.tabs
      .bind(to: self.tabCollectionView.rx.items(
        cellIdentifier: TabCell.identifier, cellType: TabCell.self
      )) { _, searchTab, cell in
        cell.updateUI(searchTab: searchTab)
      }
      .disposed(by: self.disposeBag)
    
    output.tabSelected
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] idx in
        self?.updatePage(idx)
      })
      .disposed(by: disposeBag)

    output.hightlightViewTransform
      .observe(on: MainScheduler.instance)
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
//    self.viewModel?.selectedTab.accept(index)
  }
}
