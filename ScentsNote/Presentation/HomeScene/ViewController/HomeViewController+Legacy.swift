//
//  HomeViewController+Legacy.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/09.
//


//enum HomeItem: Hashable {
//  case title
//  case recommendation([Perfume])
//  case popularity(Perfume)
//  case recent(Perfume)
//  case new(Perfume)
//  case more
//}
//  var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>! = nil
//  var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()

//func configureDataSource() {
//  // 1️⃣ Cell 등록
//  // 2개 종류의 Cell Type을 사용 (ListCell / TextCell)
//  let titleCellRegistration = UICollectionView.CellRegistration<HomeTitleCell, Int>{ _, _, _ in }
//  
//  let recommendationCellRegistration = UICollectionView.CellRegistration<HomeRecommendationSection, [Perfume]> { cell, indexPath, perfumes in
//    cell.updateUI(perfumes: perfumes)
//  }
//  
//  let popularityCellRegistration = UICollectionView.CellRegistration<HomePopularityCell, Perfume> { cell, _, perfume in
//    cell.updateUI(perfume: perfume)
//  }
//  
//  let recentCellRegistration = UICollectionView.CellRegistration<HomeRecentCell, Perfume> { cell, indexPath, perfume in
//    cell.updateUI(perfume: perfume)
//  }
//  
//  let newCellRegistration = UICollectionView.CellRegistration<HomeNewCell, Perfume> { cell, _, perfume in
//    cell.updateUI(perfume: perfume)
//  }
//  
//  let moreCellRegistration = UICollectionView.CellRegistration<HomeMoreCell, Int> { _, _, _ in }
//  
//  dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: collectionView) { collectionView, indexPath, item in
//    var cell: UICollectionViewCell
//    switch item {
//    case .title:
//      cell = collectionView.dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: 0)
//    case .recommendation(let perfumes):
//      cell = collectionView.dequeueConfiguredReusableCell(using: recommendationCellRegistration, for: indexPath, item: perfumes)
//    case .popularity(let perfume):
//      cell = collectionView.dequeueConfiguredReusableCell(using: popularityCellRegistration, for: indexPath, item: perfume)
//    case .recent(let perfume):
//      cell = collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: perfume)
//    case .new(let perfume):
//      cell = collectionView.dequeueConfiguredReusableCell(using: newCellRegistration, for: indexPath, item: perfume)
//    case .more:
//      cell = collectionView.dequeueConfiguredReusableCell(using: moreCellRegistration, for: indexPath, item: 0)
//    }
//    return cell
//  }
//}

//func configureSnapshot() {
  
  //    self.snapshot.appendSections([.title, .recommendation, .popularity])
  //    self.snapshot.appendItems([.title], toSection: .title)
  //
  //    dataSource.apply(snapshot, animatingDifferences: false)
  //
  //    collectionView.dataSource = dataSource
      
  //    self.snapshot.appendSections([.recommendation])
  //    self.snapshot.appendItems([.recommendation(self.dummy)], toSection: .recommendation)
  //    dataSource.apply(snapshot, animatingDifferences: false)

      
//    }
//    output?.loadData
//      .subscribe(onNext: { [weak self] _ in
//        self?.collectionView.reloadData()
//      })
//      .disposed(by: disposeBag)
//
//    output?.perfumes1
//      .subscribe(onNext: { [weak self] perfumes in
//        guard let self = self else { return }
////        self.snapshot.appendSections([.recommendation])
//        self.snapshot.appendItems([.recommendation(perfumes)], toSection: .recommendation)
//        self.dataSource.apply(self.snapshot, animatingDifferences: false)
//      })
//      .disposed(by: disposeBag)
//
//    output?.perfumes2
//      .subscribe(onNext: { [weak self] perfumes in
//        guard let self = self else { return }
////        self.snapshot.appendSections([.popularity])
////        self.snapshot.appendItems(perfumes.map { .popularity($0)})
//        self.snapshot.appendItems(perfumes.map { .popularity($0)}, toSection: .popularity)
////        self.dataSource.apply(self.snapshot, animatingDifferences: false)
////        self.viewModel.updatePerfumes()
//        self.snapshot.appendItems([.popularity(self.viewModel!.perfumesPopular[0])],toSection: .popularity)
//        self.snapshot.appendItems([.popularity(self.viewModel!.perfumesPopular[0])],toSection: .popularity)
////        self.dataSource.apply(self.snapshot, animatingDifferences: false)
//      })
//      .disposed(by: disposeBag)

