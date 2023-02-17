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
  
  // MARK: - Vars & Lets
  var viewModel: PerfumeDetailViewModel!
  private let disposeBag = DisposeBag()
  var isLoaded = false
  var height: CGFloat = 0
  
  // MARK: - UI
  private let emptyLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "아직 등록된 시향노트가 없어요 :)\n이 향수의 첫번째 시향 노트를 작성해보세요!"
    $0.textColor = .lightGray185
    $0.numberOfLines = 2
    $0.font = .systemFont(ofSize: 15, weight: .regular)
  }
  private lazy var collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewLayout).then {
    $0.backgroundColor = .lightGray
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
    self.view.backgroundColor = .lightGray
    self.view.addSubview(self.emptyLabel)
    self.emptyLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.view.addSubview(self.collectionView)
    self.collectionView.delegate = self
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func bindViewModel() {
    let input = self.viewModel.childInput
    rx.methodInvoked(#selector(viewWillLayoutSubviews))
      .take(2)
      .subscribe(onNext: { [weak self] _ in
        self?.isLoaded = true
        self?.updateViewHeight()
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel?.output.reviews
      .asDriver()
      .drive(onNext: { [weak self] reviews in
        Log(reviews.count)
        self?.updateUI(count: reviews.count)
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel?.output.reviews
      .bind(to: self.collectionView.rx.items(
        cellIdentifier: "ReviewCell", cellType: ReviewCell.self
      )) { _, review, cell in
        Log(review)
        cell.updateUI(review: review)
        cell.clickReport()
          .subscribe(onNext: {
            input.reviewCellReportTapEvent.accept(review.idx)          })
          .disposed(by: cell.disposeBag)
        cell.clickHeart()
          .subscribe(onNext: {
            input.reviewCellHeartTapEvent.accept(review.idx)
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: self.disposeBag)
  }
  
  private func updateViewHeight() {
    guard isLoaded else { return }
    let height = self.collectionView.contentSize.height
    /// review가 없을때
    if height == 68 {
      self.onUpdateHeight?(200)
    } else {
      self.onUpdateHeight?(height)
    }
  }
  
  
  private func updateUI(count: Int) {
    self.collectionView.isHidden = count == 0
    self.emptyLabel.isHidden = count != 0
  }
}

extension PerfumeDetailReviewViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if cell.frame.size.height == 100 {
      DispatchQueue.main.async {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
      }
    }
  }
}
