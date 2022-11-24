//
//  SillageResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//


struct SillageResponseDTO: Decodable, Hashable {
  let light: Int
  let medium: Int
  let heavy: Int
}

extension SillageResponseDTO {
  func toDomain() -> [Sillage] {
    let percentList = [self.light, self.medium, self.heavy]
    let max = percentList.max()
    var list: [Sillage] = []
    list.append(Sillage(sillage: "가벼움", percent: percentList[0], isAccent: percentList[0] == max))
    list.append(Sillage(sillage: "보통", percent: percentList[1], isAccent: percentList[1] == max))
    list.append(Sillage(sillage: "무거움", percent: percentList[2], isAccent: percentList[2] == max))
    return list
  }
}
