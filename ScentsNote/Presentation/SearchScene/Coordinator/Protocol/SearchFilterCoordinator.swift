//
//  SearchFilterCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/24.
//

protocol SearchFilterCoordinator: AnyObject {
  var finishFlow: ((PerfumeSearch?) -> Void)? { get set }
}
