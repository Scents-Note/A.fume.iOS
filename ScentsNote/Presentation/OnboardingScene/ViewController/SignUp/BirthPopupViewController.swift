//
//  BirthPopup.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

import SnapKit
import Then

final class BirthPopupViewController: UIViewController {
  
  var viewModel: BirthPopupViewModel?
  private var disposeBag = DisposeBag()
  weak var delegate: BirthPopupDismissDelegate?
  
  private let container = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  
  private let picker = UIPickerView().then {
    $0.backgroundColor = .white
  }
  
  private let button = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .black1d
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black.withAlphaComponent(0.2)
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
      self?.container.transform = .identity
      self?.container.isHidden = false
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
      self?.container.transform = .identity
      self?.container.isHidden = true
    }
  }
}

extension BirthPopupViewController {
  private func configureUI() {
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(50)
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.container.addSubview(self.picker)
    self.picker.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }
    
    self.container.addSubview(self.button)
    self.button.snp.makeConstraints {
      $0.top.equalTo(self.picker.snp.bottom)
      $0.centerX.left.right.bottom.equalToSuperview()
      $0.height.equalTo(52)
    }
  }
}

extension BirthPopupViewController {
  private func bindViewModel() {
    let input = BirthPopupViewModel.Input(
      pickerSelectedRow: self.picker.rx.itemSelected.map { $0.row },
      doneButtonDidTapEvent: self.button.rx.tap.asObservable()
    )
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    self.bindPickerSection(output: output)
    self.bindFinishSection(output: output)
  }
}

extension BirthPopupViewController {
  private func bindPickerSection(output: BirthPopupViewModel.Output?) {
    output?.birthRange
      .asDriver()
      .drive(self.picker.rx.itemTitles) { (_, element) in
        return element
      }
      .disposed(by: self.disposeBag)
    
    output?.birth
      .asDriver()
      .drive(onNext: { [weak self] birth in
        self?.picker.selectRow(Birth.toRow(from: birth ?? 90), inComponent: 0, animated: false)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func bindFinishSection(output: BirthPopupViewModel.Output?) {
    output?.doneButtonDidTap
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] _ in
        self?.delegate?.birthPopupDismiss(with: String(output?.birth.value ?? 1990))
      })
      .disposed(by: disposeBag)
  }
}
