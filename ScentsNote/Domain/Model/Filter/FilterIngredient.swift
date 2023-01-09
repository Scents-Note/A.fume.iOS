//
//  FilterIngredient.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/25.
//

import Foundation

struct FilterIngredient: Hashable {
  let id: String = UUID().uuidString
  let idx: Int
  let name: String
  var isSelected: Bool
}
