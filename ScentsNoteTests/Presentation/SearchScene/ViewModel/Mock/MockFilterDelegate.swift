//
//  MockFilterDelegate.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

@testable import ScentsNote_Dev

final class MockFilterDelegate: FilterDelegate {
  
  var ingredientsUpdated: [FilterIngredient] = []
  var brandsUpdated: [FilterBrand] = []
  var keywordsUpdated: [Keyword] = []
  
  func updateIngredients(ingredients: [FilterIngredient]) {
    self.ingredientsUpdated = ingredients
  }
  
  func updateBrands(brands: [FilterBrand]) {
    self.brandsUpdated = brands
  }
  
  func updateKeywords(keywords: [Keyword]) {
    self.keywordsUpdated = keywords
  }
}
