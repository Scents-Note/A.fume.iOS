//
//  LabelPopupViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2023/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class LabelPopupViewController: UIViewController {
  // MARK: - Vars & Lets
  var viewModel: LabelPopupViewModel?
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let dimmedView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.5)
  }
  private let container = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  
  private let contentLabel = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = .blackText
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private lazy var buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.addArrangedSubview(self.cancelButton)
    $0.addArrangedSubview(self.confirmButton)
  }
  
  private let cancelButton = UIButton().then {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.backgroundColor = .grayCd
  }
  
  private let confirmButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.backgroundColor = .black1d
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) { [weak self] in
      self?.container.transform = .identity
      self?.container.isHidden = false
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) { [weak self] in
      self?.container.transform = .identity
      self?.container.isHidden = true
    }
  }
  
  func setLabel(content: String) {
    self.contentLabel.text = content
  }
  
  func setConfirmLabel(content: String) {
    self.confirmButton.setTitle(content, for: .normal)
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.backgroundColor = .black.withAlphaComponent(0.5)
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(50)
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.container.addSubview(self.buttonStackView)
    self.buttonStackView.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(52)
    }
    
    self.container.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(42)
      $0.bottom.equalTo(self.buttonStackView.snp.top).offset(-42)
      $0.left.right.equalToSuperview()
    }
  }

  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    let input = LabelPopupViewModel.Input(cancelButtonDidTapEvent: self.cancelButton.rx.tap.asObservable(),
                                          confirmButtonDidTapEvent: self.confirmButton.rx.tap.asObservable(),
                                          dimmedViewDidTapEvent: self.dimmedView.rx.tapGesture().when(.recognized).map { _ in } )
    let output = viewModel?.transform(from: input, disposeBag: self.disposeBag)
  }
}
