//
//  Perfume.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/20.
//

struct Perfume: Hashable {
  let perfumeIdx: Int
  let brandName: String
  let name: String
  let imageUrl: String
  let keywordList: [String]?
  var isLiked: Bool
  
  static let `default` = Perfume(perfumeIdx: 0, brandName: "마르지엘라", name: "향수", imageUrl: "", keywordList: [], isLiked: false)
}


//  func dummy() -> [Perfume] {
//    return [Perfume(perfumeIdx: -1, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false), Perfume(perfumeIdx: -2, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -3, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: 4, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -5, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -6, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false),Perfume(perfumeIdx: -7, brandName: "조말론 런던", name: "잉글리쉬 오크 앤 레드커런트 코롱", imageUrl: "https://afume.s3.ap-northeast-2.amazonaws.com/perfume/8/1.jpg", keywordList: nil, isLiked: false)]
//
//  }
