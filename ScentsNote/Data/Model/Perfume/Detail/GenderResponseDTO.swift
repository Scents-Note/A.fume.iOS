//
//  GenderResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

struct GenderResponseDTO: Decodable, Hashable {
  let male: Int
  let neutral: Int
  let female: Int
}

extension GenderResponseDTO {
  func toDomain() -> [Gender] {
    let percents = [self.female, self.male, self.neutral]
    let max = percents.max()
    var genders: [Gender] = []
    genders.append(Gender(gender: "여성", percent: percents[0], isAccent: percents[0] == max))
    genders.append(Gender(gender: "남성", percent: percents[1], isAccent: percents[1] == max))
    genders.append(Gender(gender: "중성", percent: percents[2], isAccent: percents[2] == max))
    return genders
  }
}
