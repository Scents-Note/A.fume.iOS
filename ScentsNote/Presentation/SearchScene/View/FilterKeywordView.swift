//
//  FilterKeywordView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources

final class FilterKeywordView: UIView {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<FilterKeywordDataSection.Model>
  
  // MARK: - Vars & Lets
  var viewModel: SearchFilterViewModel
  private var dataSource: DataSource!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let notyView = UIView().then { $0.backgroundColor = .lightGray2 }
  private let notyLabel = UILabel().then {
    $0.text = "카테고리 당 최대 5개까지 중복 선택 가능합니다."
    $0.textColor = .darkGray7d
    $0.font = .notoSans(type: .regular, size: 12)
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.keywordLayout).then {
    $0.register(SurveyKeywordCollectionViewCell.self)
  }
  
  // MARK: - Life Cycle
  init(viewModel: SearchFilterViewModel) {
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
    self.configureCollectionView()
    
    self.addSubview(self.notyView)
    self.notyView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.right.equalToSuperview()
      $0.height.equalTo(36)
    }
    
    self.notyView.addSubview(self.notyLabel)
    self.notyLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.notyView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }
  
  private func configureCollectionView() {
    self.dataSource = DataSource { dataSource, collectionView, indexPath, item in
        let cell = self.collectionView.dequeueReusableCell(SurveyKeywordCollectionViewCell.self, for: indexPath)
        cell.updateUI(keyword: item.keyword)
//        cell.clickKeyword()
//          .subscribe(onNext: {_ in
//            self.viewModel.clickSeries(section: indexPath.section, ingredient: item.ingredient)
//          })
//          .disposed(by: cell.disposeBag)
        return cell
      }
  }
  
  // MARK: - Bind ViewModel
  func bindViewModel() {
    self.collectionView.rx.itemSelected.map { $0.item }
      .subscribe(onNext: { [weak self] pos in
        Log(pos)
        self?.viewModel.clickKeyword(pos: pos)
      })
      .disposed(by: self.disposeBag)
    
    self.viewModel.keywordDataSource
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
    
//    self.viewModel.keywords
//      .bind(to: self.collectionView.rx.items(cellIdentifier: "SurveyKeywordCollectionViewCell", cellType: SurveyKeywordCollectionViewCell.self)) { index, keyword, cell in
//        cell.updateUI(keyword: keyword)
//      }
//      .disposed(by: self.disposeBag)
//    
//    self.viewModel.brands
//      .bind(to: self.brandCollectionView.rx.items(cellIdentifier: "FilterBrandCell", cellType: FilterBrandCell.self)) { index, brand, cell in
//        cell.updateUI(brand: brand)
//      }
//      .disposed(by: self.disposeBag)
  }
}
