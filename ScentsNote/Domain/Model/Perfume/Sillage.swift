//
//  Sillage.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import Foundation

struct Sillage: Hashable {
  let sillage: String
  let percent: Int
  let isAccent: Bool
  
  static let `default`: [Sillage] = [Sillage(sillage: "가벼움", percent: 20, isAccent: false),
                                     Sillage(sillage: "", percent: 20, isAccent: false),
                                     Sillage(sillage: "보통", percent: 20, isAccent: false),
                                     Sillage(sillage: "", percent: 20, isAccent: false),
                                     Sillage(sillage: "무거움", percent: 20, isAccent: false)]
}
