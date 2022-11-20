//
//  PerfumeDetailInfoView+Configuration.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/16.
//

import UIKit

extension PerfumeDetailInfoView {
  
  func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> PerfumeDetailHeaderContentView.Configuration {
    var contentConfiguration = cell.headerConfiguration()
    contentConfiguration.title = title
    return contentConfiguration
  }
  
  func footerConfiguration(for cell: UICollectionViewListCell) -> PerfumeDetailFooterContentView.Configuration {
    let contentConfiguration = cell.footerConfiguration()
    return contentConfiguration
  }
  
  func storyConfiguration(for cell: UICollectionViewListCell, with title: String?) -> PerfumeDetailStoryContentView.Configuration {
    var contentConfiguration = cell.storyConfiguration()
    contentConfiguration.text = title
    return contentConfiguration
  }
  
  func keywordConfiguration(for cell: UICollectionViewListCell, with keywords: [String]) -> PerfumeDetailKeywordsContentView.Configuration {
    var contentConfiguration = cell.keywordsConfiguration()
    contentConfiguration.keywords = keywords
    return contentConfiguration
  }
  
  func ingredientConfiguration(for cell: UICollectionViewListCell, with ingredients: [Ingredient]) -> PerfumeDetailIngredientContentView.Configuration {
    var contentConfiguration = cell.ingredientConfiguration()
    contentConfiguration.ingredients = ingredients
    return contentConfiguration
  }
  
  func abundanceConfiguration(for cell: UICollectionViewListCell, with abundance: String) -> PerfumeDetailAbundanceContentView.Configuration {
    var contentConfiguration = cell.abundanceConfiguration()
    contentConfiguration.abundance = abundance
    return contentConfiguration
  }
  
  func priceConfiguration(for cell: UICollectionViewListCell, with prices: [String]) -> PerfumeDetailPriceContentView.Configuration {
    var contentConfiguration = cell.priceConfiguration()
    contentConfiguration.prices = prices
    return contentConfiguration
  }
  
  func seasonalConfiguration(for cell: UICollectionViewListCell, with seasonals: [Seasonal]) -> PerfumeDetailSeasonalContentView.Configuration {
    var contentConfiguration = cell.seasonalConfiguration()
    contentConfiguration.seasonals = seasonals
    return contentConfiguration
  }
  
  func longevityConfiguration(for cell: UICollectionViewListCell, with longevities: [Longevity]) -> PerfumeDetailLongevityContentView.Configuration {
    var contentConfiguration = cell.longevityConfiguration()
    contentConfiguration.longevities = longevities
    return contentConfiguration
  }
  
  func sillageConfiguration(for cell: UICollectionViewListCell, with keywords: [String]) -> PerfumeDetailKeywordsContentView.Configuration {
    var contentConfiguration = cell.keywordsConfiguration()
    contentConfiguration.keywords = keywords
    return contentConfiguration
  }
  
  func genderConfiguration(for cell: UICollectionViewListCell, with keywords: [String]) -> PerfumeDetailKeywordsContentView.Configuration {
    var contentConfiguration = cell.keywordsConfiguration()
    contentConfiguration.keywords = keywords
    return contentConfiguration
  }
  
  func similarityConfiguration(for cell: UICollectionViewListCell, with keywords: [String]) -> PerfumeDetailKeywordsContentView.Configuration {
    var contentConfiguration = cell.keywordsConfiguration()
    contentConfiguration.keywords = keywords
    return contentConfiguration
  }
  
}
