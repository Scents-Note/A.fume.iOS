//
//  HomeViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

import SnapKit
import Then

final class HomeViewController: UIViewController {

  // MARK: - Vars & Lets
  var viewModel: HomeViewModel?
  private let disposeBag = DisposeBag()
  private var dataSource: RxCollectionViewSectionedNonAnimatedDataSource<HomeDataSection.Model>!
  
  // TODO: collectionViewLayout 팩토리로 빼버리기
  private lazy var collectionViewLayout = UICollectionViewCompositionalLayout (sectionProvider: { section, env -> NSCollectionLayoutSection? in
    let section = self.dataSource.sectionModels[section].model
    switch section {
    case .title:
      return self.titleLayoutSection()
    case .recommendation:
      return self.recommendationLayoutSection()
    case .popularity:
      return self.popularityLayoutSection()
    case .recent:
      return self.recentLayoutSection()
    case .new:
      return self.newLayoutSection()
    case .more:
      return self.moreLayoutSection()
    }
  }, configuration: UICollectionViewCompositionalLayoutConfiguration().then {
    $0.interSectionSpacing = 32
  })
    .then {
    $0.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background-lightGray")
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout).then {
    $0.isScrollEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.contentInset = .zero
    $0.backgroundColor = .clear
    $0.clipsToBounds = true
    $0.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(HomeTitleCell.self)
    $0.register(HomeRecommendationSection.self)
    $0.register(HomePopularityCell.self)
    $0.register(HomeRecentCell.self)
    $0.register(HomeNewCell.self)
    $0.register(HomeMoreCell.self)
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    let cellInput = self.configureCollectionView()
    self.bindViewModel(cellInput: cellInput)
    self.loadViewIfNeeded()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.collectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  // MARK: Configure UI
  private func configureUI() {
    self.setBackButton()
    
    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  private func configureCollectionView() -> HomeViewModel.CellInput {
    // MARK: - Cell Input
    
    /// Cell 클릭
    let perfumeClicked = PublishRelay<Perfume>()
    let moreClicked = PublishRelay<Bool>()
    
    /// Cell Heart 클릭
    let perfumeHeartClicked = PublishRelay<Perfume>()
    
    // TODO: 메모리 Leak 나는지 확인해보기
    self.dataSource = RxCollectionViewSectionedNonAnimatedDataSource<HomeDataSection.Model> { dataSource, tableView, indexPath, item in
        switch item {
        case .title:
          let cell = self.collectionView.dequeueReusableCell(HomeTitleCell.self, for: indexPath)
          return cell
        case .recommendation(let perfumes):
          let cell = self.collectionView.dequeueReusableCell(HomeRecommendationSection.self, for: indexPath)
          cell.updateUI(perfumes: perfumes)
          return cell
        case .popularity(let perfume):
          let cell = self.collectionView.dequeueReusableCell(HomePopularityCell.self, for: indexPath)
          cell.updateUI(perfume: perfume)
          cell.onPerfumeClick().subscribe(onNext: { _ in
            perfumeClicked.accept(perfume)
          })
          .disposed(by: cell.disposeBag)
          cell.onHeartClick().subscribe(onNext: {
            perfumeHeartClicked.accept(perfume)
          })
          .disposed(by: cell.disposeBag)
          return cell
        case .recent(let perfume):
          let cell = self.collectionView.dequeueReusableCell(HomeRecentCell.self, for: indexPath)
          cell.updateUI(perfume: perfume)
          cell.onPerfumeClick().subscribe(onNext: { _ in
            perfumeClicked.accept(perfume)
          })
          .disposed(by: cell.disposeBag)
          cell.onHeartClick().subscribe(onNext: {
            perfumeHeartClicked.accept(perfume)
          })
          .disposed(by: cell.disposeBag)
          return cell
        case .new(let perfume):
          let cell = self.collectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
          cell.updateUI(perfume: perfume)
          cell.onPerfumeClick().subscribe(onNext: { _ in
            perfumeClicked.accept(perfume)
          })
          .disposed(by: cell.disposeBag)
          cell.onHeartClick().subscribe(onNext: {
            perfumeHeartClicked.accept(perfume)
          })
          .disposed(by: cell.disposeBag)
          return cell
        case .more:
          let cell = self.collectionView.dequeueReusableCell(HomeMoreCell.self, for: indexPath)
          cell.onMoreClick().subscribe(onNext : {
            moreClicked.accept(true)
          })
          .disposed(by: cell.disposeBag)
          return cell
        }
      }
    
    self.dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
      if kind == UICollectionView.elementKindSectionHeader {
        let section = collectionView.dequeueReusableHeaderView(HomeHeaderView.self, for: indexPath)
        switch self.dataSource.sectionModels[indexPath.section].model {
          
        case let .recommendation(data):
          section.updateUI(title: data.title, content: data.content)
        case let .popularity(data):
          section.updateUI(title: data.title, content: data.content)
        case let .recent(data):
          section.updateUI(title: data.title, content: nil)
        case let .new(data):
          section.updateUI(title: data.title, content: data.content)
        default:
          break
        }
        return section
      } else {
        return UICollectionReusableView()
      }
    }
    
    return HomeViewModel.CellInput(
      perfumeCellDidTapEvent: perfumeClicked,
      perfumeHeartButtonDidTapEvent: perfumeHeartClicked,
      moreCellDidTapEvent: moreClicked
    )
  }
  
  // MARK: - Binding ViewMOdel
  private func bindViewModel(cellInput: HomeViewModel.CellInput) {
    let input = HomeViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
    let output = viewModel?.transform(from: input, from: cellInput, disposeBag: disposeBag)
    self.bindSection(output: output)
  }
  
  private func bindSection(output: HomeViewModel.Output?) {
    output?.homeDatas
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}
