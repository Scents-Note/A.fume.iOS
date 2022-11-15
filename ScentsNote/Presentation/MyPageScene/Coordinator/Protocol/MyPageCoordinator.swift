//
//  MypageCoordinator.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/06.
//

import UIKit

protocol MyPageCoordinator: AnyObject {

  var onOnboardingFlow: (() -> Void)? { get set }

}

