//
//  Gender.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

import UIKit

struct Gender: Hashable {
  let gender: String
  let percent: Int
  let color: UIColor
  let isAccent: Bool
  
  static let `default`: [Gender] = [Gender(gender: "남성",
                                           percent: 33,
                                           color: .clear,
                                           isAccent: false),
                                    Gender(gender: "",
                                           percent: 0,
                                           color: .clear,
                                           isAccent: false),
                                    Gender(gender: "중성",
                                           percent: 33,
                                           color: .clear,
                                           isAccent: false),
                                    Gender(gender: "",
                                           percent: 0,
                                           color: .clear,
                                           isAccent: false),
                                    Gender(gender: "여성",
                                           percent: 33,
                                           color: .clear,
                                           isAccent: false)]
}
