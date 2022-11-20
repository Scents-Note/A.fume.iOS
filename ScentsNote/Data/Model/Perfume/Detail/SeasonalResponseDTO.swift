//
//  SeasonalResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/19.
//

struct SeasonalResponseDTO: Decodable, Hashable {
  let spring: Int
  let summer: Int
  let fall: Int
  let winter: Int
}


extension SeasonalResponseDTO {
  func toDomain() -> [Seasonal] {
    let percents: [Int] = [self.spring, self.summer, self.fall, self.winter]
    let max = percents.max()
    var list: [Seasonal] = []
    list.append(Seasonal(season: "봄", percent: percents[0], color: .SNDarkBeige1, isAccent: percents[0] == max))
    list.append(Seasonal(season: "여름", percent: percents[1], color: .SNLightBeige1, isAccent: percents[1] == max))
    list.append(Seasonal(season: "가을", percent: percents[2], color: .SNLightBeige2, isAccent: percents[2] == max))
    list.append(Seasonal(season: "겨울", percent: percents[3], color: .SNDarkBeige2, isAccent: percents[3] == max))
    return list
  }
}
