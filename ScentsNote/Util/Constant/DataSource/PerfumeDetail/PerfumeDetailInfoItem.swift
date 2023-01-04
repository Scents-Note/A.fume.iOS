//
//  PerfumeDetailInfoItem.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/16.
//

import UIKit

enum PerfumeDetailInfoItem: Hashable {
  case header(String)
  case footer(String)
  case story(String)
  case keyword([String])
  case ingredient([Ingredient])
  case abundance(String)
  case price([String])
  case seasonal([Seasonal])
  case longevity([Longevity])
  case sillage([Sillage])
  case gender([Gender])
  case similarity([Perfume]?)
}
