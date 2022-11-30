//
//  PerfumeDetailInfoViewController.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import UIKit
import SnapKit
import Then

// Reative말고 Snapshot 사용해보기
final class PerfumeDetailInfoViewController: UIViewController {
  private typealias DataSource = UICollectionViewDiffableDataSource<PerfumeDetailInfoSection, PerfumeDetailInfoItem>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<PerfumeDetailInfoSection, PerfumeDetailInfoItem>
  
  // MARK: - Var
  private var datasource: DataSource!
  var onUpdateHeight: ((CGFloat) -> Void)?
  var height: CGFloat = 0
  var isLoaded = false
  
  // MARK: - UI
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout()).then {
    $0.isScrollEnabled = false
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureCollectionView()
    self.configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateViewHeight()
  }
  
  // MARK: - Configure
  private func configureCollectionView() {
    let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
    datasource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
    }
  }
  
  private func configureUI() {
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
  
  func updateSnapshot(perfumeDetail: PerfumeDetail) {
    guard !isLoaded else { return }
    var snapshot = Snapshot()
    snapshot.appendSections([.story, .keyword, .ingredient, .abundance, .price, .seasonal, .longevity, .sillage, .similarity])
    snapshot.appendItems([.header("조향 스토리"), .story(perfumeDetail.story), .footer("story")], toSection: .story)
    snapshot.appendItems([.header("키워드"), .keyword(["조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리"]), .footer("keyword")], toSection: .keyword)
    snapshot.appendItems([.header("노트"), .ingredient(IngredientResponseDTO(top: "111", middle: "222", base: "333", single: "").toDomain()), .footer("ingredient")], toSection: .ingredient)
    snapshot.appendItems([.header("부향률"), .abundance(perfumeDetail.abundanceRate), .footer("abundance")], toSection: .abundance)
    snapshot.appendItems([.header("가격"), .price(perfumeDetail.volumeAndPrice), .footer("price")], toSection: .price)
    snapshot.appendItems([.header("계절감"), .seasonal(perfumeDetail.seasonal), .footer("seasonal")])
    snapshot.appendItems([.header("지속력"), .longevity(perfumeDetail.longevity), .footer("longevity")])
    snapshot.appendItems([.header("잔향감"), .sillage(perfumeDetail.sillage), .footer("sillage")])
    snapshot.appendItems([.header("지금 보는 향수와 비슷해요."), .similarity(perfumeDetail.similarPerfumes)])
    datasource.apply(snapshot) { [weak self] in
      self?.updateViewHeight()
      self?.isLoaded = true
    }
  }
  
  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    listConfiguration.showsSeparators = false
    return UICollectionViewCompositionalLayout.list(using: listConfiguration)
  }
  
  private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: PerfumeDetailInfoItem) {
    switch row {
    case .header(let title):
      cell.contentConfiguration = headerConfiguration(for: cell, with: title)
    case .footer:
      cell.contentConfiguration = footerConfiguration(for: cell)
    case .story(let story):
      cell.contentConfiguration = storyConfiguration(for: cell, with: story)
    case .keyword(let keywords):
      cell.contentConfiguration = keywordConfiguration(for: cell, with: keywords)
    case .ingredient(let ingredients):
      cell.contentConfiguration = ingredientConfiguration(for: cell, with: ingredients)
    case .abundance(let abundance):
      cell.contentConfiguration = abundanceConfiguration(for: cell, with: abundance)
    case .price(let prices):
      cell.contentConfiguration = priceConfiguration(for: cell, with: prices)
    case .seasonal(let seasonals):
      cell.contentConfiguration = seasonalConfiguration(for: cell, with: seasonals)
    case .longevity(let longevities):
      cell.contentConfiguration = longevityConfiguration(for: cell, with: longevities)
    case .sillage(let sillages):
      cell.contentConfiguration = sillageConfiguration(for: cell, with: sillages)
      //    case .gender:
      //      cell.contentConfiguration = headerConfiguration(for: cell, with: title)
    case .similarity(let perfumes):
      cell.contentConfiguration = similarityConfiguration(for: cell, with: perfumes)
    default:
      break
    }
  }
  
  private func updateViewHeight() {
    self.onUpdateHeight?(self.collectionView.contentSize.height)

//    if self.height != self.collectionView.contentSize.height {
//      self.height = self.collectionView.contentSize.height
//    }
  }
}

