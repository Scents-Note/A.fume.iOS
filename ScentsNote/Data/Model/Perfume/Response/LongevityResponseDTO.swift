//
//  Longevity.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

import Foundation

struct LongevityResponseDTO: Decodable, Hashable {
  let veryWeak: Int
  let weak: Int
  let medium: Int
  let strong: Int
  let veryStrong: Int
}

extension LongevityResponseDTO {
  func toDomain() -> [Longevity] {
    let longevityList = [self.veryWeak, self.weak, self.medium, self.strong, self.veryStrong]
    let maxPercent = longevityList.max()
    var list: [Longevity] = []
    list.append(Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: longevityList[0], isAccent: longevityList[0] == maxPercent))
    list.append(Longevity(longevity: "약함", duration: "1~3시간", percent: longevityList[1], isAccent: longevityList[1] == maxPercent))
    list.append(Longevity(longevity: "보통", duration: "3~5시간", percent: longevityList[2], isAccent: longevityList[2] == maxPercent))
    list.append(Longevity(longevity: "강함", duration: "5~7시간", percent: longevityList[3], isAccent: longevityList[3] == maxPercent))
    list.append(Longevity(longevity: "매우 강함", duration: "7시간 이상", percent: longevityList[4], isAccent: longevityList[4] == maxPercent))
    return list
  }
}
