//
//  ReviewReportPopupViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

import UIKit
import RxSwift
import RxCocoa

import SnapKit
import Then

final class ReviewReportPopupViewController: UIViewController {
  
  var viewModel: ReviewReportPopupViewModel?
  private var disposeBag = DisposeBag()
  
  private let container = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  
  private let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.menuLayout).then {
    $0.register(ReviewReportCell.self)
  }
  
  private let cancelButton = UIButton().then {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.backgroundColor = .grayCd
  }
  
  private let reportButton = UIButton().then {
    $0.setTitle("신고하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .bold, size: 15)
    $0.backgroundColor = .blackText
  }
  
  private lazy var stackView = UIStackView().then {
    $0.distribution = .fillEqually
    $0.axis = .horizontal
    $0.addArrangedSubview(self.cancelButton)
    $0.addArrangedSubview(self.reportButton)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black.withAlphaComponent(0.5)
    self.configureUI()
    self.bindViewModel()
  }
  
  
//  override func viewWillLayoutSubviews() {
//    super.viewWillLayoutSubviews()
//    let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
//    Log(height)
//    self.collectionView.snp.updateConstraints {
//      $0.height.equalTo(height)
//    }
//    self.view.layoutIfNeeded()
//  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//
//    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
//      self?.container.transform = .identity
//      self?.container.isHidden = false
//    }
//  }
//
//  override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//
//    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
//      self?.container.transform = .identity
//      self?.container.isHidden = true
//    }
//  }
  
  private func configureUI() {
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(50)
      $0.centerX.centerY.equalToSuperview()
      $0.height.equalTo(500)
    }
    
    self.container.addSubview(self.collectionView)
    self.container.addSubview(self.stackView)
    self.collectionView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(400)
    }
    
   
    self.stackView.snp.makeConstraints {
      $0.bottom.right.left.equalToSuperview()
      $0.height.equalTo(52)
    }
  }
  
  private func bindViewModel() {
    let input = ReviewReportPopupViewModel.Input(reportCellDidTapEvent: self.collectionView.rx.itemSelected.map { $0.row },
                                                 cancelButtonDidTapEvent: self.cancelButton.rx.tap.asObservable())
    let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
    output?.reports
      .bind(to: self.collectionView.rx.items(cellIdentifier: "ReviewReportCell", cellType: ReviewReportCell.self)) { _, report, cell in
        cell.updateUI(report: report)
        cell.layoutIfNeeded()
      }
      .disposed(by: self.disposeBag)
  }
}
