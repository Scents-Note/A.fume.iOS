//
//  SearchCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

protocol SearchCoordinator: AnyObject {
  func runPerfumeDetailFlow(perfumeIdx: Int)
  func runPerfumeKeywordFlow()
  func runPerfumeResultFlow(perfumeSearch: PerfumeSearch)
//  func showSearchKeywordController()
}
