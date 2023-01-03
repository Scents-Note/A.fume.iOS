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
    let percents = [self.male, self.female, self.neutral]
    let max = percents.max()
    var genders: [Gender] = []
    /// 여성 중성 리뷰 저장할때와 반대로 사용하기 때문
    genders.append(Gender(gender: "남성", percent: percents[0], color: .SNDarkBeige1, isAccent: percents[0] == max && percents[0] != 0))
    genders.append(Gender(gender: "여성", percent: percents[2], color: .pointBeige, isAccent: percents[2] == max && percents[2] != 0))
    genders.append(Gender(gender: "중성", percent: percents[1], color: .SNLightBeige239, isAccent: percents[1] == max && percents[1] != 0))
    return genders
  }
}