//private func configureSupplementaryViewRegistrationAndDataSource() {
//  let headerRegistration = UICollectionView.SupplementaryRegistration<HomeHeaderView>(elementKind: SupplementaryKind.header) { view, _, indexPath in
////      view.apply(indexPath)
//  }
//  
//  dataSource.supplementaryViewProvider = { [weak self] _, kind, index in
//    switch kind {
//    case SupplementaryKind.header:
//      return self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
//                                                           for: index)
//    default:
//      return UICollectionReusableView()
//    }
//  }
    
//extension HomeViewController: UICollectionViewDataSource {
//  func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return sections.count
//  }
//
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    switch self.sections[section] {
//    case .popularity:
//      return self.viewModel?.perfumesPopular.count ?? 0
//    case .recent:
//      return self.viewModel?.perfumesRecent.count ?? 0
//    case .new:
//      return self.viewModel?.perfumesNew.count ?? 0
//    default:
//      return 1
//    }
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let section = self.sections[indexPath.section]
//    switch section {
//    case .title:
//      let cell = collectionView.dequeueReusableCell(HomeTitleCell.self, for: indexPath)
//      return cell
//    case .recommendation:
//      let cell = collectionView.dequeueReusableCell(HomeRecommendationSection.self, for: indexPath)
//      cell.updateUI(perfumes: self.viewModel?.perfumesRecommended)
//      return cell
//    case .popularity:
//      let cell = collectionView.dequeueReusableCell(HomePopularityCell.self, for: indexPath)
//      cell.updateUI(perfume: self.viewModel?.perfumesPopular[indexPath.row])
//      return cell
//    case .recent:
//      let cell = collectionView.dequeueReusableCell(HomeRecentCell.self, for: indexPath)
//      cell.updateUI(perfume: self.viewModel?.perfumesRecent[indexPath.row])
//      return cell
//    case .new:
//      let cell = collectionView.dequeueReusableCell(HomeNewCell.self, for: indexPath)
//      cell.updateUI(perfume: self.viewModel?.perfumesNew[indexPath.row])
//      cell.clickHeart = {
//        let index =
//        self.viewModel?.onClickPerfumeHeartNew(index: indexPath.row)
//      }
//      return cell
//    case .more:
//      let cell = collectionView.dequeueReusableCell(HomeMoreCell.self, for: indexPath)
//      return cell
//    }
//
//  }
//
//  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    switch kind {
//    case UICollectionView.elementKindSectionHeader:
//      let header = collectionView.dequeueReusableHeaderView(HomeHeaderView.self, for: indexPath)
//      switch self.sections[indexPath.section] {
//      case .recommendation:
//        header.updateUI(title: "000 님을 위한\n향수 추천", content: "어퓸을 사용할수록\n더 잘 맞는 향수를 보여드려요")
//      case .popularity:
//        header.updateUI(title: "20대 여성이\n많이 찾는 향수", content: "00 님 연령대 분들에게 인기 많은 향수 입니다.")
//      case .recent:
//        header.updateUI(title: "최근 찾아본 향수", content: nil)
//      case .new:
//        header.updateUI(title: "새로\n등록된 향수", content: "기대하세요.  새로운 향수가 업데이트 됩니다.")
//      default:
//        break
//      }
//      return header
//    default:
//      return UICollectionReusableView()
//    }
//  }
//}
