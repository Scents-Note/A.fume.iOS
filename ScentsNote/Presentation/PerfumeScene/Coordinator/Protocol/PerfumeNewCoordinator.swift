//
//  PerfumeNewCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/23.
//

import Foundation

protocol PerfumeNewCoordinator: AnyObject {
  var runPerfumeDetailFlow: ((Int) -> Void)? { get set }
}
