//
//  PerfumeDetailInfoView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/16.
//

import UIKit

class PerfumeDetailInfoView: UICollectionView {
  private typealias DataSource = UICollectionViewDiffableDataSource<PerfumeDetailInfoSection, PerfumeDetailInfoItem>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<PerfumeDetailInfoSection, PerfumeDetailInfoItem>
  
  private var infoDataSource: DataSource!
  
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    listConfiguration.showsSeparators = false
    let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    super.init(frame: frame, collectionViewLayout: listLayout)
    self.showsVerticalScrollIndicator = false
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func configureUI() {
    let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
    infoDataSource = DataSource(collectionView: self) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
    }
  }
  
  // FIXME: Repository에 mapper로 빼기
  func updateSnapshot(perfumeDetail: PerfumeDetail) {
    var snapshot = Snapshot()
    snapshot.appendSections([.story, .keyword, .ingredient, .abundance, .price, .seasonal, .longevity, .sillage])
    snapshot.appendItems([.header("조향 스토리"), .story(perfumeDetail.story), .footer("story")], toSection: .story)
    snapshot.appendItems([.header("키워드"), .keyword(["조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리", "조향 스토리"]), .footer("keyword")], toSection: .keyword)
    snapshot.appendItems([.header("노트"), .ingredient(IngredientResponseDTO(top: "111", middle: "222", base: "333", single: "").toDomain()), .footer("ingredient")], toSection: .ingredient)
    snapshot.appendItems([.header("부향률"), .abundance(perfumeDetail.abundanceRate), .footer("abundance")], toSection: .abundance)
    snapshot.appendItems([.header("가격"), .price(perfumeDetail.volumeAndPrice), .footer("price")], toSection: .price)
    snapshot.appendItems([.header("계절감"), .seasonal(perfumeDetail.seasonal), .footer("seasonal")])
    snapshot.appendItems([.header("지속력"), .longevity(perfumeDetail.longevity), .footer("longevity")])
    snapshot.appendItems([.header("잔향감"), .sillage(perfumeDetail.sillage), .footer("sillage")])
    
    Log(perfumeDetail)
    infoDataSource.apply(snapshot)
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
    default:
      break
    }
  }
}

//extension PerfumeDetailInfoView {
//  func keyword(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
//    var contentConfiguration = cell.textFieldConfiguration()
//    contentConfiguration.text = title
//    contentConfiguration.onChange = { [weak self] title in
//      self?.workingReminder.title = title
//    }
//    return contentConfiguration
//  }
//}
