//
//  Longevity.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import Foundation

struct Longevity: Hashable {
  let longevity: String
  let duration: String
  let percent: Int
  let isAccent: Bool
  
  static let `default`: [Longevity] = [Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: 20, isAccent: false),
                                       Longevity(longevity: "약함", duration: "1~3시간", percent: 20, isAccent: false),
                                       Longevity(longevity: "보통", duration: "3~5시간", percent: 20, isAccent: false),
                                       Longevity(longevity: "강함", duration: "5~7시간", percent: 20, isAccent: false),
                                       Longevity(longevity: "매우 강함", duration: "7시간", percent: 20, isAccent: false)]
}
