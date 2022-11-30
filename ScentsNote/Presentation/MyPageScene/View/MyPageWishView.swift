//
//  MyPageWishView.swift
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

final class MyPageWishView: UIView {
  
  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.wishLayout).then {
    $0.register(MyPageWishCell.self)
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
//    self.collectionView.rx.itemSelected.map { $0.item }
//      .subscribe(onNext: { [weak self] pos in
//        self?.viewModel.clickKeyword(pos: pos)
//      })
//      .disposed(by: self.disposeBag)
//    
    output.perfumesLiked
      .bind(to: self.collectionView.rx.items(cellIdentifier: "MyPageWishCell", cellType: MyPageWishCell.self)) { index, perfume, cell in
        cell.updateUI(perfume: perfume)
      }
      .disposed(by: self.disposeBag)
    
  }
}
