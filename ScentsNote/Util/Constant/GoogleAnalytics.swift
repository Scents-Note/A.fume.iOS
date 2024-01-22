//
//  Analytics.swift
//  ScentsNote
//
//  Created by Soo on 1/12/24.
//

import Foundation
import FirebaseAnalytics

struct GoogleAnalytics {
    
    private init() {}
    
    struct Screen {
        private init() {}
        // 스플래쉬 화면
        static let loading            = "Loding"
        // 로그인 홈 화면
        static let splash             = "Splash"
        // 로그인 화면
        static let login              = "Login"
        // 회원가입 첫 화면
        static let createAccount      = "CreateAccount"
        // 서베이 페이지 내 > 상단 '향수'
        static let surveyPerfume      = "SurveyPerfume"
        // 서베이 페이지 내 > 상단 '키워드'
        static let surveyKeyword      = "SurveyKeyword"
        // 서베이 페이지 내 > 상단 '계열'
        static let surveyProductLine  = "SurveyProductLine"
        // 홈 화면 페이지
        static let homePage           = "HomePage"
        // 새로 등록된 향수 페이지
        static let newRegister        = "NewRegister"
        // 검색 페이지
        static let search             = "Search"
        // 무엇을 찾으시나요? 검색창 페이지
        static let searchWindow       = "SearchWindow"
        // 필터 페이지
        static let filter             = "Filter"
        // 필터 페이지 내> 상단 '계열'
        static let filterProductLine  = "FilterProductLine"
        // 필터 페이지 내> 상단 '브랜드'
        static let filterBrand        = "FilterBrand"
        // 필터 페이지 내> 상단 '키워드'
        static let filterKeyword      = "FilterKeyword"
        // 검색 결과 페이지
        static let searchResult       = "SearchResult"
        // 검색 결과 없을 경우 페이지
        static let noSearchResult     = "NoSearchResult"
        // 서베이 패ㅔ이지 내 > 상단 '향수'
        static let detailInfo         = "DetailInfo"
        // 시향 노트 쓰기
        static let writeSentsNote     = "WriteSentsNote"
        // 시향 노트 수정
        static let editScentsNote     = "EditScentsNote"
        // 마이 페이지
        static let myPage             = "MyPage"
        // 마이 페이지 내 사이드 바
        static let sidebar            = "Sidebar"
    }
    
    struct Event {
        private init() {}
        
        static let newRegisterButton  = "NewRegisterButton"
        static let navigationSearch   = "NavigationSearch"
        static let navigationMy       = "NavigationMy"
        static let navigationHome     = "NavigationHome"
        static let loupeButton        = "LoupeButton"
        static let searchLoupeButton  = "SearchLoupeButton"
        static let searchBack         = "SearchBack"
        static let searchResultBack   = "SearchResultBack"
        static let searchFilterButton = "SearchFilterButton"
        static let filterActionButton = "FilterActionButton"
        static let filterPauseButton  = "FilterPauseButton"
    }
}

