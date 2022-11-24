//
//  SearchResultCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

protocol SearchResultCoordinator: AnyObject {
  var finishFlow: (() -> Void)? { get set }
}
