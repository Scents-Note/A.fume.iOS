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
  var viewModel: SearchResultViewModel!
  let disposeBag = DisposeBag()
  var keywordDataSource: KeywordDataSource!
  var perfumeDataSource: PerfumeDataSource!
  
  // MARK: - UI
  private lazy var searchButton = UIBarButtonItem(image: .btnSearch, style: .plain, target: self, action: nil).then {
    $0.tintColor = .blackText
  }
  
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
    $0.textColor = .lightGray185
    $0.font = .systemFont(ofSize: 16, weight: .regular)
    $0.textAlignment = .center
    $0.numberOfLines = 3
  }
  
  private let reportButton = UIButton().then {
    $0.setTitle("제보하기", for: .normal)
    $0.setTitleColor(.blackText, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 2
    $0.layer.borderColor = UIColor.blackText.cgColor
  }
  
  private let filterButton = UIButton().then {
    $0.setTitle("필터", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .notoSans(type: .medium, size: 16)
    $0.layer.cornerRadius = 21
    $0.layer.backgroundColor = UIColor.black.cgColor
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureDelegate()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    self.configureCollectionView()
    
    self.view.backgroundColor = .white
    self.view.addSubview(self.keywordCollectionView)
    self.keywordCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(56)
    }
    
    self.view.addSubview(self.perfumeCollectionView)
    self.perfumeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
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
      $0.height.equalTo(52)
    }
    
    self.view.addSubview(self.filterButton)
    self.filterButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
      $0.width.equalTo(95)
      $0.height.equalTo(42)
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "검색 결과")
    self.navigationItem.rightBarButtonItem = self.searchButton
  }
  
  private func configureCollectionView() {
    let input = self.viewModel.cellInput
    
    self.keywordDataSource = KeywordDataSource { dataSource, tableView, indexPath, item in
      let cell = self.keywordCollectionView.dequeueReusableCell(KeywordCell.self, for: indexPath)
      cell.updateUI(keyword: item.keyword)
      cell.onDeleteClick()
        .subscribe(onNext: { _ in
          input.keywordDeleteDidTapEvent.accept(item.keyword)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
    
    self.perfumeDataSource = PerfumeDataSource { dataSource, tableView, indexPath, item in
      let cell = self.perfumeCollectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
      cell.updateUI(perfume: item.perfume)
      cell.onPerfumeClick()
        .subscribe(onNext: { _ in
          input.perfumeDidTapEvent.accept(item.perfume)
        })
        .disposed(by: cell.disposeBag)
      cell.onHeartClick()
        .subscribe(onNext: {
          input.perfumeHeartDidTapEvent.accept(item.perfume)
        })
        .disposed(by: cell.disposeBag)
      return cell
    }
  }
  
  private func configureDelegate() {
    self.keywordCollectionView.delegate = self
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.searchButton.rx.tap.asObservable()
      .bind(to: input.searchButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.filterButton.rx.tap.asObservable()
      .bind(to: input.filterButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.reportButton.rx.tap.asObservable()
      .bind(to: input.reportButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    self.bindKeywords(output: output)
    self.bindPerfumes(output: output)
  }
  
  private func bindKeywords(output: SearchResultViewModel.Output) {
    output.keywords
      .bind(to: self.keywordCollectionView.rx.items(dataSource: keywordDataSource))
      .disposed(by: self.disposeBag)
    
    output.hideKeywordView
      .asDriver()
      .drive(onNext: { [weak self] isHidden in
        self?.updateKeywordView(isHidden: isHidden)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindPerfumes(output: SearchResultViewModel.Output) {
    output.perfumes
      .observe(on: MainScheduler.instance)
      .bind(to: self.perfumeCollectionView.rx.items(dataSource: perfumeDataSource))
      .disposed(by: self.disposeBag)

    output.hideEmptyView
      .asDriver()
      .drive(onNext: { [weak self] isHidden in
        self?.updateEmptyView(isHidden: isHidden)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func updateKeywordView(isHidden: Bool) {
    self.keywordCollectionView.isHidden = isHidden
    self.perfumeCollectionView.snp.updateConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(isHidden ? 0 : 56)
    }
  }
  
  private func updateEmptyView(isHidden: Bool) {
    self.emptyView.isHidden = isHidden
  }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? KeywordCell else { return }
    if cell.frame.size.width == KeywordCell.width {
      DispatchQueue.main.async {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
      }
    }
  }
}
