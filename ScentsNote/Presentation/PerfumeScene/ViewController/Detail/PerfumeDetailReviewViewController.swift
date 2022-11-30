//
//  PerfumeDetailReviewViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import Then

final class PerfumeDetailReviewViewController: UIViewController {
  // MARK: - Vars & Lets
  private var viewModel: PerfumeDetailViewModel?
  private let disposeBag = DisposeBag()
  var onUpdateHeight: ((CGFloat) -> Void)?
  var height: CGFloat = 0
  
  var isLoaded = false

  
  
  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewLayout).then {
    $0.isScrollEnabled = false
    $0.register(ReviewCell.self)
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateViewHeight()
  }
  
  func setViewModel(viewModel: PerfumeDetailViewModel?) {
    self.viewModel = viewModel
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func bindViewModel() {
    rx.methodInvoked(#selector(viewWillLayoutSubviews))
      .skip(1)
      .take(1)
      .subscribe(onNext: { [weak self] _ in
        self?.isLoaded = true
        self?.updateViewHeight()
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel?.output.reviews
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "ReviewCell", cellType: ReviewCell.self
      )) { _, review, cell in
        cell.updateUI(review: review)
      }
      .disposed(by: self.disposeBag)
  }
  
  private func updateViewHeight() {
    guard isLoaded else { return }
    let height = self.collectionView.contentSize.height
    if height == 0 {
      self.onUpdateHeight?(400)
    } else {
      self.onUpdateHeight?(self.collectionView.contentSize.height)
    }
  }
}
