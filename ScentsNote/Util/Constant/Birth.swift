//
//  Birth.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/28.
//

import Foundation

enum Birth {
  static let range = [Int](1900...2023)
  static let minimum = 1900
  
  static func toRow(from birth: Int) -> Int {
    return birth - self.minimum
  }
}
