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
  private func bindViewModel() {
    let output = self.viewModel.output
    self.bindPerfumes(output: output)
    
  }
  
  private func bindPerfumes(output: MyPageViewModel.Output) {
    output.perfumes
      .bind(to: self.collectionView.rx.items(cellIdentifier: "MyPageWishCell", cellType: MyPageWishCell.self)) { index, perfume, cell in
        cell.updateUI(perfume: perfume)
        cell.clickPerfume()
          .subscribe(onNext: { [weak self] _ in
            self?.viewModel.scrollInput.perfumeCellDidTapEvent.accept(perfume.idx)
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: self.disposeBag)
  }
}
