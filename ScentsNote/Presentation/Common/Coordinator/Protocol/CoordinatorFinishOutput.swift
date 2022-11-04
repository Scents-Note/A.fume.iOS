//
//  CoordinatorFinishOutput.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/29.
//

import Foundation

protocol CoordinatorFinishOutput {
    var finishFlow: ((CoordinatorType?) -> Void)? { get set }
}
