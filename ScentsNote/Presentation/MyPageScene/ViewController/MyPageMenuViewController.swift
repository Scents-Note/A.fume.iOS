//
//  MyPageMenuViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class MyPageMenuViewController: UIViewController {
  // MARK: - Vars & Lets
  var viewModel: MyPageMenuViewModel?
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let containerView = UIView().then { $0.backgroundColor = .white }
  private let closeButton = UIButton().then { $0.setImage(.btnClose, for: .normal) }
  private let titleLabel = UILabel().then {
    $0.text = "설정"
    $0.textColor = .blackText
    $0.font = .nanumMyeongjo(type: .extraBold, size: 22)
  }
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.menuLayout).then {
    $0.isScrollEnabled = false
    $0.register(MenuCell.self)
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindUI()
    self.bindViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showMenu()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.hideMenu()
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.right.equalToSuperview().offset(300)
      $0.width.equalTo(300)
    }
    
    self.containerView.addSubview(self.closeButton)
    self.closeButton.snp.makeConstraints {
      $0.top.right.equalToSuperview().inset(16)
    }
    
    self.containerView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(64)
      $0.left.equalToSuperview().offset(16)
    }
    
    self.containerView.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func bindUI() {
    self.containerView.rx.panGesture()
      .asDriver()
      .drive(onNext: { [weak self] pan in
        self?.handlePanGesture(pan: pan)
      })
      .disposed(by: self.disposeBag)

  }
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = MyPageMenuViewModel.Input(closeButtonDidTapEvent: self.closeButton.rx.tap.asObservable(),
                                          menuCellDidTapEvent: self.collectionView.rx.itemSelected.map { $0.item} )
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
    self.bindMenus(output: output)
  }
  
  private func bindMenus(output: MyPageMenuViewModel.Output?) {
    output?.menus
      .bind(to: self.collectionView.rx.items(cellIdentifier: "MenuCell", cellType: MenuCell.self)) { _, menu, cell in
        cell.updateUI(menu: menu)
      }
      .disposed(by: self.disposeBag)
  }
  
  private func showMenu() {
    
    self.containerView.snp.updateConstraints {
      $0.right.equalToSuperview()
    }
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.view.backgroundColor = .black.withAlphaComponent(0.5)
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  private func hideMenu() {
    self.containerView.snp.updateConstraints {
      $0.right.equalToSuperview().offset(300)
    }
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.view.backgroundColor = .black.withAlphaComponent(0)
      self.view.layoutIfNeeded()
    }) { _ in
      if self.presentingViewController != nil {
        self.dismiss(animated: false, completion: nil)
      }
    }
  }
  
  private func handlePanGesture(pan: UIPanGestureRecognizer) {
    let offsetX = pan.translation(in: self.containerView).x
    switch pan.state {
    case .changed:
      guard offsetX > 0.0 else { return }
      self.containerView.snp.updateConstraints {
        $0.right.equalToSuperview().offset(offsetX)
      }
    case .ended:
      if offsetX > 30.0 {
        self.hideMenu()
      } else {
        self.showMenu()
      }
    default:
      break
    }
  }

}

extension MyPageMenuViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view?.isDescendant(of: self.containerView) == true {
      return false
    }
    
    return true
  }
}
