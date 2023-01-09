//
//  ListOf.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import Foundation

struct ListInfo<T: Decodable>: Decodable {
  let count: Int
  let rows: [T]
}
