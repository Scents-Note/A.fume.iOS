//
//  SearchResultViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SearchResultViewController: UIViewController {
  typealias KeywordDataSource = RxCollectionViewSectionedNonAnimatedDataSource<KeywordDataSection.Model>
  typealias PerfumeDataSource = RxCollectionViewSectionedNonAnimatedDataSource<PerfumeDataSection.Model>
  
  // MARK: - Vars & Lets
  var viewModel: SearchResultViewModel?
  let disposeBag = DisposeBag()
  var keywordDataSource: KeywordDataSource!
  var perfumeDataSource: PerfumeDataSource!
  
  // MARK: - UI
  private lazy var searchButton = UIBarButtonItem(image: .checkmark, style: .plain, target: self, action: nil)
  private lazy var keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.keywordCompositionalLayout()).then {
    $0.showsHorizontalScrollIndicator = false
    $0.backgroundColor = .lightGray
    $0.register(KeywordCell.self)
  }
  private lazy var perfumeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.gridCompositionalLayout()).then {
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .white
    $0.register(HomeNewCell.self)
  }
  
  private lazy var emptyView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 24
    $0.addArrangedSubview(self.emptyLabel)
    $0.addArrangedSubview(self.reportButton)
  }
  
  private let emptyLabel = UILabel().then {
    $0.text = "검색 결과가 없습니다.\n해당 향수의 정보를 보고 싶다면\n어퓸에게 제보해주세요."
    $0.textColor = .black
    $0.textAlignment = .center
    $0.numberOfLines = 3
  }
  
  private let reportButton = UIButton().then {
    $0.setTitle("제보하기", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .regular, size: 20)
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 2
    $0.layer.borderColor = UIColor.blackText.cgColor
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
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    
    self.view.addSubview(self.keywordCollectionView)
    self.keywordCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(56)
    }
    
    self.view.addSubview(self.perfumeCollectionView)
    self.perfumeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.keywordCollectionView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
    }
    
    self.view.addSubview(self.emptyView)
    self.emptyView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.left.right.equalToSuperview()
    }
    
    self.reportButton.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(26)
    }
  }
  
  private func configureNavigation() {
    self.view.backgroundColor = .white
    self.setBackButton()
    self.setNavigationTitle(title: "검색 결과")
    self.navigationItem.rightBarButtonItem = self.searchButton
  }
  
  private func configureCollectionView() -> SearchResultViewModel.CellInput {
    let keywordDeleted = PublishRelay<SearchKeyword>()
    let perfumeClicked = PublishRelay<Perfume>()
    let perfumeHeartClicked = PublishRelay<Perfume>()
    
    self.keywordDataSource = KeywordDataSource { dataSource, tableView, indexPath, item in
      let cell = self.keywordCollectionView.dequeueReusableCell(KeywordCell.self, for: indexPath)
      cell.updateUI(keyword: item.keyword)
      cell.onDeleteClick()
        .subscribe(onNext: { _ in
          keywordDeleted.accept(item.keyword)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
    
    self.perfumeDataSource = PerfumeDataSource { dataSource, tableView, indexPath, item in
      let cell = self.perfumeCollectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
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
    
    return SearchResultViewModel.CellInput(keywordDeleteDidTapEvent: keywordDeleted,
                                           perfumeDidTapEvent: perfumeClicked,
                                           perfumeHeartDidTapEvent: perfumeHeartClicked)
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel(cellInput: SearchResultViewModel.CellInput) {
    let input = SearchResultViewModel.Input(searchButtonDidTapEvent: searchButton.rx.tap.asObservable())
    let output = viewModel?.transform(from: input, from: cellInput, disposeBag: self.disposeBag)
    self.bindKeywords(output: output)
    self.bindPerfumes(output: output)
  }
  
  private func bindKeywords(output: SearchResultViewModel.Output?) {
    output?.keywords
//      .observe(on: MainScheduler.instance)
    // FIXME: 계속 estimate width 로 나와버림. 시점에 맞게 애초에 reload를 하는데 왜 문제가 생기는가?
      .delay(.milliseconds(10), scheduler: MainScheduler.instance)
      .bind(to: self.keywordCollectionView.rx.items(dataSource: keywordDataSource))
      .disposed(by: self.disposeBag)
  }
  
  private func bindPerfumes(output: SearchResultViewModel.Output?) {
    output?.perfumes
      .observe(on: MainScheduler.instance)
      .bind(to: self.perfumeCollectionView.rx.items(dataSource: perfumeDataSource))
      .disposed(by: self.disposeBag)
    
    output?.hideEmptyView
      .subscribe(onNext: { [weak self] isHidden in
        self?.updateEmptyView(isHidden: isHidden)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func updateEmptyView(isHidden: Bool) {
    self.emptyView.isHidden = isHidden
  }
}
