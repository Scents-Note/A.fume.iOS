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
  
  // MARK: - Output
  var onUpdateHeight: ((CGFloat) -> Void)?
//  var reviews: BehaviorRelay<[ReviewInPerfumeDetail]>?
  
  // MARK: - Vars & Lets
  var viewModel: PerfumeDetailViewModel?
  private let disposeBag = DisposeBag()
  var isLoaded = false
  var height: CGFloat = 0
  
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
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func bindViewModel() {
    rx.methodInvoked(#selector(viewWillLayoutSubviews))
      .take(2)
      .subscribe(onNext: { [weak self] _ in
        self?.isLoaded = true
        self?.updateViewHeight()
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel?.output.reviews
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "ReviewCell", cellType: ReviewCell.self
      )) { _, review, cell in
        Log(review)
        cell.updateUI(review: review)
        cell.clickReport()
          .subscribe(onNext: { [weak self] in
            self?.viewModel?.clickReport(reviewIdx: review.idx)
          })
          .disposed(by: self.disposeBag)
      }
      .disposed(by: self.disposeBag)
  }
  
//  func bindOutput(reviews: BehaviorRelay<[ReviewInPerfumeDetail]>?) {
//    self.reviews = reviews
//  }
  
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
