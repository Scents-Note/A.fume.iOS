//
//  MockModel.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/02/02.
//

@testable import ScentsNote

struct MockModel {
  static let perfumeDetail = PerfumeDetail(perfumeIdx: 7, name: "154 코롱", brandName: "조 말론", story: "story",
                                           abundanceRate: "풍부", volumeAndPrice: ["90ml, 50,000원"], imageUrls: [], score: 5.0,
                                           seasonal: [Seasonal(season: "봄", percent: 50, color: .SNDarkBeige1, isAccent: true),
                                                      Seasonal(season: "여름", percent: 0, color: .SNDarkBeige1, isAccent: false),
                                                      Seasonal(season: "가을", percent: 25, color: .SNDarkBeige1, isAccent: false),
                                                      Seasonal(season: "겨울", percent: 25, color: .SNDarkBeige1, isAccent: false)],
                                           sillage: [Sillage(sillage: "가벼움", percent: 33, isAccent: false),
                                                     Sillage(sillage: "보통", percent: 33, isAccent: false),
                                                     Sillage(sillage: "무거움", percent: 33, isAccent: false)],
                                           longevity: [Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: 0, isAccent: false, isEmpty: false),
                                                       Longevity(longevity: "약함", duration: "1~3시간", percent: 33, isAccent: false, isEmpty: false),
                                                       Longevity(longevity: "보통", duration: "3~5시간", percent: 0, isAccent: false, isEmpty: false),
                                                       Longevity(longevity: "강함", duration: "5~7시간", percent: 66, isAccent: true, isEmpty: false),
                                                       Longevity(longevity: "매우 강함", duration: "7시간 이상", percent: 0, isAccent: false, isEmpty: false)],
                                           gender: [Gender(gender: "남성", percent: 100, color: .SNDarkBeige1, isAccent: true),
                                                    Gender(gender: "여성", percent: 0, color: .SNDarkBeige1, isAccent: false),
                                                    Gender(gender: "중성", percent: 0, color: .SNDarkBeige1, isAccent: false)],
                                           isLiked: false, Keywords: ["키워드1", "키워드2"], noteType: 0, ingredients: [Ingredient(part: "Single", ingredient: "꿀, 인센스")],
                                           reviewIdx: 0,
                                           similarPerfumes: [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                             Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                             Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                             Perfume(perfumeIdx: 3, brandName: "라", name: "ㄹ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                             Perfume(perfumeIdx: 4, brandName: "마", name: "ㅁ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)])
  
  static let perfumeDetailWrittenReview = PerfumeDetail(perfumeIdx: 7, name: "154 코롱", brandName: "조 말론", story: "story",
                                                        abundanceRate: "풍부", volumeAndPrice: ["90ml, 50,000원"], imageUrls: [], score: 5.0,
                                                        seasonal: [Seasonal(season: "봄", percent: 50, color: .SNDarkBeige1, isAccent: true),
                                                                   Seasonal(season: "여름", percent: 0, color: .SNDarkBeige1, isAccent: false),
                                                                   Seasonal(season: "가을", percent: 25, color: .SNDarkBeige1, isAccent: false),
                                                                   Seasonal(season: "겨울", percent: 25, color: .SNDarkBeige1, isAccent: false)],
                                                        sillage: [Sillage(sillage: "가벼움", percent: 33, isAccent: false),
                                                                  Sillage(sillage: "보통", percent: 33, isAccent: false),
                                                                  Sillage(sillage: "무거움", percent: 33, isAccent: false)],
                                                        longevity: [Longevity(longevity: "매우 약함", duration: "1시간 이내", percent: 0, isAccent: false, isEmpty: false),
                                                                    Longevity(longevity: "약함", duration: "1~3시간", percent: 33, isAccent: false, isEmpty: false),
                                                                    Longevity(longevity: "보통", duration: "3~5시간", percent: 0, isAccent: false, isEmpty: false),
                                                                    Longevity(longevity: "강함", duration: "5~7시간", percent: 66, isAccent: true, isEmpty: false),
                                                                    Longevity(longevity: "매우 강함", duration: "7시간 이상", percent: 0, isAccent: false, isEmpty: false)],
                                                        gender: [Gender(gender: "남성", percent: 100, color: .SNDarkBeige1, isAccent: true),
                                                                 Gender(gender: "여성", percent: 0, color: .SNDarkBeige1, isAccent: false),
                                                                 Gender(gender: "중성", percent: 0, color: .SNDarkBeige1, isAccent: false)],
                                                        isLiked: false, Keywords: ["키워드1", "키워드2"], noteType: 0, ingredients: [Ingredient(part: "Single", ingredient: "꿀, 인센스")],
                                                        reviewIdx: 10,
                                                        similarPerfumes: [Perfume(perfumeIdx: 0, brandName: "가", name: "ㄱ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                                          Perfume(perfumeIdx: 1, brandName: "나", name: "ㄴ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                                          Perfume(perfumeIdx: 2, brandName: "다", name: "ㄷ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                                          Perfume(perfumeIdx: 3, brandName: "라", name: "ㄹ", imageUrl: "", keywordList: ["향기로움"], isLiked: false),
                                                                          Perfume(perfumeIdx: 4, brandName: "마", name: "ㅁ", imageUrl: "", keywordList: ["향기로움"], isLiked: false)])
  
  static let reviews = [ReviewInPerfumeDetail(idx: 1, score: 5.0, access: true, content: "향이 좋아요", likeCount: 5,
                                              isLiked: false, gender: 1, age: "20대", nickname: "닉네임1", isReported: false),
                        ReviewInPerfumeDetail(idx: 2, score: 4.5, access: true, content: "가격이 좋아요", likeCount: 2,
                                              isLiked: false, gender: 1, age: "20대", nickname: "닉네임2", isReported: false)]
}
