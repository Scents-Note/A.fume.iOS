//
//  MockFilterDelegate.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/26.
//

@testable import ScentsNote

final class MockFilterDelegate: FilterDelegate {
  
  var ingredientsUpdated: [FilterIngredient] = []
  var updateBrandsCalledCount = 0
  var updateKeywordsCalledCount = 0
  
  func updateIngredients(ingredients: [FilterIngredient]) {
    self.ingredientsUpdated = ingredients
  }
  
  func updateBrands(brands: [FilterBrand]) {
    self.updateBrandsCalledCount += 1
  }
  
  func updateKeywords(keywords: [Keyword]) {
    self.updateKeywordsCalledCount += 1
  }
  
  
}
