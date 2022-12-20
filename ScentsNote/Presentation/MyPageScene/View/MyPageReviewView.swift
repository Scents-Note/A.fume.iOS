//
//  MyPageReviewView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources

final class MyPageReviewView: UIView {
  
  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.reviewGroupInMyPageLayout).then {
    $0.register(MyPageReviewGroupCell.self)
  }
  
  // MARK: - Vars & Lets
  var viewModel: MyPageViewModel
  let disposeBag = DisposeBag()
  
  
  // MARK: - Life Cycle
  init(viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    self.configureUI()
    self.bindViewModel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    let output = self.viewModel.output

    output.reviews
      .bind(to: self.collectionView.rx.items(cellIdentifier: "MyPageReviewGroupCell", cellType: MyPageReviewGroupCell.self)) { _, reviews, cell in
        cell.updateUI(reviews: reviews)
        cell.onClickReview = { [weak self] reviewIdx in
          self?.viewModel.scrollInput.reviewCellDidTapEvent.accept(reviewIdx)
        }
      }
      .disposed(by: self.disposeBag)
    
  }
}
