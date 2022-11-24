//
//  SearchViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SearchViewController: UIViewController {
  typealias DataSource = RxCollectionViewSectionedNonAnimatedDataSource<PerfumeDataSection.Model>

  // MARK: - Vars & Lets
  var viewModel: SearchViewModel?
  var dataSource: DataSource!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private lazy var searchButton = UIBarButtonItem(image: .checkmark, style: .plain, target: self, action: nil)
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.gridCompositionalLayout()).then {
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .white
    $0.register(HomeNewCell.self)
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    let cellInput = self.configureCollectionView()
    self.bindViewModel(cellInput: cellInput)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.view.backgroundColor = .white
    self.configureNavigation()
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
    }
  }
  
  private func configureCollectionView() -> SearchViewModel.CellInput {
    let perfumeClicked = PublishRelay<Perfume>()
    let perfumeHeartClicked = PublishRelay<Perfume>()
    
    self.dataSource = DataSource { dataSource, tableView, indexPath, item in
      let cell = self.collectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
      cell.updateUI(perfume: item.perfume)
      cell.onPerfumeClick()
        .subscribe(onNext: { _ in
          perfumeClicked.accept(item.perfume)
      })
      .disposed(by: cell.disposeBag)
      cell.onHeartClick()
        .subscribe(onNext: {
          perfumeHeartClicked.accept(item.perfume)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
    
    return SearchViewModel.CellInput(perfumeDidTapEvent: perfumeClicked,
                                     perfumeHeartDidTapEvent: perfumeHeartClicked)
                                         
  }
  
  func configureNavigation() {
    self.setBackButton()
    self.setHomeNavigationTitle(title: "검색")
    self.navigationItem.rightBarButtonItem = self.searchButton
  }
  
  // MARK: - Binding ViewModel
  private func bindViewModel(cellInput: SearchViewModel.CellInput) {
    let input = SearchViewModel.Input(searchButtonDidTapEvent: searchButton.rx.tap.asObservable())
    let output = viewModel?.transform(from: input, from: cellInput, disposeBag: self.disposeBag)
    self.bindPerfumesNew(output: output)
  }
  
  private func bindPerfumesNew(output: SearchViewModel.Output?) {
    output?.perfumes
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}
