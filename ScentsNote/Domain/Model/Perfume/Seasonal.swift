//
//  Seasonal.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import UIKit

struct Seasonal: Hashable {
  let season: String
  let percent: Int
  let color: UIColor
  let isAccent: Bool
  
  static let `default`: [Seasonal] = [Seasonal(season: "봄", percent: 25, color: .clear, isAccent: false),
                                      Seasonal(season: "여름", percent: 25, color: .clear, isAccent: false),
                                      Seasonal(season: "가을", percent: 25, color: .clear, isAccent: false),
                                      Seasonal(season: "겨울", percent: 25, color: .clear, isAccent: false)]
}
