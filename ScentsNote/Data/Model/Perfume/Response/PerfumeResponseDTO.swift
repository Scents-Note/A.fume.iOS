//
//  PerfumeResponseDTO.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

struct PerfumeResponseDTO: Decodable, Hashable {
  let perfumeIdx: Int
  let brandName: String
  let name: String
  let imageUrl: String
  let keywordList: [String]?
  var isLiked: Bool
}

extension PerfumeResponseDTO {
  func toDomain() -> Perfume {
    Perfume(perfumeIdx: self.perfumeIdx,
            brandName: self.brandName,
            name: self.name,
            imageUrl: self.imageUrl,
            keywordList: self.keywordList,
            isLiked: self.isLiked)
  }
}
