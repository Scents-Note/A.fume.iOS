//
//  Array+Division.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/06.
//

import Foundation

extension Array {
  func division(by size: Int) -> [[Element]] {
    let cnt = self.count
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
